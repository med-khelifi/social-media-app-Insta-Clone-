import 'dart:io';
import 'package:flutter/material.dart';
import 'package:insta/core/supabase/supabase_settings.dart';
import 'package:insta/core/util/util.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';
import 'package:image_picker/image_picker.dart';

class SupabaseStorageService {
  final SupabaseClient _client = Supabase.instance.client;
  final Uuid _uuid = Uuid();

  Future<String?> uploadUserImage(
    BuildContext context,
    File file,
    String userId,
    ImageSource source,
  ) async {
    final ext = file.path.split('.').last;
    final fileName = '${_uuid.v4()}.$ext';

    final path = '$userId/$fileName';

    try {
      await _client.storage
          .from(SupabaseSettings.postsImagesBucketName)
          .upload(path, file);

      final publicUrl = _client.storage
          .from(SupabaseSettings.postsImagesBucketName)
          .getPublicUrl(path);

      return publicUrl;
    } catch (e) {
      if (context.mounted) {
        Util.showSnackBar('Upload failed: $e', context: context);
      }
      return null;
    }
  }

  Future<(bool deleted, String? error)> deleteImage(
    BuildContext context,
    String path,
  ) async {
    try {
      await _client.storage.from(SupabaseSettings.postsImagesBucketName).remove(
        [path],
      );
      return (true, null);
    } catch (e) {
      return (true, e.toString());
    }
  }
}
