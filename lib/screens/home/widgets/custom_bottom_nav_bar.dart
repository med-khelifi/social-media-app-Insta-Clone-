import 'package:flutter/material.dart';
import 'package:insta/core/constants/colors.dart';

class CustomBottomNavBar extends StatelessWidget {
  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onIndexChanged,
  });
  final int currentIndex;
  final ValueChanged<int> onIndexChanged;
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onIndexChanged,
      selectedItemColor: ColorsManager.white,
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
