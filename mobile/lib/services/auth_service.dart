import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/user.dart';
import '../utils/constants.dart';
import 'dio_client.dart';

class AuthService {
  final DioClient _dioClient = DioClient();
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  static const String _actionTimestampKey = 'last_action_timestamp';

  Future<User?> register(String name, String email, String password) async {
    try {
      final response = await _dioClient.dio.post(
        '/auth/register',
        data: {'name': name, 'email': email, 'password': password},
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        final data = response.data;

        final token =
            data['token'] ??
            (data['data'] != null ? data['data']['token'] : null);
        final userData =
            data['user'] ??
            (data['data'] != null ? data['data']['user'] : null);

        if (token != null && userData != null) {
          await _storage.write(key: AppConstants.tokenKey, value: token);
          final user = User.fromJson(userData);
          await updateStoredUser(user);
          return user;
        } else if (userData != null) {
          return User.fromJson(userData);
        }
      }
    } on DioException catch (e) {
      final errorMsg =
          e.response?.data['error'] ??
          e.response?.data['message'] ??
          'Registration failed.';
      throw Exception(errorMsg);
    } catch (e) {
      throw Exception('Registration failed: ${e.toString()}');
    }
    return null;
  }

  Future<User?> login(String email, String password) async {
    try {
      final response = await _dioClient.dio.post(
        '/auth/login',
        data: {'email': email, 'password': password},
      );

      if (response.statusCode == 200) {
        final data = response.data;
        final token =
            data['token'] ??
            (data['data'] != null ? data['data']['token'] : null);
        final userData =
            data['user'] ??
            (data['data'] != null ? data['data']['user'] : null);

        if (token != null && userData != null) {
          await _storage.write(key: AppConstants.tokenKey, value: token);
          final user = User.fromJson(userData);
          await updateStoredUser(user);
          return user;
        }
      }
    } on DioException catch (e) {
      final errorMsg =
          e.response?.data['error'] ??
          e.response?.data['message'] ??
          'Invalid credentials.';
      throw Exception(errorMsg);
    } catch (e) {
      throw Exception('Login failed: ${e.toString()}');
    }
    return null;
  }

  Future<void> logout() async {
    await _storage.delete(key: AppConstants.tokenKey);
    await _storage.delete(key: AppConstants.userKey);
    await clearActionTimestamp();
  }

  Future<User?> getCurrentUser() async {
    final userStr = await _storage.read(key: AppConstants.userKey);
    if (userStr != null) {
      return User.fromJson(jsonDecode(userStr));
    }
    return null;
  }

  Future<bool> isAuthenticated() async {
    final token = await _storage.read(key: AppConstants.tokenKey);
    return token != null && token.isNotEmpty;
  }

  /// Saves updated user details to local storage
  Future<void> updateStoredUser(User user) async {
    await _storage.write(
      key: AppConstants.userKey,
      value: jsonEncode(user.toJson()),
    );
  }

  /// Stores current DateTime for delayed streak processing
  Future<void> saveActionTimestamp() async {
    await _storage.write(
      key: _actionTimestampKey,
      value: DateTime.now().toIso8601String(),
    );
  }

  /// Retrieves the saved action timestamp
  Future<DateTime?> getActionTimestamp() async {
    final str = await _storage.read(key: _actionTimestampKey);
    if (str != null) {
      return DateTime.tryParse(str);
    }
    return null;
  }

  /// Clears saved action timestamp
  Future<void> clearActionTimestamp() async {
    await _storage.delete(key: _actionTimestampKey);
  }
}
