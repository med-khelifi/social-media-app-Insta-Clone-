import 'package:firebase_auth/firebase_auth.dart';

class FirebaseSettings {
  static const String usersCollection = 'users';
  static const String postsCollection = 'posts';
}

class FirebaseAuthSettings {
  
  static String currentUserId = FirebaseAuth.instance.currentUser!.uid;
}