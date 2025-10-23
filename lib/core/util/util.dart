import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Util {

  static Future<File?> takeImage(ImageSource source) async {
    final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: source);
      if (image == null) return null;    
      return File(image.path);
  }

  static void showSnackBar(String message, {required BuildContext context}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}
