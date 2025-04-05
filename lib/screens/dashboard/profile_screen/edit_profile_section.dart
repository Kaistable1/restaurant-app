import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:savrly/widgets/button.dart';
import 'package:savrly/widgets/custom_textfield.dart';

import '../../../constants/app_colors.dart';
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
              SizedBox(height: 12,),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Text('First name',
                  style: headingText.copyWith(
                      fontSize: isLargeScreen?24:isMobile?14:20
                  ),
                ),
              ),
              SizedBox(height: isMobile?8:12,),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: SizedBox(

                  child: CustomTextField(
                    controller: controller.firstNameController,
                    validator: (value) => isFirstNameValid(value!),
                    maxHeight: isMobile?30:48,
                    maxWidth: isMobile?380:458,
                    borderRadius: isMobile?4:10,
                    hintText:'Guy' ,

                  ),
                )
              ),
              SizedBox(height: isMobile?8:12,),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Text('Last name',
                  style: headingText.copyWith(
                      fontSize: isLargeScreen?24:isMobile?14:20
                  ),
                ),
              ),
              SizedBox(height: isMobile?8:12,),
              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: CustomTextField(
                    controller: controller.lastNameController,
                    validator: (value) => isLastNameValid(value!),
                    maxHeight: isMobile?30:48,
                    maxWidth: isMobile?380:458,
                    borderRadius: isMobile?4:10,
                    hintText:'Hawkins' ,
          
                  )
              ),
          
              SizedBox(height: isMobile?8:12,),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Text('Email',
                  style: headingText.copyWith(
                      fontSize: isLargeScreen?24:isMobile?14:20
                  ),
                ),
              ),
              SizedBox(height: isMobile?8:12,),
              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: CustomTextField(
                    controller: controller.emailController,
                    validator: (value) => isEmailValid(value!),
                    maxHeight: isMobile?30:48,
                    maxWidth: isMobile?380:458,
                    borderRadius: isMobile?4:10,
                    hintText:'Guy@gmail.com' ,
          
                  )
              ),
          
              SizedBox(height: isMobile?8:12,),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Text('Phone number',
                  style: headingText.copyWith(
                      fontSize: isLargeScreen?24:isMobile?14:20
                  ),
                ),
              ),
              SizedBox(height: isMobile?8:12,),
              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: CustomTextField(
                    controller: controller.phoneController,
                    validator: (value) => isPhoneNumberValid(value!),
                    maxHeight: isMobile?30:48,
                    maxWidth: isMobile?380:458,
                    borderRadius: isMobile?4:10,
                    hintText:'+769 55654564444' ,
          
                  )
              ),
              SizedBox(height: isMobile?8:18,),
              Center(
                child: CustomButton(
                  ontapp: (){
                    if(formKey.currentState!.validate()){
                      Get.snackbar('Success!', "Profile save successfully",maxWidth: 400,backgroundColor: primaryColor,colorText: Colors.white);
                      controller.firstNameController.clear();
                      controller.lastNameController.clear();
                      controller.emailController.clear();
                      controller.phoneController.clear();
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
//0347005