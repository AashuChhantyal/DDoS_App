import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/progress_model.dart';

class ProgressProvider with ChangeNotifier {
  ProgressData? _progressData;
  bool _isLoading = false;
  String? _errorMessage;

  ProgressData? get progressData => _progressData;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchProgressData() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Replace URL with your actual API endpoint and include authorization headers if required
      final response = await http.get(
        Uri.parse('https://api.example.com/user/progress'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        _progressData = ProgressData.fromJson(data);
      } else {
        _errorMessage =
            'Failed to load progress (Status: ${response.statusCode})';
      }
    } catch (e) {
      _errorMessage = 'Network error occurred: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
