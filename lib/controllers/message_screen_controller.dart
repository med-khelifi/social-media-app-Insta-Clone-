import 'package:insta/core/firebase/firebase_store_methods.dart';
import 'package:insta/core/models/Message.dart';

class MessageScreenController {
  late FirebaseStoreMethods _firebaseStoreMethods;
  MessageScreenController() {
    _firebaseStoreMethods = FirebaseStoreMethods();
  }
  Future<String> checkOrCreateChat(String receiverId) async =>
      _firebaseStoreMethods.checkOrCreateChat(receiverId);
  Future<void> sendMessage({
    required String chatId,
    required String receiverId,
    required String text,
    String? imageUrl,
  }) async => _firebaseStoreMethods.sendMessage(
    chatId: chatId,
    receiverId: receiverId,
    text: text,
    imageUrl: imageUrl,
  );

  Stream<List<MessageModel>> getChatMessages(String chatId) =>
      _firebaseStoreMethods.getChatMessages(chatId);
}
