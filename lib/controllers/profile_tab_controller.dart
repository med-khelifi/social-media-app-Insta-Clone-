import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:insta/core/constants/routes.dart';
import 'package:insta/core/constants/strings.dart';
import 'package:insta/core/firebase/firebase_auth_settings.dart';
import 'package:insta/core/firebase/firebase_store_methods.dart';
import 'package:insta/core/models/post.dart';
import 'package:insta/core/models/story.dart';

class ProfileTabController {
  late FirebaseStoreMethods _firebaseStoreMethods;
  ProfileTabController() {
    _firebaseStoreMethods = FirebaseStoreMethods();
  }

  void init() {}
  void dispose() {}

  Future<void> onSignOutPressed(BuildContext context) async {
    final bool? res = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(Strings.signout),
          content: const Text(Strings.areUSureToSignout),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text(Strings.cancel),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text(Strings.signout),
            ),
          ],
        );
      },
    );

    if (res == true) {
      try {
        await FirebaseAuth.instance.signOut();
        Navigator.pushReplacementNamed(context, RoutesNames.login);
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error signing out: $error')),
        );
      }
    }
  }

  Future<List<PostModel>> getUserPost({String? userId}) {
    return _firebaseStoreMethods.getUserPosts(uid: userId);
  }

  Future<bool> handleFollowing(String userId) async {
    try {
      final currentlyFollowing = await _firebaseStoreMethods.isFollowing(userId);
      if (currentlyFollowing) {
        await _firebaseStoreMethods.unfollowUser(userId);
        return false;
      } else {
        await _firebaseStoreMethods.followUser(userId);
        return true;
      }
    } catch (e) {
      rethrow;
    }
  }

  void goToAddNewScreen(BuildContext context) {
    Navigator.pushNamed(context, RoutesNames.addNewStory);
  }

  Future<List<StoryModel>> getUserStories({String? uid}) async =>
      _firebaseStoreMethods.getUserStories(uid ?? FirebaseAuthSettings.currentUserId);

  void goToStoryViewScreen(BuildContext context, List<StoryModel> stories) {
    Navigator.pushNamed(context, RoutesNames.storyView, arguments: stories);
  }
}