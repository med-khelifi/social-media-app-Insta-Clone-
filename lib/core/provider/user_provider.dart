import 'package:flutter/material.dart';
import 'package:insta/core/firebase/firebase_store_methods.dart';
import 'package:insta/core/models/user.dart';

class UserProvider with ChangeNotifier {
  UserModel? _user;
  UserModel? get getUser => _user;
  FirebaseStoreMethods firebaseStoreMethods = FirebaseStoreMethods();
  Future<void> getUserData({String? uid}) async {
    _user = await firebaseStoreMethods.getCurrentUserData(uid: uid);
    notifyListeners();
  }
}