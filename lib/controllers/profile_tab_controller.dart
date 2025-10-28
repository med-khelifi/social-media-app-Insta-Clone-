import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:insta/core/constants/colors.dart';
import 'package:insta/core/constants/routes.dart';
import 'package:insta/core/constants/strings.dart';
import 'package:insta/core/firebase/firebase_store_methods.dart';
import 'package:insta/core/models/post.dart';

class ProfileTabController {
  late FirebaseStoreMethods _firebaseStoreMethods;
  bool isFollowingThisUser = false;
  ProfileTabController() {
    _firebaseStoreMethods = FirebaseStoreMethods();
  }
  void init() {}
  void dispose() {}

  void onSignOutPressed(BuildContext context) async {
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
        // ignore: use_build_context_synchronously
        Navigator.pushReplacementNamed(context, RoutesNames.login);
      } catch (error) {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(
          // ignore: use_build_context_synchronously
          context,
        ).showSnackBar(SnackBar(content: Text('Error signing out: $error')));
      }
    }
  }

  Future<List<PostModel>> getUserPost({String? userId}) {
    return _firebaseStoreMethods.getUserPosts(uid: userId);
  }

  Future<void> _followUser(String userId) async {
    await _firebaseStoreMethods.followUser(userId);
  }

  Future<void> _unfollowUser(String userId) async {
    await _firebaseStoreMethods.unfollowUser(userId);
  }

  Future<bool> _isFollowing(String userId) async {
    return await _firebaseStoreMethods.isFollowing(userId);
  }

  void handleFollowing(String userId) async {
    bool re = await _isFollowing(userId);
    if (re) {
      await _unfollowUser(userId);
    } else {
      await _followUser(userId);
    }
  }

  Future<Color> handelColor(String userId)  async {
    bool re = await _isFollowing(userId);
    if (re) {
      return ColorsManager.grey;
    } else {
      return ColorsManager.red;
    }
  }
  Future<String> handelTextFollowUnfollow(String userId) async {
    bool re = await _isFollowing(userId);
    if (!re) {
      return "follow";
    } else {
      return "unfollow";
    }
  }
  Future<int> getUserPostsCount({String? uid}) async{
    return await _firebaseStoreMethods.getUserPostsCount(uid: uid);
  }
}
