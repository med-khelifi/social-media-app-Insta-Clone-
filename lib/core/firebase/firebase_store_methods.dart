import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:insta/core/firebase/firebase_settings.dart';
import 'package:insta/core/models/post.dart';
import 'package:insta/core/models/user.dart';

class FirebaseStoreMethods {
  Future<UserModel> getCurrentUserData() async {
    DocumentSnapshot<Map<String, dynamic>> user = await FirebaseFirestore
        .instance
        .collection(FirebaseSettings.usersCollection)
        .doc(FirebaseAuthSettings.currentUserId)
        .get();

    UserModel? userModel = UserModel.fromDocument(user);
    return userModel;
  }

  void addPost(PostModel post) async {
    await FirebaseFirestore.instance
        .collection(FirebaseSettings.postsCollection)
        .doc(post.id)
        .set(post.toJson());
  }

  Future<void> togglePostLike(String postId, String userId) async {
    final postRef = FirebaseFirestore.instance
        .collection(FirebaseSettings.postsCollection)
        .doc(postId);

    DocumentSnapshot postDoc = await postRef.get();

    if (postDoc.exists) {
      List likes = (postDoc.data() as Map<String, dynamic>)['likes'] ?? [];

      if (likes.contains(userId)) {
        await postRef.update({
          'likes': FieldValue.arrayRemove([userId]),
        });
      } else {
        await postRef.update({
          'likes': FieldValue.arrayUnion([userId]),
        });
      }
    }
  }

  Future<void> deletePost(String postId, String userId) async {
    if (FirebaseAuthSettings.currentUserId == userId) {
      await FirebaseFirestore.instance
          .collection(FirebaseSettings.postsCollection)
          .doc(postId)
          .delete();
    }
  }
}
