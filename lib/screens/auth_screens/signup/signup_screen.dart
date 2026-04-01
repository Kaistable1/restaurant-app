import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kaistable_website/constants/app_colors.dart';
import 'package:kaistable_website/screens/app_info/terms_and_condition/terms_and_condition.dart';
import 'package:kaistable_website/screens/auth_screens/signup/controller/signup_controller.dart';

import '../../../custom_widget/TextAndWidget.dart';
import '../../../utils/validations.dart';
import '../../../widgets/custom_button.dart';
import '../login/login_screen.dart';

class SignupScreen extends StatelessWidget {
  final String? fromScreen; // 'highlights' or 'login'
  
  SignupScreen({super.key, this.fromScreen});

  final controller = Get.put(SignupController());

  @override
  Widget build(BuildContext context) {
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
                  SizedBox(height: 14),
                  Text(
                    'Signing up for Savrli is fast and free',
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
                    labelText: 'User Name',
                    hintText: 'Harold Richards',
                    controller: controller.userModel.username,
                    isSuffixIcon: true,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter user name.';
                      }
                      return null;
                    },
                    suffixIcon: Padding(
                      padding: const EdgeInsets.only(
                          left: 12, bottom: 12, top: 12, right: 8),
                      child: Image.asset(
                        'assets/images/user_icon.png',
                        height: 20,
                        width: 20,
                      ),
                    ),
                  ),
                  TextAndFieldWidget(
                    labelText: 'Email',
                    hintText: 'deanna.curtis@example.com',
                    controller: controller.userModel.userEmail,
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
                      controller: controller.userModel.password,
                      obscureText: controller.isPasswordHidden.value,
                      validator: (value) {
                        return isPasswordValid(value!);
                      },
                      isSuffixIcon: true,
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
                  Obx(
                    () => TextAndFieldWidget(
                      labelText: 'Confirm Password',
                      hintText: 'Password ',
                      controller: controller.userModel.confirmpass,
                      obscureText: controller.isConfirmPasswordHidden.value,
                      isSuffixIcon: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a confirm password';
                        }
                        if (value != controller.userModel.password.text) {
                          return 'Passwords do not match';
                        }
                        return null;
                      },
                      suffixIcon: GestureDetector(
                        onTap: () {
                          controller.isConfirmPasswordHidden.value =
                              !controller.isConfirmPasswordHidden.value;
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 13.0, bottom: 13, top: 13, right: 13),
                          child:
                              controller.isConfirmPasswordHidden.value == true
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
                  SizedBox(
                    height: 8,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () {
                          controller.termsAndConditions.value =
                              !controller.termsAndConditions.value;
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
                            child: controller.termsAndConditions.value == true
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
                        'I agree with ',
                        style: TextStyle(
                          color: AppColors.headingTextColor,
                          fontWeight: FontWeight.w600,
                          fontFamily: GoogleFonts.plusJakartaSans().fontFamily,
                          fontSize: 16 * (5/4),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Get.to(() => TermsAndCondition());
                        },
                        child: Text(
                          'Terms & Conditions',
                          style: TextStyle(
                            color: AppColors.primaryColor,
                            fontWeight: FontWeight.w600,
                            fontFamily: GoogleFonts.plusJakartaSans().fontFamily,
                            decoration: TextDecoration.underline,
                            decorationColor: AppColors.primaryColor,
                            fontSize: 16 * (5/4),
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  Center(
                    child: CustomButton(
                      laBelText: 'Sign-up',
                      fontSize: 16 * (5/4),
                      fontWeight: FontWeight.w600,
                      fontFamily: GoogleFonts.plusJakartaSans().fontFamily,
                      textColor: Colors.white,
                      width: 200,
                      height: 48,
                      ontapp: () async {
                        if (_formKey.currentState!.validate()) {
                          if (!controller.termsAndConditions.value) {
                            Get.snackbar(
                              "Terms and Conditions",
                              "You must agree to the Terms and Conditions to continue.",
                              snackPosition: SnackPosition.TOP,
                              backgroundColor: AppColors.primaryColor,
                              colorText: Colors.white,
                            );
                            return;
                          }
                          await controller.sendEmail();
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
                            text: 'Already  have an account?',
                            style: TextStyle(
                                fontSize: 14 * (5/4),
                                fontWeight: FontWeight.w600,
                                fontFamily: GoogleFonts.plusJakartaSans().fontFamily,
                                color: AppColors.headingTextColor),
                          ),
                          TextSpan(
                            text: ' Login',
                            style: TextStyle(
                              color: AppColors.primaryColor,
                              fontSize: 16 * (5/4),
                              fontFamily: GoogleFonts.plusJakartaSans().fontFamily,
                              fontWeight: FontWeight.w600,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                if (fromScreen == 'highlights') {
                                  Get.offAll(() => LoginScreen(fromScreen: 'highlights'));
                                } else {
                                  Get.back();
                                }
                              },
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 16,
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
