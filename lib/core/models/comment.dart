import 'package:cloud_firestore/cloud_firestore.dart';

class CommentModel {
  final String id;        
  final String postId;    
  final String userId;    
  final String username;  
  final String userImage; 
  final String text;      
  final DateTime createdAt;
  final List<String> likes;

  CommentModel({
    required this.id,
    required this.postId,
    required this.userId,
    required this.username,
    required this.userImage,
    required this.text,
    required this.createdAt,
    this.likes = const [],
  });

  // Convert Firestore document to Comment object
  factory CommentModel.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return CommentModel(
      id: doc.id,
      postId: data['postId'] ?? '',
      userId: data['userId'] ?? '',
      username: data['username'] ?? '',
      userImage: data['userImage'] ?? '',
      text: data['text'] ?? '',
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      likes: List<String>.from(data['likes'] ?? []),
    );
  }

  // Convert Comment object to map to save in Firestore
  Map<String, dynamic> toMap() {
    return {
      'postId': postId,
      'userId': userId,
      'username': username,
      'userImage': userImage,
      'text': text,
      'createdAt': Timestamp.fromDate(createdAt),
      'likes': likes,
    };
  }
}
