import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:insta/core/constants/routes.dart';
import 'package:insta/core/constants/strings.dart';

class ProfileTabController {
  ProfileTabController();
  void init() {}
  void dispose() {}

  void onSignOutPressed(BuildContext context) async {
    final bool? res = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(Strings.signout),
          content: const Text(Strings.areUSureToSignout),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text(Strings.cancel),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text(Strings.signout),
            ),
          ],
        );
      },
    );

    if (res == true) {
      try {
        await FirebaseAuth.instance.signOut();
        // ignore: use_build_context_synchronously
        Navigator.pushReplacementNamed(context, RoutesNames.login);
      } catch (error) {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(
          // ignore: use_build_context_synchronously
          context,
        ).showSnackBar(SnackBar(content: Text('Error signing out: $error')));
      }
    }
  }
}
