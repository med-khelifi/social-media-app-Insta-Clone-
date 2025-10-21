import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:insta/core/constants/routes.dart';

class Insta extends StatelessWidget {
  const Insta({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(392.72, 807.27),
      child: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, asyncSnapshot) {
          if (asyncSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (asyncSnapshot.hasData) {
            return MaterialApp(
              routes: Routes.routes,
              initialRoute: RoutesNames.home,
              theme: ThemeData.dark(),
            );
          }
          return MaterialApp(
            routes: Routes.routes,
            initialRoute: RoutesNames.login,
            theme: ThemeData.dark(),
          );
        },
      ),
    );
  }
}
