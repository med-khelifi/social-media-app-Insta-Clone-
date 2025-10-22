import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:insta/controllers/login_screen_controller.dart';
import 'package:insta/core/constants/colors.dart';
import 'package:insta/core/constants/constants_widgets.dart';
import 'package:insta/core/constants/strings.dart';
import 'package:insta/core/provider/auth_provider.dart';
import 'package:insta/screens/widgets/custom_button.dart';
import 'package:insta/screens/widgets/custom_text_field.dart';
import 'package:provider/provider.dart';

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
          padding: const EdgeInsets.all(16),
          child: Consumer(
            builder: (context, AuthProviderState auth, _) => Column(
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
                        controller: _controller.emailController,
                        label: Strings.email,
                        validator: _controller.validateEmail,
                      ),
                      VerticalSpace(10.h),
                      CustomTextField(
                        showPassword: auth.isPasswordVisible,
                        controller: _controller.passwordController,
                        label: Strings.password,
                        validator: _controller.validatePassword,
                        isPassword: true,
                        onSuffixIconPressed: auth.togglePasswordVisibility,
                      ),
                    ],
                  ),
                ),
                VerticalSpace(20.h),
                CustomButton(
                  onPressed: auth.isLoading ? null : () => auth.login(context),
                  child: auth.isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Text(
                          Strings.login,
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                ),
                VerticalSpace(10.h),
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
