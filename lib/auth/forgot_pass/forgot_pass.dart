import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:savrly/constants/app_colors.dart';

import '../../constants/text_styles.dart';
import '../../controllers/login_controller.dart';
import '../../utils/validations.dart';
import '../../widgets/button.dart';
import '../../widgets/custom_textfield.dart';

class ForgotPass extends StatelessWidget {
  ForgotPass({super.key});

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
                    'assets/images/forgot_background.png',
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
                    Center(child: Text("Forgot Password", style: headingText)),
                    SizedBox(height: 10),
                    Center(
                      child: Text(
                        "Enter your email address to reset your password",
                        style: simpleText.copyWith(color: lightColor),
                      ),
                    ),
                    SizedBox(height: 24),

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
                      controller: controller.forgotEmailController,
                      hintText: 'abc@yahoo.com',
                      validator: (value) => isEmailValid(value!),
                      prefixIcon: Icon(
                        Icons.email_outlined,
                        color: primaryColor,
                      ),
                    ),

                    SizedBox(height: 16),

                    SizedBox(height: 25),
                    Center(
                      child: CustomButton(
                        laBelText: 'Submit',
                        width: 250,
                        shadow: [],
                        containerColor: primaryColor,

                        ontapp: () async {
                         await controller.forgotPassword();
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
