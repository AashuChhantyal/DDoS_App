import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

// AppConstants defining core background and text colors
class AppConstants {
  static const Color lightBackgroundColor = Color(0xFFFBF8F3);
  static const Color darkBackgroundColor = Color(0xFF232220);

  static const Color lightTextColor = Color(0xFF1F1E1D);
  static const Color darkTextColor = Color(0xFFFBF8F3);

  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: lightBackgroundColor,
    textTheme: const TextTheme(bodyLarge: TextStyle(color: lightTextColor)),
  );

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: darkBackgroundColor,
    textTheme: const TextTheme(bodyLarge: TextStyle(color: darkTextColor)),
  );
}

// Sample view using AppConstants themes
class DoseDashboardView extends StatelessWidget {
  const DoseDashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          'Daily Dose Dashboard',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ),
    );
  }
}

void main() {
  group('AppConstants Dark Mode & Theme Styling Tests', () {
    testWidgets(
      'Renders correct light background color (#FBF8F3) in Light Mode',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            theme: AppConstants.lightTheme,
            darkTheme: AppConstants.darkTheme,
            themeMode: ThemeMode.light,
            home: const DoseDashboardView(),
          ),
        );

        final BuildContext scaffoldContext = tester.element(
          find.byType(Scaffold),
        );
        final themeColor = Theme.of(scaffoldContext).scaffoldBackgroundColor;

        expect(themeColor, equals(AppConstants.lightBackgroundColor));
      },
    );

    testWidgets(
      'Renders correct dark background color (#232220) in Dark Mode',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            theme: AppConstants.lightTheme,
            darkTheme: AppConstants.darkTheme,
            themeMode: ThemeMode.dark,
            home: const DoseDashboardView(),
          ),
        );

        final BuildContext scaffoldContext = tester.element(
          find.byType(Scaffold),
        );
        final themeColor = Theme.of(scaffoldContext).scaffoldBackgroundColor;

        expect(themeColor, equals(AppConstants.darkBackgroundColor));
      },
    );

    testWidgets(
      'Dynamically updates background color when theme mode switches',
      (WidgetTester tester) async {
        ThemeMode currentMode = ThemeMode.light;

        await tester.pumpWidget(
          StatefulBuilder(
            builder: (context, setState) {
              return MaterialApp(
                theme: AppConstants.lightTheme,
                darkTheme: AppConstants.darkTheme,
                themeMode: currentMode,
                home: Scaffold(
                  body: TextButton(
                    onPressed: () {
                      setState(() {
                        currentMode = currentMode == ThemeMode.light
                            ? ThemeMode.dark
                            : ThemeMode.light;
                      });
                    },
                    child: const Text('Toggle Theme'),
                  ),
                ),
              );
            },
          ),
        );

        // Verify initial light theme
        var scaffoldContext = tester.element(find.byType(Scaffold));
        expect(
          Theme.of(scaffoldContext).scaffoldBackgroundColor,
          equals(AppConstants.lightBackgroundColor),
        );

        // Tap button to toggle to dark theme
        await tester.tap(find.byType(TextButton));
        await tester.pumpAndSettle();

        // Verify updated dark theme
        scaffoldContext = tester.element(find.byType(Scaffold));
        expect(
          Theme.of(scaffoldContext).scaffoldBackgroundColor,
          equals(AppConstants.darkBackgroundColor),
        );
      },
    );
  });
}
