import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AppConstants {
  // Read production BASE_URL at compile time if supplied:
  // e.g. flutter run --dart-define=BASE_URL=https://api.yourdomain.com/api
  static const String _envBaseUrl = String.fromEnvironment('BASE_URL');

  /// Dynamic Base API URL configuration
  static String get baseUrl {
    // 1. Return build-time override if defined
    if (_envBaseUrl.isNotEmpty) {
      return _envBaseUrl;
    }

    // 2. Web check
    if (kIsWeb) {
      return 'http://localhost:3000/api';
    }

    // 3. Android Emulator check (using TargetPlatform safely)
    if (defaultTargetPlatform == TargetPlatform.android) {
      return 'http://10.0.2.2:3000/api';
    }

    // 4. iOS Simulator, macOS, Windows, Linux fallback
    return 'http://localhost:3000/api';
  }

  // Secure Storage Keys
  static const String tokenKey = 'jwt_token';
  static const String userKey = 'user_data';

  // Base Colors
  static const Color primaryColor = Color(0xFFD97706);
  static const Color primaryTheme = Color(0xFF8D4B00);

  // Light Mode Palette
  static const Color bgLight = Color(0xFFFBF8F3);
  static const Color cardBgLight = Color(0xFFF2EBE1);
  static const Color textPrimaryLight = Color(0xFF1A1C1C);
  static const Color textSecondaryLight = Color(0xFF554336);

  // Dark Mode Palette
  static const Color bgDark = Color(0xFF232220);
  static const Color cardBgDark = Color(0xFF2E2C29);
  static const Color textPrimaryDark = Color(0xFFFBF8F3);
  static const Color textSecondaryDark = Color(0xFFA8A29E);

  // Light ThemeData
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: bgLight,
      colorScheme: const ColorScheme.light(
        primary: primaryColor,
        surface: cardBgLight,
        onSurface: textPrimaryLight,
        onSurfaceVariant: textSecondaryLight,
      ),
      cardColor: cardBgLight,
    );
  }

  // Dark ThemeData
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: bgDark,
      colorScheme: const ColorScheme.dark(
        primary: primaryColor,
        surface: cardBgDark,
        onSurface: textPrimaryDark,
        onSurfaceVariant: textSecondaryDark,
      ),
      cardColor: cardBgDark,
    );
  }
}
