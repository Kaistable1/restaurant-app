import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kaistable_website/constants/app_colors.dart';
import 'package:kaistable_website/screens/auth_screens/login/controller/login_controller.dart';

import '../../../custom_widget/TextAndWidget.dart';
import '../../../custom_widget/separate_text_field.dart';
import '../../../utils/validations.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/custom_text_field.dart';
import '../../home_screen/my_home_screen.dart';
import '../forgot_pass/forgot_pass_screen.dart';
import '../signup/signup_screen.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final controller = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        backgroundColor: Colors.white,
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
                      fontFamily: 'Nunito-Sans',
                      fontSize: 28,
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
                      fontFamily: 'Nunito-Sans',
                      fontSize: 18,
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
                          fontFamily: 'Nunito-Sans',
                          fontSize: 14,
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
                          fontFamily: 'Nunito-Sans',
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
                      laBelText: 'Login',
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Nunito-Sans',
                      textColor: Colors.white,
                      width: 200,
                      height: 48,
                      ontapp: () {
                        if (_formKey.currentState!.validate()) {
                          controller.emailController.clear();
                          controller.passwordController.clear();
                          Get.to(() => MyHomeScreen(
                                countryName: 'USA',
                              ));
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
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Nunito-Regular',
                                color: AppColors.headingTextColor),
                          ),
                          TextSpan(
                            text: ' Signup',
                            style: TextStyle(
                              color: AppColors.primaryColor,
                              fontSize: 16,
                              fontFamily: 'Nunito-Regular',
                              fontWeight: FontWeight.w600,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () => Get.to(() => SignupScreen()),
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
