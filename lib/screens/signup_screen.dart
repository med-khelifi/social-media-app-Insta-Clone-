import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:insta/controllers/signup_screen.dart';
import 'package:insta/core/constants/colors.dart';
import 'package:insta/core/constants/constants_widgets.dart';
import 'package:insta/core/constants/images_paths.dart';
import 'package:insta/core/constants/strings.dart';
import 'package:insta/screens/widgets/custom_button.dart';
import 'package:insta/screens/widgets/custom_text_field.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  late SignupScreenController _controller;
  @override
  void initState() {
    super.initState();
    _controller = SignupScreenController();
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
                CircleAvatar(
                  radius: 60.r,
                  backgroundColor: Colors.grey,
                  backgroundImage: AssetImage(ImagesPaths.placeholder),
                ),
                VerticalSpace(10.h),
                Form(
                  key: _controller.formKey,
                  child: Column(
                    children: [
                      CustomTextField(label: Strings.username),
                      VerticalSpace(10.h),
                      CustomTextField(label: Strings.email),
                      VerticalSpace(10.h),
                      CustomTextField(
                        label: Strings.password,
                        isPassword: true,
                      ),
                    ],
                  ),
                ),
                VerticalSpace(10.h),
                CustomButton(
                  text: Strings.signup,
                  onPressed: () => _controller.signup(context),
                ),
                TextButton(
                  onPressed: () => _controller.goToLoginScreen(context),
                  child: Text(
                    Strings.alreadyHaveAcc,
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
