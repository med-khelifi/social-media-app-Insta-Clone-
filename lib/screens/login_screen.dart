import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:insta/controllers/login_screen_controller.dart';
import 'package:insta/core/constants/colors.dart';
import 'package:insta/core/constants/constants_widgets.dart';
import 'package:insta/screens/widgets/custom_text_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late LoginScreenController controller;
  @override
  void initState() {
    super.initState();
    controller = LoginScreenController();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Insta App',
                  style: TextStyle(
                    fontSize: 32.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                VerticalSpace(10.h),
                Form(
                  child: Column(
                    children: [
                      CustomTextField(label: "Username"),
                      VerticalSpace(10.h),
                      CustomTextField(label: "Email"),
                    ],
                  ),
                ),
                VerticalSpace(10.h),
                MaterialButton(
                  minWidth: double.infinity,
                  color: ColorsManager.blue,
                  onPressed: () {},
                  child: Text('login'),
                ),
                TextButton(
                  onPressed: () => controller.goToSignupScreen(context),
                  child: Text(
                    "create a new account",
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.bold,
                      color: ColorsManager.blue,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
