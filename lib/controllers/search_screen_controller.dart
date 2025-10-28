import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:insta/core/firebase/firebase_store_methods.dart';
import 'package:insta/core/models/user.dart';
import 'package:insta/screens/home/tabs/profile_tab.dart';

class SearchScreenController {
  SearchScreenController() {
    _firebaseStoreMethods = FirebaseStoreMethods();
    searchBoxEditingController = TextEditingController();
    searchBoxEditingController.clear();
  }
  late FirebaseStoreMethods _firebaseStoreMethods;
  late TextEditingController searchBoxEditingController;

  Stream<List<UserModel>> getSearchedUsers() {
    if (searchBoxEditingController.text.isEmpty) return Stream.value(List.empty());
    return _firebaseStoreMethods.getSearchedUserData(
      searchBoxEditingController.text.trim(),
    );
  }

  void onUserListTileItemPressed(BuildContext context, String uid) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => Scaffold(
          body: SafeArea(child: ProfileTab(userId: uid)),
        ),
      ),
    );
  }
}
