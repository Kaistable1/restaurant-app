
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kaistable_website/constants/app_colors.dart';
import 'package:kaistable_website/screens/auth_screens/login/login_screen.dart';

import '../../../custom_widget/TextAndWidget.dart';
import '../../../dialoges/reset_dialog.dart';
import '../../../widgets/custom_button.dart';
import 'controller/forgot_pass_controller.dart';

class ForgotPassScreen extends StatelessWidget {
  ForgotPassScreen({super.key});

  final controller = Get.put(ForgotPassController());

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
              crossAxisAlignment: CrossAxisAlignment.center,
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
                  height: 53,
                ),
                Text(
                  'Forget Password',
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
                  'Not to worry, it happens to the best of us. Please enter your email address below.',
                  style: TextStyle(
                    color: AppColors.blackColor,
                    fontWeight: FontWeight.w300,
                    fontFamily: 'Nunito-Sans',
                    fontSize: 15,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 30,
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
                SizedBox(
                  height: 40,
                ),
                Center(
                  child: CustomButton(
                    laBelText: 'Submit',
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Nunito-Sans',
                    textColor: Colors.white,
                    width: 200,
                    height: 48,
                    ontapp: () {
                      dialogueBox(
                          text:
                              'A reset link has been emailed to you. Please also check your spam.',
                          color: AppColors.primaryColor,
                          onPressed: () {
                            Get.off(() => LoginScreen());
                          });
                      controller.emailController.clear();
                    },
                  ),
                ),
                SizedBox(
                  height: 24,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
