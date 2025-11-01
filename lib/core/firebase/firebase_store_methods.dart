import 'package:async/async.dart';
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
    required String imageUrl,
    required String username,
    
  }) async {
    final story = StoryModel(
      id: Uuid().v4(),
      userId: FirebaseAuthSettings.currentUserId,
      imageUrl: imageUrl,
      createdAt: DateTime.now(),
      isVideo: !isImage,
      contentUrl: fileUrl,
      username: username,
    );

    await FirebaseFirestore.instance
        .collection(FirebaseSettings.storiesCollection)
        .doc(story.id)
        .set(story.toMap());
  }

  Stream<Map<String, List<StoryModel>>>
  getStoriesForCurrentUserAndFollowingsStream() async* {
    final String currentUserId = FirebaseAuthSettings.currentUserId;

    final userDoc = await FirebaseFirestore.instance
        .collection(FirebaseSettings.usersCollection)
        .doc(currentUserId)
        .get();

    List<String> followings = List<String>.from(
      userDoc.data()?['following'] ?? [],
    );
    followings.add(currentUserId);

    // 🔹 تقسيم المتابعين إلى مجموعات من 10 IDs
    List<List<String>> chunks = [];
    for (var i = 0; i < followings.length; i += 10) {
      chunks.add(
        followings.sublist(
          i,
          i + 10 > followings.length ? followings.length : i + 10,
        ),
      );
    }

    // 🔹 لكل مجموعة نعمل Stream
    List<Stream<QuerySnapshot<Map<String, dynamic>>>> streams = chunks
        .map(
          (chunk) => FirebaseFirestore.instance
              .collection(FirebaseSettings.storiesCollection)
              .where('userId', whereIn: chunk)
              .orderBy('createdAt', descending: true)
              .snapshots(),
        )
        .toList();

    // 🔹 دمج كل Streams في Stream واحد
    yield* StreamGroup.merge(streams).asyncMap((snapshot) async {
      final stories = snapshot.docs
          .map((doc) => StoryModel.fromMap(doc.data()))
          .toList();

      Map<String, List<StoryModel>> result = {};
      for (var story in stories) {
        result[story.userId] ??= [];
        result[story.userId]!.add(story);
      }

      // ترتيب بحيث تكون قصص المستخدم الحالي في البداية
      final sortedKeys = result.keys.toList()
        ..sort((a, b) {
          if (a == currentUserId) return -1;
          if (b == currentUserId) return 1;
          return 0;
        });

      Map<String, List<StoryModel>> sortedResult = {};
      for (var key in sortedKeys) {
        sortedResult[key] = result[key]!;
      }

      return sortedResult;
    });
  }

  /// Delete stories older than 24 hours
  Future<void> deleteExpiredStories() async {
    try {
      final now = DateTime.now();

      final QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection(FirebaseSettings.storiesCollection)
          .get();

      for (final doc in snapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;

        if (data.containsKey('createdAt')) {
          final Timestamp timestamp = data['createdAt'];
          final storyTime = timestamp.toDate();

          // check if 24h passed
          if (now.difference(storyTime).inHours >= 24) {
            await doc.reference.delete();
          }
        }
      }
      // ignore: empty_catches
    } catch (e) {}
  }

  Future<List<StoryModel>> getUserStories(String uid) async {
    try {
      final QuerySnapshot<Map<String, dynamic>> snapshot =
          await FirebaseFirestore.instance
              .collection(FirebaseSettings.storiesCollection)
              .where('userId', isEqualTo: uid)
              .orderBy('createdAt', descending: true)
              .get();

      List<StoryModel> stories = snapshot.docs
          .map((doc) => StoryModel.fromMap(doc.data()))
          .toList();

      return stories;
    } catch (e) {
      return [];
    }
  }
}
