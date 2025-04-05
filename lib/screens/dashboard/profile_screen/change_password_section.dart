import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../constants/app_colors.dart';
import '../../../constants/text_styles.dart';
import '../../../controllers/profile_controller.dart';
import '../../../utils/validations.dart';
import '../../../widgets/button.dart';
import '../../../widgets/custom_textfield.dart';

class ChangePasswordSection extends StatelessWidget {
  final controller = Get.put(ProfileController());
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
   ChangePasswordSection({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    bool isMobile = size.width < 600;

    double screenWidth = MediaQuery.of(context).size.width;
    bool isLargeScreen = screenWidth > 1600;
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 12,),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Text('Current password',
                  style: headingText.copyWith(
                      fontSize: isLargeScreen?24:isMobile?14:20
                  ),
                ),
              ),
              SizedBox(height: isMobile?8:12,),
              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Obx(
                    ()=> CustomTextField(
                      controller: controller.currentPasswordController,
                      validator: (value) => isPasswordValid(value!),
                      // maxHeight: isMobile?30:48,
                      // maxWidth: isMobile?380:458,
                      borderRadius: isMobile?4:10,
                      hintText:'6575gfgfvf' ,
                      isObscure: !controller.isCurrentPasswordVisible.value,
                      suffixIcon: IconButton(
                        icon: Icon(
                          controller.isCurrentPasswordVisible.value
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: primaryColor,
                        ),
                        onPressed: controller.toggleCurrentPasswordVisibility,
                      ),

                    ),
                  )
              ),

              SizedBox(height: isMobile?8:12,),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Text('New password',
                  style: headingText.copyWith(
                      fontSize: isLargeScreen?24:isMobile?14:20
                  ),
                ),
              ),
              SizedBox(height: isMobile?8:12,),
              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Obx(
                        ()=> CustomTextField(
                      controller: controller.newPasswordController,
                      validator: (value) => isPasswordValid(value!),
                      // maxHeight: isMobile?30:48,
                      // maxWidth: isMobile?380:458,
                      borderRadius: isMobile?4:10,
                      hintText:'6575gfgfvf' ,
                      isObscure: !controller.isNewPasswordVisible.value,
                      suffixIcon: IconButton(
                        icon: Icon(
                          controller.isNewPasswordVisible.value
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: primaryColor,
                        ),
                        onPressed: controller.toggleNewPasswordVisibility,
                      ),

                    ),
                  )
              ),

              SizedBox(height: isMobile?8:12,),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Text('Current password',
                  style: headingText.copyWith(
                      fontSize: isLargeScreen?24:isMobile?14:20
                  ),
                ),
              ),
              SizedBox(height: isMobile?8:12,),
              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Obx(
                        ()=> CustomTextField(
                      controller: controller.confirmPasswordController,
                          validator: (value) {


                            if(controller.confirmPasswordController.text.isEmpty){
                              return 'Please enter a password';
                            }
                            if (value == controller.currentPasswordController.text) return 'New and confirm password cannot be same as current';
                            return null;
                          },
                      // maxHeight: isMobile?30:48,
                      // maxWidth: isMobile?380:458,
                      borderRadius: isMobile?4:10,
                      hintText:'6575gfgfvf' ,
                      isObscure: !controller.isConfirmPasswordVisible.value,
                      suffixIcon: IconButton(
                        icon: Icon(
                          controller.isConfirmPasswordVisible.value
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: primaryColor,
                        ),
                        onPressed: controller.toggleConfirmPasswordVisibility,
                      ),

                    ),
                  )
              ),

              SizedBox(height: isMobile?8:22,),
              Center(
                child: CustomButton(
                  ontapp: (){
                    if(formKey.currentState!.validate()){
                      Get.snackbar('Success!', "Password changed successfully",maxWidth: 400,backgroundColor: primaryColor,colorText: Colors.white);
                      controller.newPasswordController.clear();
                      controller.currentPasswordController.clear();
                      controller.confirmPasswordController.clear();
                    }
                  },
                  laBelText: 'Save',
                  height: 48,
                  width: 162,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
