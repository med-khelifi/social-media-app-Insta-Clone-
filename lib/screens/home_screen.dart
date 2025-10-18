import 'package:flutter/material.dart';
import 'package:insta/screens/widgets/custom_bottom_nav_bar.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CustomBottomNavBar(),
      body: const Center(
        child: Text('Home Screen'),
      ),
    );
  }
}