import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:insta/core/firebase/firebase_auth_settings.dart';
import 'package:insta/core/firebase/firebase_settings.dart';
import 'package:insta/core/models/comment.dart';
import 'package:insta/core/models/post.dart';
import 'package:insta/core/models/story.dart';
import 'package:insta/core/models/user.dart';
import 'package:uuid/uuid.dart';

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

    List<PostModel> posts = snapshot.docs
        .map((e) => PostModel.fromJson(e.data()))
        .toList();
    return posts;
  }

  Stream<List<UserModel>> getSearchedUserData(String userName) {
    return FirebaseFirestore.instance
        .collection(FirebaseSettings.usersCollection)
        .where("username", isGreaterThanOrEqualTo: userName)
        .where("username", isLessThan: '${userName}z')
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((e) => UserModel.fromDocument(e))
              .where((user) => user.uid != FirebaseAuthSettings.currentUserId)
              .toList(),
        );
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
          'likes': FieldValue.arrayRemove([FirebaseAuthSettings.currentUserId]),
        });
      } else {
        await postRef.update({
          'likes': FieldValue.arrayUnion([FirebaseAuthSettings.currentUserId]),
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

      if (likes.contains(FirebaseAuthSettings.currentUserId)) {
        await postRef.update({
          'likes': FieldValue.arrayRemove([FirebaseAuthSettings.currentUserId]),
        });
      } else {
        await postRef.update({
          'likes': FieldValue.arrayUnion([FirebaseAuthSettings.currentUserId]),
        });
      }
    }
  }

  Future<void> deletePost(String postId) async {
    if (FirebaseAuthSettings.currentUserId ==
        FirebaseAuthSettings.currentUserId) {
      await FirebaseFirestore.instance
          .collection(FirebaseSettings.postsCollection)
          .doc(postId)
          .delete();
    }
  }

  Future<void> deleteComments(String commentId) async {
    if (FirebaseAuthSettings.currentUserId ==
        FirebaseAuthSettings.currentUserId) {
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

  Future<void> followUser(String uid) async {
    await FirebaseFirestore.instance
        .collection(FirebaseSettings.usersCollection)
        .doc(uid)
        .update({
          'followers': FieldValue.arrayUnion([
            FirebaseAuthSettings.currentUserId,
          ]),
        });

    await FirebaseFirestore.instance
        .collection(FirebaseSettings.usersCollection)
        .doc(FirebaseAuthSettings.currentUserId)
        .update({
          'following': FieldValue.arrayUnion([uid]),
        });
  }

  Future<void> unfollowUser(String uid) async {
    await FirebaseFirestore.instance
        .collection(FirebaseSettings.usersCollection)
        .doc(uid)
        .update({
          'followers': FieldValue.arrayRemove([
            FirebaseAuthSettings.currentUserId,
          ]),
        });

    await FirebaseFirestore.instance
        .collection(FirebaseSettings.usersCollection)
        .doc(FirebaseAuthSettings.currentUserId)
        .update({
          'following': FieldValue.arrayRemove([uid]),
        });
  }

  Future<bool> isFollowing(String uid) async {
    DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection(FirebaseSettings.usersCollection)
        .doc(FirebaseAuthSettings.currentUserId)
        .get();

    List following =
        (userDoc.data() as Map<String, dynamic>)['following'] ?? [];
    return following.contains(uid);
  }

  Future<int> getUserPostsCount({String? uid}) async {
    var userId = uid ?? FirebaseAuthSettings.currentUserId;
    QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
        .instance
        .collection(FirebaseSettings.postsCollection)
        .where("userId", isEqualTo: userId)
        .get();

    return snapshot.docs.length;
  }

  Future<void> uploadStory({
    required bool isImage,
    required String fileUrl,
  }) async {
    final story = StoryModel(
      id: Uuid().v4(),
      userId: FirebaseAuthSettings.currentUserId,
      imageUrl: fileUrl,
      createdAt: DateTime.now(),
      isVideo: !isImage,
    );

    await FirebaseFirestore.instance
        .collection(FirebaseSettings.storiesCollection)
        .doc(story.id)
        .set(story.toMap());
  }
}
