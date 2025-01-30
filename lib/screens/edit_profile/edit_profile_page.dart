import 'dart:ffi';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kaistable_website/main.dart';
import 'package:kaistable_website/screens/edit_profile/widget/image_picker.dart';

import '../../constants/app_colors.dart';
import '../../custom_widget/TextAndWidget.dart';
import '../../widgets/custom_button.dart';
import 'controller/profile_controller.dart';

class EditProfilePage extends StatelessWidget {
  EditProfilePage({super.key});

  final controller = Get.put(ProfileController());

  @override
  Widget build(BuildContext context) {
    final _formkey = GlobalKey<FormState>();
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: AppBar(
        backgroundColor: AppColors.bgColor,
        iconTheme: IconThemeData(
          color: AppColors.primaryColor,
        ),
        centerTitle: true,
        automaticallyImplyLeading: true,
        leading: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Container(
            height: 16,
            width: 16,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 3,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: GestureDetector(
              onTap: () {
                Get.back();
                ;
              },
              child: Icon(Icons.arrow_back, size: 18),
            ),
          ),
        ),
        title: Text(
          'Edit Profile',
          style: TextStyle(
            fontSize: 20,
            color: AppColors.bottomSheetColor,
            fontWeight: FontWeight.w700,
            fontFamily: 'Nunito-Bold',
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Form(
            key: _formkey,
            child: Column(
              children: [
                SizedBox(
                  height: 20,
                ),
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      height: 100,
                      width: 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [AppColors.primaryColor, AppColors.hintText],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                      child: Container(
                        margin: EdgeInsets.all(1),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: Obx(
                          () => Container(
                            width: 92,
                            height: 92,
                            margin: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                  image: controller.imagePath.isNotEmpty
                                      ? FileImage(
                                          File(
                                            controller.imagePath.toString(),
                                          ),
                                        )
                                      : currentUserDataModel!
                                              .value.userImage.value.isNotEmpty
                                          ? NetworkImage(currentUserDataModel
                                                  ?.value.userImage.value ??
                                              '')
                                          : const AssetImage(
                                              'assets/images/edit_profile_image.png',
                                            ) as ImageProvider<Object>,
                                  fit: BoxFit.cover,
                                )),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: -3,
                      right: 4,
                      child: GestureDetector(
                        onTap: () {
                          pickImageBottomSheet(
                            () {
                              controller.pickImage(
                                controller.imagePath,
                                ImageSource.camera,
                              );
                            },
                            () {
                              controller.pickImage(
                                controller.imagePath,
                                ImageSource.gallery,
                              );
                            },
                          );
                        },
                        child: Container(
                          height: 32,
                          width: 32,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.primaryColor.withOpacity(0.9)),
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 6, bottom: 8, top: 8, right: 6),
                            child: Image.asset(
                              'assets/images/camera_icon.png',
                              height: 16,
                              width: 20,
                              color: Colors.white,
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 28,
                ),
                TextAndFieldWidget(
                  labelText: 'User Name',
                  hintText: 'Denna Jones',
                  controller: controller.userNameController,
                  isSuffixIcon: true,
                  suffixIcon: Padding(
                    padding: const EdgeInsets.only(
                        left: 12, bottom: 12, top: 12, right: 8),
                    child: Image.asset(
                      'assets/images/user_icon.png',
                      height: 20,
                      width: 20,
                    ),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter user name.';
                    }
                    return null;
                  },
                ),
                TextAndFieldWidget(
                  labelText: 'Email',
                  readOnly: true,
                  hintText: 'deanna.curtis@example.com',
                  controller: controller.emailController,
                  isSuffixIcon: true,
                  suffixIcon: Padding(
                    padding: const EdgeInsets.only(
                        left: 13.0, bottom: 8, top: 8, right: 13),
                    child: Image.asset(
                      'assets/images/email.icon.png',
                      height: 20,
                      width: 20,
                    ),
                  ),
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
                ),
                SizedBox(
                  height: 40,
                ),
                Center(
                  child: CustomButton(
                    laBelText: 'Save',
                    fontFamily: 'Nunito-Sans',
                    fontSize: 20,
                    textColor: Colors.white,
                    fontWeight: FontWeight.w600,
                    height: 43,
                    width: 170,
                    ontapp: () async {
                      if (_formkey.currentState!.validate()) {
                        if (controller.imagePath.isEmpty) {
                          Get.snackbar(
                            'Image Required',
                            'Please upload a profile image.',
                            snackPosition: SnackPosition.TOP,
                            backgroundColor: AppColors.primaryColor,
                            colorText: Colors.white,
                          );
                          return;
                        } else {
                          print('press');
                          await controller.updateProfile();
                          // controller.userNameController.clear();
                          // Get.back();
                        }
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
