import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:insta/core/constants/colors.dart';
import 'package:insta/core/constants/constants_widgets.dart';
import 'package:insta/core/constants/strings.dart';
import 'package:insta/core/provider/auth_provider.dart';
import 'package:insta/screens/widgets/custom_button.dart';
import 'package:insta/screens/widgets/custom_text_field.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

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
                  key: auth.loginController.formKey,
                  child: Column(
                    children: [
                      CustomTextField(
                        controller: auth.loginController.emailController,
                        label: Strings.email,
                        validator: auth.loginController.validateEmail,
                      ),
                      VerticalSpace(10.h),
                      CustomTextField(
                        showPassword: auth.isPasswordVisible,
                        controller: auth.loginController.passwordController,
                        label: Strings.password,
                        validator: auth.loginController.validatePassword,
                        isPassword: true,
                        onSuffixIconPressed: auth.togglePasswordVisibility,
                      ),
                    ],
                  ),
                ),
                VerticalSpace(20.h),
                CustomButton(
                  onPressed: auth.isLoading
                      ? null
                      : () async {
                          if (auth.isLoading) return;
                          await auth.login(context);
                        },
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
                  onPressed: () =>
                      auth.loginController.goToSignupScreen(context),
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
