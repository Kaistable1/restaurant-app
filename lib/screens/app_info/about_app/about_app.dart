import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurant_web_app/constants/colors.dart';
import 'package:restaurant_web_app/screens/app_info/controller.dart';

class AboutApp extends StatelessWidget {
  final Function(int)? onNavigate;
  const AboutApp({super.key, this.onNavigate});

  @override
  Widget build(BuildContext context) {
    // Initialize the controller
    final AppInfoController controller = Get.put(AppInfoController());

    return WillPopScope(
      onWillPop: () async {
        Get.back();
        return false;
      },
      child: Scaffold(
        backgroundColor: AppColors.bgColor,
        appBar: AppBar(
          backgroundColor: AppColors.bgColor,
          iconTheme: IconThemeData(
            color: AppColors.botomSheetColor,
          ),
          centerTitle: true,
          automaticallyImplyLeading: true,
          title: const Text(
            'About app',
            style: TextStyle(
              fontSize: 17,
              color: AppColors.botomSheetColor,
              fontWeight: FontWeight.w700,
              fontFamily: 'Nunito-Bold',
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 16, top: 2),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                // About Section
                Obx(() => Text(
                      controller.aboutText.value.isNotEmpty
                          ? controller.aboutText.value
                          : 'Loading about information...',
                      textAlign: TextAlign.justify,
                      style: const TextStyle(
                        fontSize: 16,
                        fontFamily: "Nunito-Regular",
                        color: Color(0xFF656D7B),
                        fontWeight: FontWeight.w400,
                      ),
                    )),
                const SizedBox(height: 20),
                // Privacy Policy Section
                const Text(
                  'Privacy Policy',
                  style: TextStyle(
                    fontFamily: 'aftika-regular',
                    fontWeight: FontWeight.w400,
                    fontSize: 16,
                    color: AppColors.blackColor,
                  ),
                ),
                const SizedBox(height: 10),
                Obx(() => Text(
                      controller.privacyPolicyText.value.isNotEmpty
                          ? controller.privacyPolicyText.value
                          : 'Loading privacy policy...',
                      textAlign: TextAlign.justify,
                      style: const TextStyle(
                        fontFamily: 'Nunito-Regular',
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: AppColors.textColor,
                      ),
                    )),
                const SizedBox(height: 20),
                // Terms and Conditions Section
                const Text(
                  'Terms and Conditions',
                  style: TextStyle(
                    fontFamily: 'aftika-regular',
                    fontWeight: FontWeight.w400,
                    fontSize: 16,
                    color: AppColors.blackColor,
                  ),
                ),
                const SizedBox(height: 10),
                Obx(() => Text(
                      controller.termsAndConditionsText.value.isNotEmpty
                          ? controller.termsAndConditionsText.value
                          : 'Loading terms and conditions...',
                      textAlign: TextAlign.justify,
                      style: const TextStyle(
                        fontFamily: 'Nunito-Regular',
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: AppColors.textColor,
                      ),
                    )),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
