import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:insta/core/constants/colors.dart';
import 'package:insta/core/constants/routes.dart';
import 'package:insta/core/constants/strings.dart';
import 'package:insta/core/firebase/firebase_store_methods.dart';
import 'package:insta/core/models/post.dart';

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

  Future<void> _followUser(String userId) async {
    await _firebaseStoreMethods.followUser(userId);
  }

  Future<void> _unfollowUser(String userId) async {
    await _firebaseStoreMethods.unfollowUser(userId);
  }

  Future<bool> _isFollowing(String userId) async {
    return await _firebaseStoreMethods.isFollowing(userId);
  }

  /// <- الآن ترجع Future<bool> (true => now following, false => now not following)
  Future<bool> handleFollowing(String userId) async {
    try {
      final currentlyFollowing = await _isFollowing(userId);
      if (currentlyFollowing) {
        await _unfollowUser(userId);
        return false;
      } else {
        await _followUser(userId);
        return true;
      }
    } catch (e) {
      // يمكنك هنا تسجيل الخطأ أو إعادة رميه حسب الحاجة
      rethrow;
    }
  }

  Future<Color> handelColor(String userId) async {
    try {
      bool re = await _isFollowing(userId);
      return re ? ColorsManager.grey : ColorsManager.red;
    } catch (_) {
      return ColorsManager.grey;
    }
  }

  Future<String> handelTextFollowUnfollow(String userId) async {
    try {
      bool re = await _isFollowing(userId);
      return re ? "unfollow" : "follow";
    } catch (_) {
      return "follow";
    }
  }

  Future<int> getUserPostsCount({String? uid}) async {
    return await _firebaseStoreMethods.getUserPostsCount(uid: uid);
  }

  void goToAddNewScreen(BuildContext context) {
    Navigator.pushNamed(context, RoutesNames.addNewStory);
  }
}
