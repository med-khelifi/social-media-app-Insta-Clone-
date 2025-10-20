import 'package:flutter/widgets.dart';
import 'package:insta/screens/home/tabs/add_new_post_tab.dart';
import 'package:insta/screens/home/tabs/posts_tab.dart';
import 'package:insta/screens/home/tabs/profile_tab.dart';
import 'package:insta/screens/home/tabs/search_tab.dart';

class HomeScreenTabs {
  static List<Widget> homeScreenTabs = [
    const PostsTab(),
    const SearchTab(),
    const AddNewPostTab(),
    const ProfileTab(),
  ];
}
