import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kaistable_website/constants/app_colors.dart';
import 'package:kaistable_website/main.dart';
import 'package:kaistable_website/screens/auth_screens/login/controller/login_controller.dart';

import '../../../custom_widget/TextAndWidget.dart';
import '../../../utils/validations.dart';
import '../../../widgets/custom_button.dart';
import '../forgot_pass/forgot_pass_screen.dart';
import '../signup/signup_screen.dart';

class LoginScreen extends StatelessWidget {
  final String? fromScreen; // 'highlights' or 'signup'
  
  LoginScreen({super.key, this.fromScreen});

  final controller = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    controller.checkRememberMe();
    final _formKey = GlobalKey<FormState>();
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        backgroundColor: AppColors.bgColor,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 50,
                  ),
                  Center(
                    child: Image.asset(
                      'assets/images/botomsheet_logo.png',
                      height: 74,
                      width: 196,
                      color: AppColors.primaryColor,
                    ),
                  ),
                  SizedBox(
                    height: 73,
                  ),
                  Text(
                    'Welcome',
                    style: TextStyle(
                      color: AppColors.blackColor,
                      fontWeight: FontWeight.w700,
                      fontFamily: GoogleFonts.plusJakartaSans().fontFamily,
                      fontSize: 28 * (5/4),
                    ),
                  ),
                  SizedBox(
                    height: 14,
                  ),
                  Text(
                    'Login to Continue!',
                    style: TextStyle(
                      color: AppColors.blackColor,
                      fontWeight: FontWeight.w600,
                      fontFamily: GoogleFonts.plusJakartaSans().fontFamily,
                      fontSize: 16 * (5/4),
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  TextAndFieldWidget(
                    labelText: 'Email',
                    hintText: 'deanna.curtis@example.com',
                    controller: controller.emailController,
                    isSuffixIcon: true,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter email.';
                      }
                      String pattern =
                          r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
                      RegExp regex = RegExp(pattern);

                      if (!regex.hasMatch(value)) {
                        return 'Please enter a valid email.';
                      }
                      return null;
                    },
                    suffixIcon: Padding(
                      padding: const EdgeInsets.only(
                          left: 13.0, bottom: 8, top: 8, right: 13),
                      child: Image.asset(
                        'assets/images/email.icon.png',
                        height: 20,
                        width: 20,
                      ),
                    ),
                  ),
                  Obx(
                    () => TextAndFieldWidget(
                      labelText: 'Password',
                      hintText: 'Password ',
                      controller: controller.passwordController,
                      obscureText: controller.isPasswordHidden.value,
                      isSuffixIcon: true,
                      validator: (value) {
                        return isPasswordValid(value!);
                      },
                      suffixIcon: GestureDetector(
                        onTap: () {
                          controller.isPasswordHidden.value =
                              !controller.isPasswordHidden.value;
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 13.0, bottom: 13, top: 13, right: 13),
                          child: controller.isPasswordHidden.value == true
                              ? Image.asset(
                                  'assets/images/open_eye.png',
                                  height: 16,
                                  width: 22,
                                )
                              : Image.asset(
                                  'assets/images/closed_eye.png',
                                  height: 16,
                                  width: 22,
                                ),
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Get.to(() => ForgotPassScreen());
                    },
                    child: Align(
                      alignment: Alignment.topRight,
                      child: Text(
                        'Forgot Password?',
                        style: TextStyle(
                          color: AppColors.primaryColor,
                          fontWeight: FontWeight.w600,
                          fontFamily: GoogleFonts.plusJakartaSans().fontFamily,
                          fontSize: 14 * (5/4),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () {
                          controller.rememberMe.value =
                              !controller.rememberMe.value;
                          if (controller.rememberMe.value) {
                            remember_me_pref!.setString('remember_me',
                                controller.passwordController.text);
                            remember_me_pref!.setString('remember_me_email',
                                controller.emailController.text);
                            remember_me_pref!.setBool('is_remember_me', true);
                          } else {
                            remember_me_pref!.clear();
                            controller.update();
                          }
                        },
                        child: Obx(
                          () => Container(
                            height: 24,
                            width: 24,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(
                                  color: AppColors.primaryColor, width: 2),
                              shape: BoxShape.rectangle,
                            ),
                            child: controller.rememberMe.value == true
                                ? const Center(
                                    child: Icon(
                                      Icons.done,
                                      color: AppColors.primaryColor,
                                      size: 16,
                                    ),
                                  )
                                : null,
                          ),
                        ),
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Remember me',
                        style: TextStyle(
                          color: AppColors.primaryColor,
                          fontWeight: FontWeight.w600,
                          fontFamily: GoogleFonts.plusJakartaSans().fontFamily,
                          fontSize: 14 * (5/4),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  Center(
                    child: CustomButton(
                      laBelText: 'Login',
                      fontSize: 16 * (5/4),
                      fontWeight: FontWeight.w600,
                      fontFamily: GoogleFonts.plusJakartaSans().fontFamily,
                      textColor: Colors.white,
                      width: 150,
                      height: 44,
                      ontapp: () async {
                        if (_formKey.currentState!.validate()) {
                          await controller.login();
                        }
                      },
                    ),
                  ),
                  SizedBox(
                    height: 24,
                  ),
                  Center(
                    child: RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: 'Don\'t have an account?',
                            style: TextStyle(
                                fontSize: 16 * (5/4),
                                fontWeight: FontWeight.w600,
                                fontFamily: GoogleFonts.plusJakartaSans().fontFamily,
                                color: AppColors.headingTextColor),
                          ),
                          TextSpan(
                            text: ' Signup',
                            style: TextStyle(
                              color: AppColors.primaryColor,
                              fontSize: 16 * (5/4),
                              fontFamily: GoogleFonts.plusJakartaSans().fontFamily,
                              fontWeight: FontWeight.w600,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                              Get.to(()=>SignupScreen(fromScreen: 'login',));
                              },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
