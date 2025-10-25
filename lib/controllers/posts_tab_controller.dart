import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:insta/core/constants/routes.dart';
import 'package:insta/core/firebase/firebase_settings.dart';
import 'package:insta/core/firebase/firebase_store_methods.dart';
import 'package:insta/core/models/post.dart';

class PostsTabController {
  late FirebaseStoreMethods _firebaseStoreMethods;
  PostsTabController() {
    _firebaseStoreMethods = FirebaseStoreMethods();
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

  void onCommentIconPressed(BuildContext context) {
    Navigator.pushNamed(context, RoutesNames.comments);
  }

  void toggleLike(String postId, String userId) async {
    await _firebaseStoreMethods.togglePostLike(postId, userId);
  }

  bool _isLiked(List<String> likes, String userId) {
    return likes.contains(userId);
  }

  Color getLikeIconColor(List<String> likes, String userId) {
    return _isLiked(likes, userId) ? Colors.red : Colors.white;
  }

  void deletePost(String postId, String userId) =>
      _firebaseStoreMethods.deletePost(postId, userId);
}
