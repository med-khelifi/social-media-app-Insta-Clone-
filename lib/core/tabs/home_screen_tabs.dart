import 'package:flutter/widgets.dart';
import 'package:insta/screens/home/tabs/posts_tab.dart';
import 'package:insta/screens/home/tabs/search_tab.dart';

class HomeScreenTabs {
  static List<Widget> homeScreenTabs = [
    const PostsTab(),
    const SearchTab(),
    const Center(child: Text('New Post Tab')),
    const Center(child: Text('Profile Tab')),
  ];
}
