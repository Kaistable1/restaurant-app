import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kaistable_website/constants/app_colors.dart';
import 'package:kaistable_website/screens/auth_screens/login/controller/login_controller.dart';
import 'package:kaistable_website/screens/auth_screens/signup/controller/signup_controller.dart';

import '../../../custom_widget/TextAndWidget.dart';
import '../../../custom_widget/separate_text_field.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/custom_text_field.dart';
import '../login/login_screen.dart';
import '../verify/verify_page.dart';

class SignupScreen extends StatelessWidget {
  SignupScreen({super.key});

  final controller = Get.put(SignupController());

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
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
                    fontFamily: 'Nunito-Sans',
                    fontSize: 28,
                  ),
                ),
                SizedBox(
                  height: 14,
                ),
                Text(
                  'Signup to Continue!',
                  style: TextStyle(
                    color: AppColors.blackColor,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Nunito-Sans',
                    fontSize: 18,
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                TextAndFieldWidget(
                  labelText: 'User Name',
                  hintText: 'Harold Richards',
                  controller: TextEditingController(),
                  isSuffixIcon: true,
                  suffixIcon: Padding(
                    padding: const EdgeInsets.only(
                        left: 10, bottom: 10, top: 10, right: 12),
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
                  controller: TextEditingController(),
                  isSuffixIcon: true,
                  suffixIcon: Padding(
                    padding: const EdgeInsets.only(
                        left: 8.0, bottom: 8, top: 8, right: 12),
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
                    suffixIcon: GestureDetector(
                      onTap: () {
                        controller.isPasswordHidden.value =
                            !controller.isPasswordHidden.value;
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 12.0, bottom: 13, top: 13, right: 12),
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
                    controller: controller.confirmPasswordController,
                    obscureText: controller.isConfirmPasswordHidden.value,
                    isSuffixIcon: true,
                    suffixIcon: GestureDetector(
                      onTap: () {
                        controller.isConfirmPasswordHidden.value =
                            !controller.isConfirmPasswordHidden.value;
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 12.0, bottom: 13, top: 13, right: 12),
                        child: controller.isConfirmPasswordHidden.value == true
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
                        controller.rememberMe.value =
                            !controller.rememberMe.value;
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
                      'I agree with ',
                      style: TextStyle(
                        color: AppColors.headingTextColor,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Nunito-Sans',
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      'Terms & Conditions',
                      style: TextStyle(
                        color: AppColors.primaryColor,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Nunito-Sans',
                        decoration: TextDecoration.underline,
                        decorationColor: AppColors.primaryColor,
                        fontSize: 16,
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
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Nunito-Sans',
                    textColor: Colors.white,
                    width: 200,
                    height: 48,
                    ontapp: () {
                      Get.to(() => VerifyPage());
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
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Nunito-Regular',
                              color: AppColors.headingTextColor),
                        ),
                        TextSpan(
                          text: ' Login',
                          style: TextStyle(
                            color: AppColors.primaryColor,
                            fontSize: 16,
                            fontFamily: 'Nunito-Regular',
                            fontWeight: FontWeight.w600,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () => Get.to(() => LoginScreen()),
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
    );
  }
}
