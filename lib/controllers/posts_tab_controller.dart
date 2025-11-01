import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:insta/core/constants/routes.dart';
import 'package:insta/core/constants/strings.dart';
import 'package:insta/core/firebase/firebase_auth_settings.dart';
import 'package:insta/core/firebase/firebase_settings.dart';
import 'package:insta/core/firebase/firebase_store_methods.dart';
import 'package:insta/core/models/post.dart';
import 'package:insta/core/models/story.dart';
import 'package:insta/core/supabase/supabase_storage_service.dart';
import 'package:insta/core/util/util.dart';
import 'package:insta/screens/home/tabs/profile_tab.dart';

class PostsTabController {
  late FirebaseStoreMethods _firebaseStoreMethods;
  late SupabaseStorageService _storageService;

  bool showDeleteIcon(String postCreatedByUserId) =>
      FirebaseAuthSettings.currentUserId == postCreatedByUserId;
  PostsTabController() {
    _firebaseStoreMethods = FirebaseStoreMethods();
    _storageService = SupabaseStorageService();
  }

  Stream<List<PostModel>> get postsStream {
    return FirebaseFirestore.instance
        .collection(FirebaseSettings.postsCollection)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => PostModel.fromJson(doc.data()))
              .toList(),
        );
  }

  void onCommentIconPressed(BuildContext context, String postId) {
    Navigator.pushNamed(
      context,
      RoutesNames.comments,
      arguments: {"postId": postId},
    );
  }

  void toggleLike(String postId) async {
    await _firebaseStoreMethods.togglePostLike(postId);
  }

  bool _isLiked(List<String> likes) {
    return likes.contains(FirebaseAuthSettings.currentUserId);
  }

  Color getLikeIconColor(List<String> likes) {
    return _isLiked(likes) ? Colors.red : Colors.white;
  }

  void deletePost(BuildContext context, String postId, String imagePath) async {
    if (imagePath.isNotEmpty) {
      var res = await _storageService.deleteImage(context, imagePath);
      if (!res.$1) {
        if (context.mounted) {
          Util.showSnackBar("Error : ${res.$2!}", context: context);
        }
      }
    }

    await _firebaseStoreMethods.deletePost(postId);
    if (context.mounted) {
      Util.showSnackBar(Strings.postDeleted, context: context);
    }
  }

  Stream<Map<String, List<StoryModel>>>
  getStoriesForCurrentUserAndFollowingsStream() {
    return _firebaseStoreMethods.getStoriesForCurrentUserAndFollowingsStream();
  }

  void onProfileIconPressed(BuildContext context, String userId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          body: SafeArea(child: ProfileTab(userId: userId)),
        ),
      ),
    );
  }
}
