class PostModel {
  final String id;
  final String userId;
  final String username;
  final String? userImage;
  final String imageUrl;
  final String caption;
  final List<String> likes; // list of userIds who liked the post
  final DateTime createdAt;

  PostModel({
    required this.id,
    required this.userId,
    required this.username,
    this.userImage,
    required this.imageUrl,
    required this.caption,
    required this.likes,
    required this.createdAt,
  });

  // 🔄 fromJson: Convert JSON -> PostModel
  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      username: json['username'] ?? '',
      userImage: json['userImage'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      caption: json['caption'] ?? '',
      likes: List<String>.from(json['likes'] ?? []),
      createdAt: (json['createdAt'] is String)
          ? DateTime.parse(json['createdAt'])
          : (json['createdAt']?.toDate() ??
                DateTime.now()), // Firebase friendly
    );
  }

  // 🔁 toJson: Convert PostModel -> JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'username': username,
      'userImage': userImage,
      'imageUrl': imageUrl,
      'caption': caption,
      'likes': likes,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
