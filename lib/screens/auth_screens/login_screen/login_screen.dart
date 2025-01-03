import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../constants/colors.dart';
import '../../../utils/responsive.dart';
import '../../../widgets/round_button.dart';
import '../../../widgets/text_field.dart';
import '../forgot_password/forgot_password.dart';
import 'controller/login_controller.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LoginController());

    return Scaffold(
      backgroundColor: AppColors.botomSheetColor,
      body: Container(
        width: double.infinity,
        height: double.infinity, // Ensure full screen height
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/images/bg.png'), fit: BoxFit.cover),
        ),
        child: Center(
          // Centers the container in the middle of the screen
          child: Container(
            width: Responsive.isDesktop(context) ? 510 : 350,
            padding:
                const EdgeInsets.all(16.0), // Adds padding inside the container
            decoration: BoxDecoration(
              color: Colors
                  .transparent, // Background color with opacity for better readability
              borderRadius: BorderRadius.circular(16), // Rounded corners
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment:
                  CrossAxisAlignment.start, // Aligns content to the left
              children: [
                SizedBox(height: Responsive.isDesktop(context) ? 20 : 20),

                // Title Section - Login Text
                Padding(
                  padding: const EdgeInsets.only(bottom: 20.0),
                  child: Center(
                    child: Text(
                      "Login",
                      style: TextStyle(
                        color: AppColors.whiteColor,
                        fontWeight: FontWeight.w700,
                        fontSize: Responsive.isDesktop(context) ? 40 : 30,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 50),

                // Email Label aligned to the left
                Text(
                  "Email",
                  style: TextStyle(
                    color: AppColors.whiteColor,
                    fontWeight: FontWeight.w600,
                    fontSize: Responsive.isDesktop(context) ? 18 : 14,
                  ),
                ),
                SizedBox(height: 8),

                // Email Field with Validation (Centered)
                Obx(() => CustomTextField(
                      controller: controller.emailController,
                      width: double.infinity,
                      borderRadius: 8,
                      hintText: "georgia.young@example.com",
                      fillColor: AppColors.whiteColor.withOpacity(0.2),
                      cursorColor: AppColors.primaryColor,
                      inputStyle: const TextStyle(color: AppColors.whiteColor),
                      hintStyle: const TextStyle(color: AppColors.whiteColor),
                      errorText: controller.emailError.value.isNotEmpty
                          ? controller.emailError.value
                          : null,
                    )),
                SizedBox(height: 12),

                // Password Label aligned to the left
                Text(
                  "Password",
                  style: TextStyle(
                    color: AppColors.whiteColor,
                    fontWeight: FontWeight.w600,
                    fontSize: Responsive.isDesktop(context) ? 18 : 14,
                  ),
                ),
                SizedBox(height: 8),

                // Password Field with Validation (Centered)
                Obx(() => CustomTextField(
                      controller: controller.passwordController,
                      width: double.infinity,
                      borderRadius: 8,
                      hintText: "Unkown@123",
                      fillColor: AppColors.whiteColor.withOpacity(0.2),
                      cursorColor: AppColors.primaryColor,
                      inputStyle: const TextStyle(color: AppColors.whiteColor),
                      hintStyle: const TextStyle(color: AppColors.whiteColor),
                      obscureText: controller.isPasswordHidden.value,
                      suffixIcon: IconButton(
                        icon: Icon(
                          controller.isPasswordHidden.value
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: AppColors.primaryColor,
                        ),
                        onPressed: controller.togglePasswordVisibility,
                      ),
                      errorText: controller.passwordError.value.isNotEmpty
                          ? controller.passwordError.value
                          : null,
                    )),
                SizedBox(height: 12),

                // Forgot Password Link (Aligned to the right)
                Align(
                  alignment: Alignment.centerRight,
                  child: InkWell(
                    onTap: () {
                      Get.to(ForgotPassword());
                    },
                    child: Text(
                      "Forgot Password?",
                      style: TextStyle(
                        color: AppColors.primaryColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 12),

                // Checkbox with text (Remember me)
                Obx(() => Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: AppColors.primaryColor,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(4.0),
                          ),
                          child: Checkbox(
                            value: controller.isRememberMeChecked.value,
                            side: BorderSide(color: Colors.transparent),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4.0)),
                            onChanged: (bool? value) {
                              controller.isRememberMeChecked.value =
                                  value ?? false;
                            },
                            activeColor: Colors.transparent,
                            checkColor: AppColors.primaryColor,
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          "Remember me",
                          style: TextStyle(
                            color: AppColors.primaryColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    )),
                SizedBox(height: 20),

                // Login Button (Centered)
                CustomButton(
                  title: "Login",
                  textStyle: TextStyle(
                      color: AppColors.whiteColor,
                      fontSize: 18,
                      fontWeight: FontWeight.w600),
                  backgroundColor: AppColors.primaryColor,
                  borderRadius: 8,
                  width: double.infinity,
                  onPressed: controller.login, // Call login function
                ),
                SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
