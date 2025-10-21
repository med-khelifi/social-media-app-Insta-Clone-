import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String username;
  final String email;
  final String bio;
  final String? profileImageUrl;
  final List<String> followers;
  final List<String> following;

  UserModel({
    required this.uid,
    required this.username,
    required this.email,
    this.bio = '',
    this.profileImageUrl = '',
    this.followers = const [],
    this.following = const [],
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'username': username,
      'email': email,
      'bio': bio,
      'profileImageUrl': profileImageUrl,
      'followers': followers,
      'following': following,
    };
  }

  factory UserModel.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UserModel(
      uid: data['uid'],
      username: data['username'] ?? '',
      email: data['email'] ?? '',
      bio: data['bio'] ?? '',
      profileImageUrl: data['profileImageUrl'] ?? '',
      followers: List<String>.from(data['followers'] ?? []),
      following: List<String>.from(data['following'] ?? []),
    );
  }
}
