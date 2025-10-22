import 'dart:io';

import 'package:image_picker/image_picker.dart';

class Util {

  static Future<File?> takeImage(ImageSource source) async {
    final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: source);
      if (image == null) return null;    
      return File(image.path);
  }
}
