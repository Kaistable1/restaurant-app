import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../constants/colors.dart';
import '../../../utils/responsive.dart';
import '../../../widgets/round_button.dart';
import '../../../widgets/text_field.dart';
import 'change_password_controller/change_password_controller.dart';

class ChangePasswordScreen extends StatelessWidget {
  final ChangePasswordController controller =
      Get.put(ChangePasswordController());
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    // Dynamic dimensions for responsiveness
    final double containerWidth = Responsive.isDesktop(context)
        ? MediaQuery.of(context).size.width * 0.4
        : Responsive.isTablet(context)
            ? MediaQuery.of(context).size.width * 0.6
            : MediaQuery.of(context).size.width * 0.9;

    // final double containerHeight = Responsive.isDesktop(context)
    //     ? MediaQuery.of(context).size.height * 0.6
    //     : Responsive.isTablet(context)
    //     ? MediaQuery.of(context).size.height * 0.9
    //     : MediaQuery.of(context).size.height * 1;

    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: Center(
        child: Container(
          width: containerWidth,
          // height: containerHeight,
          decoration: BoxDecoration(
            color: AppColors.whiteColor,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Title
                  Text(
                    'Change Password',
                    style: TextStyle(
                      fontSize: Responsive.isMobile(context) ? 16 : 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.blackColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  // Form
                  Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _buildFieldTitle('Current Password'),
                        _buildPasswordField(
                          controller.currentPassword,
                          controller.validateCurrentPassword,
                          controller.toggleVisibilityForCurrentPassword,
                          controller.currentPasswordObscure,
                        ),
                        _buildFieldTitle('New Password'),
                        _buildPasswordField(
                          controller.newPassword,
                          controller.validateNewPassword,
                          controller.toggleVisibilityForNewPassword,
                          controller.newPasswordObscure,
                        ),
                        _buildFieldTitle('Confirm Password'),
                        _buildPasswordField(
                          controller.confirmPassword,
                          controller.validateConfirmPassword,
                          controller.toggleVisibilityForConfirmPassword,
                          controller.confirmPasswordObscure,
                        ),
                        const SizedBox(height: 16),
                        // Save Button
                        Align(
                          alignment: Alignment.center,
                          child: SizedBox(
                            height: 48,
                            width: containerWidth *
                                0.4, // Ensures the button fits well
                            child: CustomButton(
                              title: "Save",
                              textStyle: TextStyle(
                                color: AppColors.whiteColor,
                                fontSize:
                                    Responsive.isMobile(context) ? 14 : 16,
                                fontWeight: FontWeight.w600,
                              ),
                              backgroundColor: AppColors.primaryColor,
                              borderRadius: 8,
                              onPressed: () {
                                if (_formKey.currentState?.validate() ??
                                    false) {
                                  controller.savePassword(_formKey);
                                  Get.snackbar('Saved',
                                      'Your data is successfully updated');
                                  // Save password logic
                                }
                              },
                            ),
                          ),
                        ),
                      ],
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

  // Title for Each Field
  Widget _buildFieldTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: AppColors.blackColor,
        ),
      ),
    );
  }

  // Reusable Password Field
  Widget _buildPasswordField(
    RxString password,
    String? Function(String?) validator,
    VoidCallback toggleVisibility,
    RxBool obscureText,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Obx(() => CustomTextField(
            obscureText: obscureText.value,
            borderColor: AppColors.darkGrey.withOpacity(.1),
            onChanged: (value) => password.value = value,
            validator: validator,
            width: double.infinity,
            borderRadius: 8,
            hintText: "***********",
            fillColor: AppColors.whiteColor,
            cursorColor: AppColors.primaryColor,
            inputStyle: const TextStyle(color: AppColors.blackColor),
            hintStyle: const TextStyle(color: AppColors.blackColor),
            prefixIcon: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset(
                'assets/images/key.png',
                width: 24,
                height: 24,
              ),
            ),
            suffixIcon: IconButton(
              icon: Icon(
                obscureText.value ? Icons.visibility_off : Icons.visibility,
                color: AppColors.primaryColor,
              ),
              onPressed: toggleVisibility,
            ),
          )),
    );
  }
}
