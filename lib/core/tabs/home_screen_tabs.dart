import 'package:flutter/widgets.dart';
import 'package:insta/screens/home/tabs/posts_tab.dart';

class HomeScreenTabs {
  static List<Widget> homeScreenTabs = [
    const PostsTab(),
    const Center(child: Text('Search Tab')),
    const Center(child: Text('New Post Tab')),
    const Center(child: Text('Profile Tab')),
  ];
}