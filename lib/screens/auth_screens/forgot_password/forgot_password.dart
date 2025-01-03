import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../constants/colors.dart';
import '../../../utils/responsive.dart';
import '../../../widgets/round_button.dart';
import '../../../widgets/text_field.dart';
import 'controller/forgot_controller.dart';

class ForgotPassword extends StatelessWidget {
  final controller = Get.put(ForgotController());
  ForgotPassword({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.botomSheetColor,
      body: Container(
        width: double.infinity,
        height: double.infinity, // Ensure full screen height
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/images/bg.png'), fit: BoxFit.cover),
        ),
        child: Stack(
          children: [
            Center(
              child: Container(
                width: Responsive.isDesktop(context) ? 500 : 350,
                // height: Responsive.isDesktop(context) ? 412 : 350,

                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 20.0),
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Forgot password",
                                style: TextStyle(
                                  color: AppColors.whiteColor,
                                  fontWeight: FontWeight.w700,
                                  fontSize:
                                      Responsive.isDesktop(context) ? 40 : 30,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 50),
                      Text(
                        "Email",
                        style: TextStyle(
                          color: AppColors.whiteColor,
                          fontWeight: FontWeight.w600,
                          fontSize: Responsive.isDesktop(context) ? 18 : 14,
                        ),
                      ),
                      SizedBox(height: 8),
                      // Email Field with Validation
                      Obx(() => CustomTextField(
                            controller: controller.emailController,
                            width: double.infinity,
                            borderRadius: 8,
                            hintText: "georgia.young@example.com",
                            fillColor: AppColors.whiteColor.withOpacity(0.2),
                            cursorColor: AppColors.primaryColor,
                            inputStyle:
                                const TextStyle(color: AppColors.whiteColor),
                            hintStyle:
                                const TextStyle(color: AppColors.whiteColor),
                            errorText: controller.emailError.value.isNotEmpty
                                ? controller.emailError.value
                                : null,
                          )),
                      const SizedBox(height: 30),

                      // Login Button
                      CustomButton(
                        title: "Submit",
                        textStyle: TextStyle(
                            color: AppColors.whiteColor,
                            fontSize: 18,
                            fontWeight: FontWeight.w600),
                        backgroundColor: AppColors.primaryColor,
                        borderRadius: 8,
                        width: double.infinity,

                        onPressed: controller.reset, // Call login function
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 12.0, top: 20),
              child: Align(
                alignment: Alignment.topLeft,
                child: Container(
                  width: Responsive.isMobile(context)
                      ? 30
                      : (Responsive.isTablet(context) ? 36 : 42),
                  height: Responsive.isMobile(context)
                      ? 30
                      : (Responsive.isTablet(context) ? 36 : 42),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 6,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: IconButton(
                    iconSize: Responsive.isMobile(context)
                        ? 14
                        : (Responsive.isTablet(context) ? 16 : 18),
                    icon: Icon(Icons.arrow_back, color: AppColors.primaryColor),
                    onPressed: () {
                      Get.back();
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
