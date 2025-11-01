class ChatModel {
  final String chatId;
  final List<String> participants; // [senderId, receiverId]
  final String lastMessage;
  final DateTime updatedAt;

  ChatModel({
    required this.chatId,
    required this.participants,
    required this.lastMessage,
    required this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'chatId': chatId,
      'participants': participants,
      'lastMessage': lastMessage,
      'updatedAt': updatedAt.millisecondsSinceEpoch,
    };
  }

  factory ChatModel.fromMap(Map<String, dynamic> map) {
    return ChatModel(
      chatId: map['chatId'],
      participants: List<String>.from(map['participants']),
      lastMessage: map['lastMessage'],
      updatedAt: DateTime.fromMillisecondsSinceEpoch(map['updatedAt']),
    );
  }
}
