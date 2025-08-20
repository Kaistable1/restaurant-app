import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:kaistable_website/screens/auth_screens/signup/controller/signup_controller.dart';
import 'package:kaistable_website/screens/general_preferences/screens_general/preference_14.dart';

import '../../../constants/app_colors.dart';
import '../../../custom_widget/separate_text_field.dart';
import '../../../widgets/custom_button.dart';
import '../controller/generalPreferences_Controller.dart';

class Preference13 extends StatelessWidget {
  Preference13({super.key});

  final controller = Get.put(GeneralPreferencesController());

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
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
              },
              child: Icon(Icons.arrow_back, size: 18),
            ),
          ),
        ),
        title: Text(
          'Location and Coverage',
          style: TextStyle(
            fontSize: 19,
            color: AppColors.bottomSheetColor,
            fontWeight: FontWeight.w700,
            fontFamily: 'Nunito-Sans',
          ),
          textAlign: TextAlign.center,
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: Center(
              child: Text(
                '10/11',
                style: TextStyle(
                  fontSize: 12,
                  fontFamily: 'Nunito-Sans',
                  color: AppColors.lightGrey,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                SizedBox(
                  height: 16,
                ),
                Text(
                  'What ZIP Code Should We Use To Find Dining Deals For You?',
                  style: TextStyle(
                    fontFamily: 'Nunito-Sans',
                    color: AppColors.lightGrey,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
                CustomSeparateTextField(
                  hintText: 'Add Zip Code',
                  controller: controller.zipCodeController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  isShadow: true,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Enter zip code.';
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: 36,
                ),
                Center(
                  child: CustomButton(
                    laBelText: 'Next',
                    height: 43,
                    width: 190,
                    fontFamily: 'Nunito-Sans',
                    fontWeight: FontWeight.w600,
                    fontSize: 17,
                    textColor: Colors.white,
                    ontapp: () {
                      if (_formKey.currentState!.validate()) {
                        final signupController = Get.put(SignupController());
                        signupController.updateUserData(
                            field: 'zipCode',
                            entry: controller.zipCodeController.text);
                        Get.to(() => Preference14());
                      }
                    },
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
