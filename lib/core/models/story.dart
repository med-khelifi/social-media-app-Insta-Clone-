class StoryModel {
  final String id;
  final String userId;
  final String imageUrl;
  final String contentUrl;
  final DateTime createdAt;
  final List<String> viewers;
  final bool isVideo;

  StoryModel({
    required this.id,
    required this.userId,
    required this.imageUrl,
    required this.contentUrl,
    required this.createdAt,
    this.viewers = const [],
    this.isVideo = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'imageUrl': imageUrl,
      'contentUrl': contentUrl,
      'createdAt': createdAt.toIso8601String(),
      'viewers': viewers,
      'isVideo': isVideo,
    };
  }

  factory StoryModel.fromMap(Map<String, dynamic> map) {
    return StoryModel(
      id: map['id'] ?? '',
      userId: map['userId'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      contentUrl: map['contentUrl'] ?? '',
      createdAt: DateTime.tryParse(map['createdAt'] ?? '') ?? DateTime.now(),
      viewers: List<String>.from(map['viewers'] ?? []),
      isVideo: map['isVideo'] ?? false,
    );
  }
}
