import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../constants/app_colors.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/custom_dropdown.dart';
import '../../home_screen/my_home_screen.dart';
import '../controller/generalPreferences_Controller.dart';

class Preference14 extends StatelessWidget {
  Preference14({super.key});

  final controller = Get.put(GeneralPreferencesController());

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
                '14/14',
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
          child: Column(
            children: [
              SizedBox(
                height: 16,
              ),
              Text(
                'What ZIP code should we use to find dining deals for you?',
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
              Obx(() => Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      DropDownButton(
                        hintText: 'Country',
                        fontfamily: 'Nunito-Sans',
                        items: const ["USA", "France"],
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
                        items: const [
                          "New York",
                          "Los Angeles",
                          "Paris",
                        ],
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
                  laBelText: 'Done',
                  height: 44,
                  width: 190,
                  fontFamily: 'Nunito-Sans',
                  fontWeight: FontWeight.w600,
                  fontSize: 20,
                  textColor: Colors.white,
                  ontapp: () {
                    print(controller.selectedCountry.value);
                    if (controller.selectedCountry.value!.isEmpty ||
                        controller.selectedCity.value!.isEmpty) {
                      Get.snackbar(
                        'Missing Information',
                        'Please select both country and city.',
                        snackPosition: SnackPosition.TOP,
                        backgroundColor: AppColors.primaryColor,
                        colorText: Colors.white,
                        margin: EdgeInsets.all(16),
                      );
                    } else {
                      Get.offAll(
                            () => MyHomeScreen(
                          countryName: controller.selectedCity.value,
                        ),
                      );
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
