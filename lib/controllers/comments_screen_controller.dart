import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:insta/core/firebase/firebase_settings.dart';
import 'package:insta/core/firebase/firebase_store_methods.dart';
import 'package:insta/core/models/comment.dart';
import 'package:insta/core/provider/user_provider.dart';
import 'package:insta/core/util/util.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class CommentsScreenController {
  late TextEditingController commentController;
  late String postId;
  late final FirebaseStoreMethods _firebaseStoreMethods;
  CommentsScreenController(this.postId) {
    commentController = TextEditingController();
    _firebaseStoreMethods = FirebaseStoreMethods();
  }

  Stream<List<CommentModel>> getPostComments() {
    return FirebaseFirestore.instance
        .collection(FirebaseSettings.commentsCollection)
        .orderBy('createdAt', descending: true)
        .where('postId', isEqualTo: postId)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => CommentModel.fromDocument(doc))
              .toList(),
        );
  }
  String? getCurrentUserImage(BuildContext context){
    final userProvider = context.read<UserProvider>();
      userProvider.getUserData();
      final user = userProvider.getUser;
      if (user == null) return null;
      return user.profileImageUrl;
  }
  void addComment({required BuildContext context}) async {
    try {
      final userProvider = context.read<UserProvider>();
      userProvider.getUserData();
      final user = userProvider.getUser;
      if (user == null) return;

      CommentModel comment = CommentModel(
        id: Uuid().v4(),
        postId: postId,
        userId: user.uid,
        username: user.username,
        userImage: user.profileImageUrl ?? "",
        text: commentController.text.trim(),
        createdAt: DateTime.now(),
      );
      await _firebaseStoreMethods.addComment(comment);
      commentController.clear();
      if (context.mounted) {
        Util.showSnackBar("Comment Added", context: context);
      }
    } catch (e) {
      if (context.mounted) {
        Util.showSnackBar("error: ${e.toString()}", context: context);
      }
    }
  }
}
