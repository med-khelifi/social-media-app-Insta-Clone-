import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:insta/controllers/signup_screen_controller.dart';
import 'package:insta/core/constants/colors.dart';
import 'package:insta/core/constants/constants_widgets.dart';
import 'package:insta/core/constants/strings.dart';
import 'package:insta/core/provider/auth_provider.dart';
import 'package:insta/screens/widgets/custom_button.dart';
import 'package:insta/screens/widgets/custom_text_field.dart';
import 'package:provider/provider.dart';

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
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Consumer<AuthProviderState>(
            builder: (context, auth, _) => Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                VerticalSpace(60.h),
                Text(
                  Strings.instaApp,
                  style: TextStyle(
                    fontSize: 32.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                VerticalSpace(30.h),
                Form(
                  key: _controller.formKey,
                  child: Column(
                    children: [
                      CustomTextField(
                        label: Strings.username,
                        controller: _controller.usernameController,
                        validator: _controller.validateUsername,
                      ),
                      VerticalSpace(10.h),
                      CustomTextField(
                        label: Strings.email,
                        controller: _controller.emailController,
                        validator: _controller.validateEmail,
                      ),
                      VerticalSpace(10.h),
                      CustomTextField(
                        showPassword: auth.isPasswordVisible,
                        label: Strings.password,
                        controller: _controller.passwordController,
                        validator: _controller.validatePassword,
                        isPassword: true,
                        onSuffixIconPressed: auth.togglePasswordVisibility,
                      ),
                    ],
                  ),
                ),
                VerticalSpace(20.h),
                CustomButton(
                  onPressed: auth.isLoading ? null : () => auth.signup(context),
                  child: auth.isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Text(
                          Strings.signup,
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                ),
                VerticalSpace(10.h),
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
