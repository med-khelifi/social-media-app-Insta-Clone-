import 'package:flutter/material.dart';
import 'package:insta/app/insta.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await Supabase.initialize(
    url: "https://otdgzwccdfguwtygpuet.supabase.co",
    anonKey:
        "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im90ZGd6d2NjZGZndXd0eWdwdWV0Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjEwNzIyOTQsImV4cCI6MjA3NjY0ODI5NH0.YGBBVYrgljjX0FA5iSZwLcYKxl12QiFyqp46WQnLUwo",
  );
  
  runApp(Insta());
}
