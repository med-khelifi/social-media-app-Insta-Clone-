import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String username;
  final String name;
  final String email;
  final String bio;
  final String? profileImageUrl;
  final List<String> followers;
  final List<String> following;

  // جديد: للـ Profile
  final bool isFollowing;
  final int postsCount;

  UserModel({
    required this.uid,
    required this.username,
    required this.email,
    this.bio = '',
    this.name = '',
    this.profileImageUrl = '',
    this.followers = const [],
    this.following = const [],
    this.isFollowing = false,
    this.postsCount = 0,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'username': username,
      'name': name,
      'email': email,
      'bio': bio,
      'profileImageUrl': profileImageUrl,
      'followers': followers,
      'following': following,
      'postsCount': postsCount, // يُحفظ في Firestore
    };
  }

  factory UserModel.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UserModel(
      uid: doc.id,
      username: data['username'] ?? '',
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      bio: data['bio'] ?? '',
      profileImageUrl: data['profileImageUrl'],
      followers: List<String>.from(data['followers'] ?? []),
      following: List<String>.from(data['following'] ?? []),
      postsCount: data['postsCount'] ?? 0,
      // isFollowing يُحسب لاحقًا
    );
  }

  UserModel copyWith({
    String? uid,
    String? username,
    String? name,
    String? email,
    String? bio,
    String? profileImageUrl,
    List<String>? followers,
    List<String>? following,
    bool? isFollowing,
    int? postsCount,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      username: username ?? this.username,
      name: name ?? this.name,
      email: email ?? this.email,
      bio: bio ?? this.bio,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      followers: followers ?? this.followers,
      following: following ?? this.following,
      isFollowing: isFollowing ?? this.isFollowing,
      postsCount: postsCount ?? this.postsCount,
    );
  }
}