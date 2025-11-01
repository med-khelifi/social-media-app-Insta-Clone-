class MessageModel {
  final String id;
  final String senderId;
  final String receiverId;
  final String text;
  final String? imageUrl;
  final DateTime sentAt;
  final bool isSeen;

  MessageModel({
    required this.id,
    required this.senderId,
    required this.receiverId,
    required this.text,
    this.imageUrl,
    required this.sentAt,
    required this.isSeen,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'senderId': senderId,
      'receiverId': receiverId,
      'text': text,
      'imageUrl': imageUrl,
      'sentAt': sentAt.millisecondsSinceEpoch,
      'isSeen': isSeen,
    };
  }

  factory MessageModel.fromMap(Map<String, dynamic> map) {
    return MessageModel(
      id: map['id'],
      senderId: map['senderId'],
      receiverId: map['receiverId'],
      text: map['text'],
      imageUrl: map['imageUrl'],
      sentAt: DateTime.fromMillisecondsSinceEpoch(map['sentAt']),
      isSeen: map['isSeen'],
    );
  }
}
