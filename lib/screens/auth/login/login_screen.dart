import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../constants/app_colors.dart';
import '../../../constants/text_styles.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/custom_textfield.dart';
import '../../main_screen.dart';
import 'controller/login_controller.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LoginController());
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset(
                  'assets/images/logo.png',
                  height: MediaQuery.of(context).size.height * 0.3,
                  width: MediaQuery.of(context).size.height * 1,
                  fit: BoxFit.fitWidth,
                ),
                // SizedBox(height: 20),
                // Center(
                //   child: Text(
                //     'Savrly',
                //     textAlign: TextAlign.center,
                //     style: headingText,
                //   ),
                // ),
                SizedBox(height: 10),
                Center(
                  child: Text(
                    'Join the food journey now',
                    textAlign: TextAlign.center,
                    style: subHeadingText,
                  ),
                ),
                SizedBox(height: 20),
                buildFieldLabel('Email'),
                Obx(
                  () => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomTextField(
                        controller: controller.emailController,
                        hintText: 'abc@example.com',
                        fillColor: white,
                        borderRadius: 20,
                        suffixIcon: Icon(
                          Icons.email_rounded,
                          size: 20,
                          color: blackColor,
                        ),
                      ),
                      if (controller.emailError.isNotEmpty)
                        Text(
                          controller.emailError.value,
                          style: TextStyle(color: Colors.red, fontSize: 12),
                        ),
                    ],
                  ),
                ),
                buildFieldLabel('Password'.tr),
                Obx(
                  () => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomTextField(
                        controller: controller.passwordController,
                        hintText: '***********',
                        obscureText: !controller.isPasswordVisible.value,
                        fillColor: white,
                        borderRadius: 20,
                        suffixIcon: IconButton(
                          icon: Image.asset(
                            controller.isPasswordVisible.value
                                ? 'assets/images/visibility_on.png'
                                : 'assets/images/visibility_off.png',
                            color: blackColor,
                            width: 24,
                            height: 24,
                          ),
                          onPressed: controller.togglePasswordVisibility,
                        ),
                      ),
                      if (controller.passwordError.isNotEmpty)
                        Text(
                          controller.passwordError.value,
                          style: TextStyle(color: Colors.red, fontSize: 12),
                        ),
                    ],
                  ),
                ),
                SizedBox(height: 30),
                CustomButton(
                  btnText: 'Get started',
                  btnTextStyle:
                      headingText.copyWith(color: hintColor, fontSize: 18),
                  btnColor: white,
                  borderColor: white,
                  // onTap: () => controller.submitForm(),
                  onTap: () => Get.offAll(() =>
                      MainScreen()),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildFieldLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 10),
      child: Text(
        text,
        style: subHeadingText,
      ),
    );
  }
}
