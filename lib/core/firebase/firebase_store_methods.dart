import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:insta/core/firebase/firebase_settings.dart';
import 'package:insta/core/models/user.dart';

class FirebaseStoreMethods {
  Future<UserModel> getCurrentUserData() async {
    DocumentSnapshot<Map<String, dynamic>> user = await FirebaseFirestore
        .instance
        .collection(FirebaseSettings.usersCollection)
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .get();

    UserModel? userModel = UserModel.fromDocument(user);
    return userModel;
  }
}
