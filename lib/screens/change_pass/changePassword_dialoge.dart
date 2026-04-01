import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kaistable_website/main.dart';
import 'package:kaistable_website/screens/change_pass/change_controller.dart';

import '../../constants/app_colors.dart';
import '../../custom_widget/TextAndWidget.dart';
import '../../utils/validations.dart';
import '../../widgets/custom_button.dart';

final controller = Get.put(ChangePasswordController());

void changePasswordDialogBox() {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  showDialog(
    barrierDismissible: false,
    context: Get.context!,
    builder: (context) {
      return BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          insetPadding: const EdgeInsets.symmetric(horizontal: 16),
          backgroundColor: AppColors.bgColor,
          surfaceTintColor: AppColors.bgColor,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
            ),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(
                    top: 24, bottom: 24, right: 16, left: 16),
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Change password',
                        style: TextStyle(
                          fontSize: 23,
                          color: AppColors.bottomSheetColor,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'Nunito-Bold',
                        ),
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      Obx(
                        () => TextAndFieldWidget(
                          controller: controller.currentPasswordController,
                          hintText: 'Password',
                          labelText: 'Password',
                          isSuffixIcon: true,
                          validator: (value) {
                            return isPasswordValid(value!);
                          },
                          obscureText: controller.isNewPasswordVisible.value,
                          suffixIcon: Padding(
                            padding: const EdgeInsets.only(
                                top: 13, bottom: 13, right: 13, left: 13),
                            child: GestureDetector(
                              onTap: () {
                                controller.isNewPasswordVisible.value =
                                    !controller.isNewPasswordVisible.value;
                              },
                              child:
                                  controller.isNewPasswordVisible.value == true
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
                          controller: controller.newPasswordController,
                          hintText: 'New Password',
                          labelText: 'New Password',
                          isSuffixIcon: true,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Enter your New password.';
                            } else if (value ==
                                controller.currentPasswordController.text) {
                              return 'New Password should not match with old password';
                            }
                            if (value.length < 8) {
                              return 'Password must be 8 length: ${value.length} /8';
                            }
                            if (!value.contains(RegExp(r'[A-Z]'))) {
                              return 'Password must contain at least one uppercase letter.';
                            }
                            if (!value
                                .contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
                              return 'Password must contain at least one special character.';
                            }
                            return null;
                          },
                          obscureText: controller.isNewPasswordVisible.value,
                          suffixIcon: Padding(
                            padding: const EdgeInsets.only(
                                top: 13, bottom: 13, right: 13, left: 13),
                            child: GestureDetector(
                              onTap: () {
                                controller.isNewPasswordVisible.value =
                                    !controller.isNewPasswordVisible.value;
                              },
                              child:
                                  controller.isNewPasswordVisible.value == true
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
                          controller: controller.confirmPasswordController,
                          hintText: 'Confirm Password',
                          labelText: 'Confirm Password',
                          isSuffixIcon: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a confirm password';
                            }
                            if (value !=
                                controller.newPasswordController.text) {
                              return 'Passwords do not match';
                            }
                            return null;
                          },
                          obscureText:
                              controller.isConfirmPasswordVisible.value,
                          suffixIcon: Padding(
                            padding: const EdgeInsets.only(
                                top: 13, bottom: 13, right: 13, left: 13),
                            child: GestureDetector(
                              onTap: () {
                                controller.isConfirmPasswordVisible.value =
                                    !controller.isConfirmPasswordVisible.value;
                              },
                              child:
                                  controller.isConfirmPasswordVisible.value ==
                                          true
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
                      const SizedBox(height: 36),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CustomButton(
                            width: 140,
                            height: 40,
                            laBelText: 'Save',
                            textColor: AppColors.whiteColor,
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Nunito-Sans',
                            ontapp: () async {
                              print(
                                  'password ${currentUserDataModel!.value.userEmail.text}');
                              if (formKey.currentState!.validate()) {
                                if (formKey.currentState!.validate()) {
                                  await controller.changePassword(
                                      email: currentUserDataModel!
                                          .value.userEmail.text);
                                }
                                Get.back();
                                controller.newPasswordController.clear();
                                controller.newPasswordController.clear();
                                controller.confirmPasswordController.clear();
                              }
                            },
                          ),
                          CustomButton(
                            width: 140,
                            height: 40,
                            laBelText: 'Cancel',
                            containerColor: Colors.white,
                            borderColor: AppColors.primaryColor,
                            textColor: AppColors.primaryColor,
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Nunito-Sans',
                            isBorder: true,
                            ontapp: () {
                              Get.back();
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    },
  );
}
