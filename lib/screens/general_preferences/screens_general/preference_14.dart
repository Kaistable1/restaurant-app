import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kaistable_website/screens/auth_screens/signup/controller/signup_controller.dart';
import 'package:kaistable_website/screens/entry_mode/entry_mode_screen.dart';
import 'package:kaistable_website/screens/nav_bar/controller/home_controller.dart';
import 'package:kaistable_website/screens/nav_bar/controller/search_controller.dart';
import 'package:kaistable_website/screens/nav_bar/main_screen.dart';

import '../../../constants/app_colors.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/custom_dropdown.dart';
import '../controller/generalPreferences_Controller.dart';

class Preference14 extends StatelessWidget {
  Preference14({super.key, this.isSequential = true});

  final controller = Get.put(GeneralPreferencesController());
  final bool isSequential;

  @override
  Widget build(BuildContext context) {
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
                Navigator.pop(context);
              },
              child: Icon(Icons.arrow_back, size: 18),
            ),
          ),
        ),
        title: Text(
          'Location and Coverage',
          style: TextStyle(
            fontSize: 18 * (5 / 4),
            color: AppColors.bottomSheetColor,
            fontWeight: FontWeight.w700,
            fontFamily: GoogleFonts.plusJakartaSans().fontFamily,
          ),
          textAlign: TextAlign.center,
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: Center(
              child: Text(
                '10/10',
                style: TextStyle(
                  fontSize: 12 * (5 / 4),
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 16,
              ),
              Text(
                'Which Location Do You Prefer?',
                style: TextStyle(
                  fontFamily: GoogleFonts.plusJakartaSans().fontFamily,
                  color: AppColors.lightGrey,
                  fontWeight: FontWeight.w600,
                  fontSize: 16 * (5 / 4),
                ),
              ),
              SizedBox(
                height: 16,
              ),
              Obx(() => Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      DropDownButton(
                        hintText: 'States',
                        fontfamily: 'Nunito-Sans',
                        items: const ["New York", "Los Angeles"],
                        containerColor: const Color(0xFFFFFFFF),
                        textColor: Colors.grey,
                        onChanged: (value) {
                          controller.selectedCountry.value = value!;
                        },
                        selectedValue: controller.selectedCountry.value,
                        height: 52,
                        width: Get.width,
                        hintfontsize: 12,
                      ),
                      SizedBox(height: 16),
                      DropDownButton(
                        height: 52,
                        width: Get.width,
                        hintText: "City",
                        fontfamily: 'Nunito-Sans',
                        hintfontsize: 14,
                        dropdownItemWidth: 100,
                        items: controller.selectedCountry.value == "Los Angeles"
                            ? FilterController().losAngelusCities
                            : controller.selectedCountry.value == "New York"
                                ? FilterController().newYorkCitiesList
                                : [],
                        selectedValue: controller.selectedCity.value,
                        onChanged: (value) {
                          controller.selectedCity.value = value!;
                        },
                        containerColor: const Color(0xFFFFFFFF),
                        textColor: Colors.grey,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                    ],
                  )),
              SizedBox(
                height: 20,
              ),
              Center(
                child: CustomButton(
                  laBelText: isSequential ? 'Done' : 'Save',
                  height: 44,
                  width: 190,
                  fontFamily: GoogleFonts.plusJakartaSans().fontFamily,
                  fontWeight: FontWeight.w600,
                  fontSize: 17 * (5 / 4),
                  textColor: Colors.white,
                  ontapp: () {
                    print(controller.selectedCountry.value);
                    if (controller.selectedCountry.value.isEmpty ||
                        controller.selectedCity.value.isEmpty) {
                      Get.snackbar(
                        'Missing Information',
                        'Please select both country and city.',
                        snackPosition: SnackPosition.TOP,
                        backgroundColor: AppColors.primaryColor,
                        colorText: Colors.white,
                        margin: EdgeInsets.all(16),
                      );
                    } else {
                      final signupController = Get.put(SignupController());
                      signupController.updateUserData(
                          field: 'country',
                          entry: controller.selectedCountry.value);
                      signupController.updateUserData(
                          field: 'city', entry: controller.selectedCity.value);
                      if (isSequential) {
                        if (Get.isRegistered<HomeController>()) {
                          Get.offAll(() => MainScreen());
                        } else {
                          Get.offAll(
                            () => EntryModeScreen(),
                          );
                        }
                      } else {
                        Get.back();
                      }
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
    );
  }
}
