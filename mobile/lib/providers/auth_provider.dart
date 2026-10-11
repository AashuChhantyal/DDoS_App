import 'dart:async';
import 'package:flutter/material.dart';
import '../models/user.dart';
import '../services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();

  User? _user;
  bool _isLoading = false;
  bool _isAuthenticated = false;

  User? get user => _user;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _isAuthenticated;

  /// Returns remaining time in seconds for the completion delay timer
  Duration get remainingDelayDuration {
    if (_user?.lastCompletedAt == null) return Duration.zero;
    final targetTime = _user!.lastCompletedAt!.add(const Duration(seconds: 5));
    final remaining = targetTime.difference(DateTime.now());
    return remaining.isNegative ? Duration.zero : remaining;
  }

  /// Records timestamp, increments daily progress, and schedules automatic streak update
  Future<void> recordActionTimestamp() async {
    if (_user == null) return;
    final now = DateTime.now();
    await _authService.saveActionTimestamp();

    _user = _user!.copyWith(
      lastCompletedAt: now,
      dailyProgress: (_user!.dailyProgress + 1).clamp(0, _user!.dailyGoal),
    );
    await _authService.updateStoredUser(_user!);
    notifyListeners();

    // Auto-trigger streak check after the 5-second delay completes
    Future.delayed(const Duration(seconds: 5), () async {
      await checkAndUpdateStreak();
    });
  }

  /// Evaluates 5-second threshold window to update active streak counter
  Future<void> checkAndUpdateStreak({
    Duration threshold = const Duration(seconds: 5),
  }) async {
    if (_user == null) return;

    final lastTimestamp = await _authService.getActionTimestamp();
    if (lastTimestamp != null) {
      final difference = DateTime.now().difference(lastTimestamp);
      if (difference >= threshold) {
        // Increment streak starting from 0 to 1, or add 1 to existing streak
        final nextStreak = _user!.streakDays == 0 ? 1 : _user!.streakDays + 1;

        _user = _user!.copyWith(streakDays: nextStreak);
        await _authService.clearActionTimestamp();
        await _authService.updateStoredUser(_user!);
        notifyListeners();
      }
    }
  }

  Future<void> checkAuthStatus() async {
    _isLoading = true;
    notifyListeners();

    try {
      _isAuthenticated = await _authService.isAuthenticated();
      if (_isAuthenticated) {
        _user = await _authService.getCurrentUser();
        await checkAndUpdateStreak();
      }
    } catch (e) {
      _isAuthenticated = false;
      _user = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();

    try {
      final loggedInUser = await _authService.login(email, password);
      if (loggedInUser != null) {
        _user = loggedInUser;
        _isAuthenticated = true;
        await checkAndUpdateStreak();
        notifyListeners();
        return true;
      }
    } catch (e) {
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
    return false;
  }

  Future<bool> register(String name, String email, String password) async {
    _isLoading = true;
    notifyListeners();

    try {
      final newUser = await _authService.register(name, email, password);
      if (newUser != null) {
        _user = newUser;
        _isAuthenticated = true;
        notifyListeners();
        return true;
      }
    } catch (e) {
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
    return false;
  }

  Future<void> logout() async {
    await _authService.logout();
    _user = null;
    _isAuthenticated = false;
    notifyListeners();
  }
}
