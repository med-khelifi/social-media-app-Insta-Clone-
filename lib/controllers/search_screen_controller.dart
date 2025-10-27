import 'package:flutter/widgets.dart';
import 'package:insta/core/firebase/firebase_store_methods.dart';
import 'package:insta/core/models/user.dart';

class SearchScreenController {
  SearchScreenController() {
    _firebaseStoreMethods = FirebaseStoreMethods();
    searchBoxEditingController = TextEditingController();
  }
  late FirebaseStoreMethods _firebaseStoreMethods;
  late TextEditingController searchBoxEditingController;

  Stream<List<UserModel>> getSearchedUsers() {
    return _firebaseStoreMethods.getSearchedUserData(
      searchBoxEditingController.text.trim(),
    );
  }

  void onUserListTileItemPressed(String uid) {}
}
