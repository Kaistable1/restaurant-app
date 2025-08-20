import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kaistable_website/constants/app_colors.dart';
import 'package:kaistable_website/screens/auth_screens/signup/controller/signup_controller.dart';
import 'package:kaistable_website/screens/general_preferences/screens_general/preference_3.dart';

import '../../../custom_widget/separate_text_field.dart';
import '../../../widgets/custom_button.dart';
import '../controller/generalPreferences_Controller.dart';
import '../widget/preferencesSelectionWidget.dart';

class Preference2 extends StatelessWidget {
  Preference2({super.key});

  final controller = Get.put(GeneralPreferencesController());

  @override
  Widget build(BuildContext context) {
    controller.fetchUserPreferences();

    final formKey = GlobalKey<FormState>();
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
          'General Preferences',
          style: TextStyle(
            fontSize: 17,
            color: AppColors.bottomSheetColor,
            fontWeight: FontWeight.w700,
            fontFamily: 'Nunito-Bold',
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: Center(
              child: Text(
                '2/10',
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
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 8,
                ),
                Text(
                  'Do You Follow Any Specific Dietary Preferences Or Restrictions?',
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
                ListView.builder(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  primary: false,
                  itemCount: controller.preferences2.length,
                  itemBuilder: (context, index) {
                    final preference = controller.preferences2[index];
                    return Obx(() {
                      final isSelected = controller.selectedPreferences2
                          .contains(preference["name"]);
                      final isOther = preference["name"] == "Other";

                      return GestureDetector(
                        onTap: () =>
                            controller.toggleSelection2(preference["name"]!),
                        child: isOther && isSelected
                            ? Container(
                                height: 66,
                                width: Get.width,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      spreadRadius: 1,
                                      blurRadius: 6,
                                      offset: Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      width: 270,
                                      child: CustomSeparateTextField(
                                        hintText: 'Enter text',
                                        controller:
                                            controller.screen2Controller,
                                        keyboardType: TextInputType.name,
                                        isShadow: false,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : PreferencesSelectionWidget(
                                name: preference["name"]!,
                                dinningImage: preference["image"]!,
                                isSelected: isSelected,
                              ),
                      );
                    });
                  },
                ),
                SizedBox(
                  height: 24,
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
                      if (formKey.currentState!.validate()) {
                        if (controller.selectedPreferences2.contains("Other") &&
                            controller.screen2Controller.text.isEmpty) {
                          Get.snackbar(
                            'Error',
                            'Enter any specific dietary preferences or restrictions.',
                            backgroundColor: AppColors.primaryColor,
                            colorText: Colors.white,
                            snackPosition: SnackPosition.TOP,
                            margin: EdgeInsets.all(16),
                            borderRadius: 10,
                          );
                          return;
                        }
                        if (controller.selectedPreferences2.length < 1) {
                          Get.snackbar(
                            'Selection Incomplete',
                            'Please select at least 1 preference to proceed.',
                            backgroundColor: AppColors.primaryColor,
                            colorText: Colors.white,
                            snackPosition: SnackPosition.TOP,
                            margin: EdgeInsets.all(16),
                            borderRadius: 10,
                          );
                          return;
                        }
                        if (controller.screen2Controller.text.isNotEmpty) {
                          controller.selectedPreferences2
                              .add(controller.screen2Controller.text);
                        }

                        final signupController = Get.put(SignupController());
                        signupController.updateUserData(
                            field: 'dietaryPrefList',
                            entry: controller.selectedPreferences2);
                        Get.to(() => Preference3());
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
