import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kaistable_website/constants/app_colors.dart';
import 'package:kaistable_website/screens/auth_screens/signup/signup_screen.dart';
import 'package:kaistable_website/screens/home_screen/my_home_screen.dart';
import 'package:kaistable_website/screens/onboarding_screen/onboarding_controller/onboarding_controller.dart';

import '../../widgets/custom_button.dart';
import '../../widgets/custom_dropdown.dart';

class OnboardingScreen extends StatelessWidget {
  final controller = Get.put(OnboardingController());

  OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: Get.width,
                height: 250,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image:
                        AssetImage("assets/images/onboarding_background.png"),
                  ),
                ),
                child: Center(
                  child: Image.asset(
                    'assets/images/onboarding_top2.png',
                    width: 180,
                    height: 180,
                  ),
                ),
              ),
              SizedBox(height: 14),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  "Explore Restaurants with SAVRLY",
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'aftika-regular',
                    color: AppColors.headingTextColor,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16, right: 16),
                child: Text(
                  "Discover the best dining spots with SAVRLY! Our user-friendly app lets you explore local restaurants, view menus, and read reviews to find your next favorite meal. Enjoy a seamless culinary journey at your fingertips.",
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'Lora-Regular',
                    color: AppColors.headingTextColor,
                  ),
                ),
              ),
              const SizedBox(height: 0),
              Container(
                color: AppColors.whiteColor,
                width: Get.width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/images/off image.png',
                          width: 370,
                          height: 250,
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 0),
                          child: ChooseLocationWidget(controller: controller),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 50,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ChooseLocationWidget extends StatelessWidget {
  const ChooseLocationWidget({
    super.key,
    required this.controller,
  });

  final OnboardingController controller;

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "Choose Location",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w400,
              fontFamily: 'aftika-regular',
              color: AppColors.headingTextColor,
            ),
          ),
          SizedBox(height: 10),
          Obx(() => Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  DropDownButton(
                    hintText: 'Country',
                    items: const ["USA", "France"],
                    containerColor: const Color(0xFFFFFFFF),
                    textColor: Colors.grey,
                    onChanged: (value) {
                      controller.selectedCountry.value = value!;
                      controller.hasError.value = false;
                    },
                    selectedValue: controller.selectedCountry.value,
                    height: 52,
                    width: 320,
                    hintfontsize: 12,
                  ),
                  SizedBox(height: 10),
                  DropDownButton(
                    height: 52,
                    width: 320,
                    hintText: "City",
                    hintfontsize: 14,
                    dropdownItemWidth: 100,
                    items: controller.selectedCountry.value == 'USA'
                        ? const [
                            "New York",
                            "Los Angeles",
                          ]
                        : const [
                            "Paris",
                          ],
                    selectedValue: controller.selectedCity.value,
                    onChanged: (value) {
                      controller.selectedCity.value = value!;
                      controller.hasError.value = false;
                    },
                    containerColor: const Color(0xFFFFFFFF),
                    textColor: Colors.grey,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  if (controller.hasError.value)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          color: Colors.red,
                          size: 12,
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Text(
                          'Please select both country and city.',
                          style: TextStyle(color: Colors.red, fontSize: 10),
                        ),
                      ],
                    ),
                ],
              )),
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              CustomButton(
                laBelText: 'Signup',
                fontSize: 15,
                fontWeight: FontWeight.w600,
                fontFamily: 'Nunito-Sans',
                textColor: Colors.white,
                width: 150,
                height: 43,
                ontapp: () {
                  Get.to(() => SignupScreen());
                },
              ),
              CustomButton(
                laBelText: 'Explore',
                fontSize: 15,
                fontWeight: FontWeight.w600,
                fontFamily: 'Nunito-Sans',
                textColor: AppColors.primaryColor,
                containerColor: Colors.white,
                isBorder: true,
                borderColor: AppColors.primaryColor,
                width: 150,
                height: 43,
                ontapp: () {
                  if (controller.selectedCountry.value == 'Country' ||
                      controller.selectedCity.value == 'City') {
                    controller.hasError.value = true; // Show error
                  } else {
                    // Proceed with the next step
                    controller.hasError.value = false;
                    Get.to(
                      () => MyHomeScreen(
                        countryName: controller.selectedCity.value,
                      ),
                    );
                  }
                },
              ),
            ],
          ),
          const SizedBox(
            height: 100,
          )
        ],
      ),
    );
  }
}
