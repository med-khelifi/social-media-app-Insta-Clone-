import 'package:flutter/material.dart';
import 'package:insta/core/constants/colors.dart';

class CustomBottomNavBar extends StatelessWidget {
  const CustomBottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      showUnselectedLabels: false,
      showSelectedLabels: true,
      selectedLabelStyle: const TextStyle(color: ColorsManager.white),
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home, color: ColorsManager.white),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.search, color: ColorsManager.white),
          label: 'Search',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.add, color: ColorsManager.white),
          label: 'New post',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person, color: ColorsManager.white),
          label: 'Profile',
        ),
      ],
    );
  }
}
