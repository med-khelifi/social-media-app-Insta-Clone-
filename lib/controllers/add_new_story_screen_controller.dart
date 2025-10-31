import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:insta/core/constants/strings.dart';
import 'package:insta/core/firebase/firebase_auth_settings.dart';
import 'package:insta/core/firebase/firebase_store_methods.dart';
import 'package:insta/core/provider/user_provider.dart';
import 'package:insta/core/supabase/supabase_storage_service.dart';
import 'package:insta/core/util/util.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

class AddNewStoryScreenController {
  late File? file;
  late bool? isImage;

  late StreamController<(bool, dynamic)?> _fileStreamController;
  late Stream<(bool, dynamic)?> _fileStream;
  get fileStream => _fileStream;
  late Sink<(bool, dynamic)?> _fileSink;

  late FirebaseStoreMethods _firebaseStoreMethods;
  late SupabaseStorageService _storageService;

  AddNewStoryScreenController() {
    isImage = null;
    _fileStreamController = StreamController();
    _fileSink = _fileStreamController.sink;
    _fileStream = _fileStreamController.stream.asBroadcastStream();
    _firebaseStoreMethods = FirebaseStoreMethods();
    _storageService = SupabaseStorageService();
  }

  Future<bool?> _showSelectMediaDialog(BuildContext context) async {
    return showModalBottomSheet<bool>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Wrap(
              children: [
                ListTile(
                  leading: const Icon(Icons.image),
                  title: const Text("Select Image"),
                  onTap: () => Navigator.pop(context, true),
                ),
                ListTile(
                  leading: const Icon(Icons.videocam),
                  title: const Text("Select Video"),
                  onTap: () => Navigator.pop(context, false),
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.close),
                  title: const Text(Strings.cancel),
                  onTap: () => Navigator.pop(context, null),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void onImagePressed(BuildContext context) async {
    bool? res = await _showSelectMediaDialog(context);
    if (res == null) return;

    if (res) {
      isImage = true;
      file = await Util.takeImage(ImageSource.gallery);
    } else {
      isImage = false;
      file = await Util.takeVideo(ImageSource.gallery);
    }

    if (file == null) {
      _fileSink.add(null);
      return;
    }

    if (isImage!) {
      _fileSink.add((true, file!.path));
    } else {
      final videoController = VideoPlayerController.file(file!);
      await videoController.initialize();
      videoController.setLooping(true);
      videoController.play();
      _fileSink.add((false, videoController));
    }
  }

  Future<void> uploadStory(BuildContext context, {String? caption}) async {
    if (file == null) return;
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final user = userProvider.getUser;
    if (user == null) return;
    String? fileUrl = await _storageService.uploadStoryFile(
      file: file!,
      isImage: isImage!,
      userId: FirebaseAuthSettings.currentUserId,
    );
    if (fileUrl == null) {
      // ignore: use_build_context_synchronously
      Util.showSnackBar("Error uploading file", context: context);
      return;
    }

    await _firebaseStoreMethods.uploadStory(
      isImage: isImage ?? true,
      fileUrl: fileUrl,
      imageUrl: user.profileImageUrl ?? '',
    );
    // ignore: use_build_context_synchronously
    Util.showSnackBar("Uploaded", context: context);
    _fileSink.add(null);
  }

  void dispose() {
    _fileStreamController.close();
    _fileSink.close();
  }
}
