import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:insta/core/firebase/firebase_auth_settings.dart';
import 'package:insta/core/firebase/firebase_settings.dart';
import 'package:insta/core/models/comment.dart';
import 'package:insta/core/models/post.dart';
import 'package:insta/core/models/user.dart';

class FirebaseStoreMethods {
  Future<UserModel> getCurrentUserData({String? uid}) async {
    DocumentSnapshot<Map<String, dynamic>> user = await FirebaseFirestore
        .instance
        .collection(FirebaseSettings.usersCollection)
        .doc(uid ?? FirebaseAuthSettings.currentUserId)
        .get();

    UserModel? userModel = UserModel.fromDocument(user);
    return userModel;
  }
  Future<List<PostModel>> getUserPosts({String? uid}) async {
    var userId = uid ?? FirebaseAuthSettings.currentUserId;
    QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
        .instance
        .collection(FirebaseSettings.postsCollection)
        .where("userId", isEqualTo: userId)
        .get();

    List<PostModel> posts = snapshot.docs.map((e) => PostModel.fromJson(e.data())).toList();
    return posts;
  }
  Stream<List<UserModel>> getSearchedUserData(String userName) {
    return FirebaseFirestore
        .instance
        .collection(FirebaseSettings.usersCollection)
        .where("username", isGreaterThanOrEqualTo: userName)
        .where("username", isLessThan: '${userName}z')
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((e) => UserModel.fromDocument(e)).toList());
  }

  void addPost(PostModel post) async {
    await FirebaseFirestore.instance
        .collection(FirebaseSettings.postsCollection)
        .doc(post.id)
        .set(post.toJson());
  }

  Future<void> togglePostLike(String postId) async {
    final postRef = FirebaseFirestore.instance
        .collection(FirebaseSettings.postsCollection)
        .doc(postId);

    DocumentSnapshot postDoc = await postRef.get();

    if (postDoc.exists) {
      List likes = (postDoc.data() as Map<String, dynamic>)['likes'] ?? [];

      if (likes.contains(FirebaseAuthSettings.currentUserId)) {
        await postRef.update({
          'likes': FieldValue.arrayRemove([FirebaseAuthSettings.currentUserId,]),
        });
      } else {
        await postRef.update({
          'likes': FieldValue.arrayUnion([FirebaseAuthSettings.currentUserId,]),
        });
      }
    }
  }
  Future<void> toggleCommentLike(String commentId) async {
    final postRef = FirebaseFirestore.instance
        .collection(FirebaseSettings.commentsCollection)
        .doc(commentId);

    DocumentSnapshot postDoc = await postRef.get();

    if (postDoc.exists) {
      List likes = (postDoc.data() as Map<String, dynamic>)['likes'] ?? [];

      if (likes.contains(FirebaseAuthSettings.currentUserId,)) {
        await postRef.update({
          'likes': FieldValue.arrayRemove([FirebaseAuthSettings.currentUserId,]),
        });
      } else {
        await postRef.update({
          'likes': FieldValue.arrayUnion([FirebaseAuthSettings.currentUserId,]),
        });
      }
    }
  }

  Future<void> deletePost(String postId) async {
    if (FirebaseAuthSettings.currentUserId == FirebaseAuthSettings.currentUserId) {
      await FirebaseFirestore.instance
          .collection(FirebaseSettings.postsCollection)
          .doc(postId)
          .delete();
    }
  }
  Future<void> deleteComments(String commentId) async {
    if (FirebaseAuthSettings.currentUserId == FirebaseAuthSettings.currentUserId) {
      await FirebaseFirestore.instance
          .collection(FirebaseSettings.commentsCollection)
          .doc(commentId)
          .delete();
    }
  }

  Future<void> addComment(CommentModel comment) async {
    await FirebaseFirestore.instance
        .collection(FirebaseSettings.commentsCollection)
        .doc(comment.id)
        .set(comment.toMap());
  }


}
