import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:savrly/constants/app_colors.dart';

import '../../constants/text_styles.dart';
import '../../controllers/login_controller.dart';
import '../../screens/admin/admin_panel.dart';
import '../../utils/validations.dart';
import '../../widgets/button.dart';
import '../../widgets/custom_textfield.dart';
import '../forgot_pass/forgot_pass.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final controller = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    bool isMobile = size.width < 600;

    return Scaffold(
      body: Row(
        children: [
          if (!isMobile)
            Expanded(
              flex: 7,
              child: Container(
                child: Center(
                  child: Image.asset(
                    'assets/images/background_green.png',
                    fit: BoxFit.cover,
                    width: Get.width,
                  ),
                ),
              ),
            ),
          Expanded(
            flex: 5,
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: isMobile ? 24 : 48,
                vertical: isMobile ? 16 : 32,
              ),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  // Left align text
                  children: [
                    Center(child: Text("Login", style: headingText)),
                    const SizedBox(height: 24),

                    // Email Field
                    Text(
                      "Email",
                      style: simpleText.copyWith(
                        fontWeight: FontWeight.w700,
                        fontSize: 20,
                      ),
                    ),
                    SizedBox(height: 6),
                    CustomTextField(
                      controller: controller.emailController,
                      hintText: 'abc@yahoo.com',
                      validator: (value) => isEmailValid(value!),
                      prefixIcon: Icon(
                        Icons.email_outlined,
                        color: primaryColor,
                      ),
                    ),

                    SizedBox(height: 16),

                    // Password Field
                    Text(
                      "Password",
                      style: simpleText.copyWith(
                        fontWeight: FontWeight.w700,
                        fontSize: 20,
                      ),
                    ),
                    SizedBox(height: 6),
                    Obx(
                      () => CustomTextField(
                        controller: controller.passwordController,
                        hintText: 'Password',
                        validator: (value) => isPasswordValid(value!),
                        isObscure: !controller.isPasswordVisible.value,
                        prefixIcon: Icon(
                          Icons.lock_open_outlined,
                          color: primaryColor,
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            controller.isPasswordVisible.value
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: primaryColor,
                          ),
                          onPressed: controller.togglePasswordVisibility,
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                         Get.to(() => ForgotPass());
                        },
                        child: Text(
                          "Forgot Password?",
                          style: simpleText.copyWith(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: primaryColor,
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 25),
                    Center(
                      child: CustomButton(
                        laBelText: 'Login',
                        width: 250,
                        shadow: [],
                        containerColor: primaryColor,
                        ontapp: () {
                          Get.to(() => AdminPanel());
                          // if (formKey.currentState!.validate()) {
                          //   controller.emailController.clear();
                          //   controller.passwordController.clear();
                          //   Get.to(() => AdminPanel());
                          // }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
