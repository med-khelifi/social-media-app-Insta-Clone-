import 'package:flutter/material.dart';
import 'package:insta/core/constants/routes.dart';

class PostsTabController {
  PostsTabController();
  void onCommentIconPressed(BuildContext context){
    Navigator.pushNamed(context, RoutesNames.comments);
  }
}
