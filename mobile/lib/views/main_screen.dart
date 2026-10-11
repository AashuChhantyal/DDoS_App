import 'package:flutter/material.dart';
import 'explore/explore_screen.dart'; // Adjust path if needed
import '../utils/constants.dart';
import 'daily_dose/daily_dose_screen.dart';
import 'profile/profile_screen.dart'; // Adjust path if profile_screen is inside views or screens
import 'home/home_screen.dart';
import 'progress/progress_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0; // Starts at Home Feed (0)

  final List<Widget> _pages = [
    const HomeScreen(),
    const ExploreScreen(),
    const DailyDoseScreen(), // Placed actual Daily Dose widget here
    const ProgressScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _pages),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        selectedItemColor: AppConstants.primaryColor,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.explore), label: 'Explore'),
          BottomNavigationBarItem(
            icon: Icon(Icons.electric_bolt),
            label: 'Daily Dose',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: 'Progress',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
