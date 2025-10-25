import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:insta/core/constants/routes.dart';
import 'package:insta/core/constants/strings.dart';
import 'package:insta/core/firebase/firebase_settings.dart';
import 'package:insta/core/firebase/firebase_store_methods.dart';
import 'package:insta/core/models/post.dart';
import 'package:insta/core/supabase/supabase_storage_service.dart';
import 'package:insta/core/util/util.dart';

class PostsTabController {
  late FirebaseStoreMethods _firebaseStoreMethods;
  late SupabaseStorageService _storageService;
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

  void deletePost(
    BuildContext context,
    String postId,
    String userId,
    String imagePath,
  ) async {
    if (imagePath.isNotEmpty) {
      var res = await _storageService.deleteImage(context, imagePath);
      if (!res.$1) {
        if (context.mounted) {
          Util.showSnackBar("Error : ${res.$2!}", context: context);
        }
      }
    }

    await _firebaseStoreMethods.deletePost(postId, userId);
    if (context.mounted) {
      Util.showSnackBar(Strings.postDeleted, context: context);
    }
  }
}
