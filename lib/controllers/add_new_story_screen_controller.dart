import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:insta/core/constants/strings.dart';
import 'package:insta/core/util/util.dart';
import 'package:video_player/video_player.dart';

class AddNewStoryScreenController {
  late File? file;
  late bool? isImage;

  late StreamController<(bool, dynamic)?> _fileStreamController;
  late Stream<(bool, dynamic)?> _fileStream;
  get fileStream => _fileStream;

  late Sink<(bool, dynamic)?> _fileSink;

  AddNewStoryScreenController() {
    isImage = null;
    _fileStreamController = StreamController();
    _fileSink = _fileStreamController.sink;
    _fileStream = _fileStreamController.stream.asBroadcastStream();
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

  void dispose() {
    _fileStreamController.close();
    _fileSink.close();
  }
}
