import 'package:insta/core/firebase/firebase_store_methods.dart';

class ChatsController {
  late FirebaseStoreMethods _firebaseStoreMethods;
  ChatsController(){
    _firebaseStoreMethods = FirebaseStoreMethods();
  }
   Stream<List<Map<String, dynamic>>> getCurrentUserChats() =>
      _firebaseStoreMethods.getCurrentUserChats();

}