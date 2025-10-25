import 'dart:async';
import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:insta/core/constants/strings.dart';
import 'package:insta/core/firebase/firebase_store_methods.dart';
import 'package:insta/core/models/post.dart';
import 'package:insta/core/models/user.dart';
import 'package:insta/core/provider/user_provider.dart';
import 'package:insta/core/supabase/supabase_storage_service.dart';
import 'package:insta/core/util/util.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class AddNewPostScreenController {
  late final SupabaseStorageService _storageService;
  late final TextEditingController captionTextController;
  late FirebaseStoreMethods _firebaseStoreMethods;
  late UserModel currentUser;
  File? file;
  final StreamController<File?> imageStreamController =
      StreamController.broadcast();
  Stream<File?> get imageStream => imageStreamController.stream;
  void addImageToStream(File? image) => imageStreamController.add(image);
  void dispose() {
    captionTextController.dispose();
    imageStreamController.close();
  }

  AddNewPostScreenController() {
    captionTextController = TextEditingController();
    _storageService = SupabaseStorageService();
    _firebaseStoreMethods = FirebaseStoreMethods();
  }
  void takePhoto() async {
    file = await Util.takeImage(ImageSource.gallery);
    if (file != null) {
      addImageToStream(file!);
    }
  }

  Future<void> handlePostUpload(BuildContext context) async {
    final userProvider = context.read<UserProvider>();
    userProvider.getUserData();
    final user = userProvider.getUser;
    if (user == null) return;
    if (file == null) return;
    final imageUrl = await _storageService.uploadUserImage(
      context,
      file!,
      user.uid,
      ImageSource.gallery,
    );

    if (imageUrl == null) return;
    final postId = const Uuid().v4();

    final post = PostModel(
      id: postId,
      userId: user.uid,
      username: user.username,
      userImage: user.profileImageUrl,
      imageUrl: imageUrl,
      caption: captionTextController.text.trim(),
      likes: [],
      createdAt: DateTime.now(),
    );

    _firebaseStoreMethods.addPost(post);

    if (context.mounted) {
      Util.showSnackBar(Strings.postUploadedSuccessfully, context: context);
      captionTextController.clear();
      addImageToStream(null);
    }
  }
}
