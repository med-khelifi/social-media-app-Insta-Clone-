import 'package:flutter/material.dart';
import 'package:insta/core/tabs/home_screen_tabs.dart';
import 'package:insta/screens/widgets/custom_bottom_nav_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _currentIndex,
        onIndexChanged: (int value) {
          setState(() {
            _currentIndex = value;
          });
        },
      ),
      body: HomeScreenTabs.homeScreenTabs[_currentIndex],
    );
  }
}
