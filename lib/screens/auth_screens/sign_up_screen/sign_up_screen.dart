import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../constants/colors.dart';
import '../../../utils/responsive.dart';
import '../../../widgets/auth_textfield.dart';
import '../../../widgets/round_button.dart';
import 'controller/sign_up_controller.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SignUpController());

    return Scaffold(
      backgroundColor: AppColors.botomSheetColor,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/images/bg.png'), fit: BoxFit.cover),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              width: Responsive.isDesktop(context) ? 510 : 350,
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: Responsive.isDesktop(context) ? 20 : 20),

                  // Title Section - Sign Up Text
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20.0),
                    child: Center(
                      child: Text(
                        "Sign Up",
                        style: TextStyle(
                          color: AppColors.whiteColor,
                          fontWeight: FontWeight.w700,
                          fontSize: Responsive.isDesktop(context) ? 40 : 30,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Owner Name Label
                  Text(
                    "Owner Name",
                    style: TextStyle(
                      color: AppColors.whiteColor,
                      fontWeight: FontWeight.w600,
                      fontSize: Responsive.isDesktop(context) ? 18 : 14,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Owner Name Field
                  Obx(() => AuthTextField(
                        controller: controller.ownerNameController,
                        width: double.infinity,
                        borderRadius: 8,
                        hintText: "John Doe",
                        fillColor: AppColors.whiteColor.withOpacity(0.2),
                        cursorColor: AppColors.primaryColor,
                        inputStyle: const TextStyle(color: AppColors.whiteColor),
                        hintStyle: const TextStyle(color: AppColors.whiteColor),
                        errorText: controller.ownerNameError.value.isNotEmpty
                            ? controller.ownerNameError.value
                            : null,
                      )),
                  const SizedBox(height: 12),

                  // Email Label
                  Text(
                    "Email",
                    style: TextStyle(
                      color: AppColors.whiteColor,
                      fontWeight: FontWeight.w600,
                      fontSize: Responsive.isDesktop(context) ? 18 : 14,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Email Field
                  Obx(() => AuthTextField(
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
                  const SizedBox(height: 12),

                  // Phone Number Label
                  Text(
                    "Phone Number",
                    style: TextStyle(
                      color: AppColors.whiteColor,
                      fontWeight: FontWeight.w600,
                      fontSize: Responsive.isDesktop(context) ? 18 : 14,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Phone Number Field
                  Obx(() => AuthTextField(
                        controller: controller.phoneController,
                        width: double.infinity,
                        borderRadius: 8,
                        hintText: "+1 (555) 123-4567",
                        fillColor: AppColors.whiteColor.withOpacity(0.2),
                        cursorColor: AppColors.primaryColor,
                        inputStyle: const TextStyle(color: AppColors.whiteColor),
                        hintStyle: const TextStyle(color: AppColors.whiteColor),
                        errorText: controller.phoneError.value.isNotEmpty
                            ? controller.phoneError.value
                            : null,
                      )),
                  const SizedBox(height: 12),

                  // Password Label
                  Text(
                    "Password",
                    style: TextStyle(
                      color: AppColors.whiteColor,
                      fontWeight: FontWeight.w600,
                      fontSize: Responsive.isDesktop(context) ? 18 : 14,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Password Field
                  Obx(() => AuthTextField(
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
                  const SizedBox(height: 20),

                  // Image Picker Section
                  Text(
                    "Profile Image",
                    style: TextStyle(
                      color: AppColors.whiteColor,
                      fontWeight: FontWeight.w600,
                      fontSize: Responsive.isDesktop(context) ? 18 : 14,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Image Preview and Picker Button
                  Obx(() => Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.whiteColor.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: controller.imageError.value.isNotEmpty
                                ? Colors.red
                                : Colors.transparent,
                            width: 1,
                          ),
                        ),
                        child: Column(
                          children: [
                            if (controller.selectedImage.value != null)
                              Container(
                                width: 100,
                                height: 100,
                                margin: const EdgeInsets.only(bottom: 12),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  image: DecorationImage(
                                    image: MemoryImage(
                                        controller.selectedImage.value!),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            InkWell(
                              onTap: controller.pickImage,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 12),
                                decoration: BoxDecoration(
                                  color: AppColors.primaryColor,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  controller.selectedImage.value != null
                                      ? "Change Image"
                                      : "Pick Image",
                                  style: const TextStyle(
                                    color: AppColors.whiteColor,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                            if (controller.imageError.value.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Text(
                                  controller.imageError.value,
                                  style: const TextStyle(
                                    color: Colors.red,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      )),
                  const SizedBox(height: 30),

                  // Sign Up Button
                  CustomButton(
                    title: "Sign Up",
                    textStyle: const TextStyle(
                        color: AppColors.whiteColor,
                        fontSize: 18,
                        fontWeight: FontWeight.w600),
                    backgroundColor: AppColors.primaryColor,
                    borderRadius: 8,
                    width: double.infinity,
                    onPressed: () {
                      if (controller.validateFields()) {
                        controller.signUp();
                      }
                    },
                  ),
                  const SizedBox(height: 20),

                  // Login Link
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Already have an account? ",
                          style: TextStyle(
                            color: AppColors.whiteColor,
                            fontSize: Responsive.isDesktop(context) ? 16 : 14,
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Get.back();
                          },
                          child: Text(
                            "Login",
                            style: TextStyle(
                              color: AppColors.primaryColor,
                              fontSize: Responsive.isDesktop(context) ? 16 : 14,
                              fontWeight: FontWeight.w600,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

