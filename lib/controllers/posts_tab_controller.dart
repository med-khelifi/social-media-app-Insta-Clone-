import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:insta/core/constants/routes.dart';
import 'package:insta/core/firebase/firebase_settings.dart';
import 'package:insta/core/models/post.dart';

class PostsTabController {
  PostsTabController();

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
}
