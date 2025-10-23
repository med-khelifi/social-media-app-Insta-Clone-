import 'package:flutter/material.dart';
import 'package:insta/app/insta.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:insta/core/supabase/supabase_credential.dart';
import 'firebase_options.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await Supabase.initialize(
    url: SupabaseCredential.url,
    anonKey: SupabaseCredential.anonKey,
  );

  runApp(Insta());
}
