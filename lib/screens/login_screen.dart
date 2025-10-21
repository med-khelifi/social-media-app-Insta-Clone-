import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:insta/controllers/login_screen_controller.dart';
import 'package:insta/core/constants/colors.dart';
import 'package:insta/core/constants/constants_widgets.dart';
import 'package:insta/core/constants/strings.dart';
import 'package:insta/screens/widgets/custom_button.dart';
import 'package:insta/screens/widgets/custom_text_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late LoginScreenController _controller;
  @override
  void initState() {
    super.initState();
    _controller = LoginScreenController();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  Strings.instaApp,
                  style: TextStyle(
                    fontSize: 32.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                VerticalSpace(10.h),
                Form(
                  key: _controller.formKey,
                  child: Column(
                    children: [
                      CustomTextField(
                        controller: _controller.usernameController,
                        label: Strings.username,
                        validator: _controller.validateUsername,
                      ),
                      VerticalSpace(10.h),
                      CustomTextField(
                        controller: _controller.passwordController,
                        label: Strings.password,
                        validator: _controller.validatePassword,
                        isPassword: true,
                      ),
                    ],
                  ),
                ),
                VerticalSpace(10.h),
                CustomButton(
                  text: Strings.login,
                  onPressed: () => _controller.login(context),
                ),
                TextButton(
                  onPressed: () => _controller.goToSignupScreen(context),
                  child: Text(
                    Strings.dontHaveAcc,
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
