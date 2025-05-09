import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:savrly/widgets/button.dart';
import 'package:savrly/widgets/custom_textfield.dart';

import '../../../constants/text_styles.dart';
import '../../../controllers/profile_controller.dart';
import '../../../utils/validations.dart';

class EditProfileSection extends StatelessWidget {
  final controller = Get.put(ProfileController());
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  EditProfileSection({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    bool isMobile = size.width < 600;

    double screenWidth = MediaQuery.of(context).size.width;
    bool isLargeScreen = screenWidth > 1600;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Form(
        key: formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 12,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Text(
                  'Full name',
                  style: headingText.copyWith(
                      fontSize: isLargeScreen
                          ? 24
                          : isMobile
                              ? 14
                              : 20),
                ),
              ),
              SizedBox(
                height: isMobile ? 8 : 12,
              ),
              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: SizedBox(
                    child: CustomTextField(
                      controller: controller.firstNameController,
                      validator: (value) => isFirstNameValid(value!),
                      borderRadius: isMobile ? 4 : 10,
                      hintText: 'Guy',
                    ),
                  )),
              SizedBox(
                height: isMobile ? 8 : 12,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Text(
                  'Email',
                  style: headingText.copyWith(
                      fontSize: isLargeScreen
                          ? 24
                          : isMobile
                              ? 14
                              : 20),
                ),
              ),
              SizedBox(
                height: isMobile ? 8 : 12,
              ),
              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: CustomTextField(
                    controller: controller.emailController,
                    validator: (value) => isEmailValid(value!),
                    borderRadius: isMobile ? 4 : 10,
                    readOnly: true,
                    hintText: 'Guy@gmail.com',
                  )),
              SizedBox(
                height: isMobile ? 8 : 12,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Text(
                  'Phone number',
                  style: headingText.copyWith(
                      fontSize: isLargeScreen
                          ? 24
                          : isMobile
                              ? 14
                              : 20),
                ),
              ),
              SizedBox(
                height: isMobile ? 8 : 12,
              ),
              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: CustomTextField(
                    controller: controller.phoneController,
                    validator: (value) => isPhoneNumberValid(value!),
                    borderRadius: isMobile ? 4 : 10,
                    hintText: '+769 55654564444',
                  )),
              SizedBox(
                height: isMobile ? 8 : 18,
              ),
              Center(
                child: CustomButton(
                  ontapp: () async {
                    if (formKey.currentState!.validate()) {
                      await controller.updateProfile();
                    }
                  },
                  laBelText: 'Save',
                  height: 48,
                  width: 162,
                ),
              ),
              SizedBox(
                height: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
//0347005
