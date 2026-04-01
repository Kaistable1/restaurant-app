import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kaistable_website/constants/app_colors.dart';
import 'package:kaistable_website/screens/auth_screens/signup/controller/signup_controller.dart';
import 'package:kaistable_website/screens/general_preferences/screens_general/preference_2.dart';

import '../../../custom_widget/separate_text_field.dart';
import '../../../widgets/custom_button.dart';
import '../controller/generalPreferences_Controller.dart';
import '../widget/preferencesSelectionWidget.dart';

class Preference1 extends StatelessWidget {
  Preference1({super.key, this.isComeFromSetting});

  final controller = Get.put(GeneralPreferencesController());
  bool? isComeFromSetting;
  @override
  Widget build(BuildContext context) {
    controller.fetchUserPreferences();
    final _formKey = GlobalKey<FormState>();
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: AppBar(
        backgroundColor: AppColors.bgColor,
        iconTheme: IconThemeData(
          color: AppColors.primaryColor,
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
        leading: isComeFromSetting != true
            ? null
            : Padding(
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
            fontSize: 18*(5/4),
            color: AppColors.bottomSheetColor,
            fontWeight: FontWeight.w700,
            fontFamily: GoogleFonts.plusJakartaSans().fontFamily,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: Center(
              child: Text(
                '1/10',
                style: TextStyle(
                  fontSize: 12*(5/4),
                  fontFamily: GoogleFonts.plusJakartaSans().fontFamily,
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 8,
                ),
                Text(
                  'What Are Your Top Three Favorite Cuisines?',
                  style: TextStyle(
                    fontFamily: GoogleFonts.plusJakartaSans().fontFamily,
                    color: AppColors.lightGrey,
                    fontWeight: FontWeight.w600,
                    fontSize: 16*(5/4),
                  ),
                ),
                SizedBox(
                  height: 4,
                ),
                Text(
                  '(Choose any 3)',
                  style: TextStyle(
                    fontFamily: GoogleFonts.plusJakartaSans().fontFamily,
                    color: AppColors.lightGrey,
                    fontWeight: FontWeight.w400,
                    fontSize: 14*(5/4),
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
                ListView.builder(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  primary: false,
                  itemCount: controller.preferences.length,
                  itemBuilder: (context, index) {
                    final preference = controller.preferences[index];
                    return Obx(() {
                      final isSelected = controller.selectedPreferences
                          .contains(preference["name"]);
                      final isOther = preference["name"] == "Other";

                      return GestureDetector(
                        onTap: () =>
                            controller.toggleSelection(preference["name"]!),
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      width: 270,
                                      child: CustomSeparateTextField(
                                        hintText: 'Enter text',
                                        controller:
                                            controller.screen1Controller,
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
                    fontFamily: GoogleFonts.plusJakartaSans().fontFamily,
                    fontWeight: FontWeight.w600,
                    fontSize: 17*(5/4),
                    textColor: Colors.white,
                    ontapp: () async {
                      if (_formKey.currentState!.validate()) {
                        if (controller.selectedPreferences.contains("Other") &&
                            controller.screen1Controller.text.isEmpty) {
                          Get.snackbar(
                            'Error',
                            'Enter favorite cuisines.',
                            backgroundColor: AppColors.primaryColor,
                            colorText: Colors.white,
                            snackPosition: SnackPosition.TOP,
                            margin: EdgeInsets.all(16),
                            borderRadius: 10,
                          );
                          return;
                        }
                        if (controller.selectedPreferences.length < 3) {
                          Get.snackbar(
                            'Selection Incomplete',
                            'Please select at least 3 preferences to proceed.',
                            backgroundColor: AppColors.primaryColor,
                            colorText: Colors.white,
                            snackPosition: SnackPosition.TOP,
                            margin: EdgeInsets.all(16),
                            borderRadius: 10,
                          );
                          return;
                        }
                        if (controller.screen1Controller.text.isNotEmpty) {
                          controller.selectedPreferences
                              .add(controller.screen1Controller.text);
                        }
                        final signupController = Get.put(SignupController());
                        signupController.updateUserData(
                            field: 'topThreeCuisines',
                            entry: controller.selectedPreferences);
                        Get.to(() => Preference2());
                      }
                    },
                  ),
                ),
                SizedBox(
                  height: 24,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
