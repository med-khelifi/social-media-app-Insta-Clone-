import 'package:flutter/material.dart';
import 'package:insta/core/firebase/firebase_store_methods.dart';
import 'package:insta/core/models/user.dart';

class UserProvider with ChangeNotifier {
  UserModel? _user;
  UserModel? get getUser => _user;

  final FirebaseStoreMethods _methods = FirebaseStoreMethods();

  Future<void> getUserData({String? uid}) async {
    _user = await _methods.getCurrentUserData(uid: uid);
    notifyListeners();
  }

  // تحديث محلي بعد Follow/Unfollow
  void updateFollowingState(String targetUserId, bool isFollowingNow) {
    if (_user != null && _user!.uid == targetUserId) {
      _user = _user!.copyWith(isFollowing: isFollowingNow);
      notifyListeners();
    }
  }

  // اختياري: تحديث عدد المنشورات
  void updatePostsCount(int count) {
    if (_user != null) {
      _user = _user!.copyWith(postsCount: count);
      notifyListeners();
    }
  }
}