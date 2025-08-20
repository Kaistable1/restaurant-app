import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kaistable_website/constants/app_colors.dart';
import 'package:kaistable_website/screens/app_info/controller.dart';

class PrivacyPolicy extends StatelessWidget {
  final Function(int)? onNavigate;
  const PrivacyPolicy({super.key, this.onNavigate});

  @override
  Widget build(BuildContext context) {
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
          iconTheme: const IconThemeData(
            color: AppColors.primaryColor,
          ),
          centerTitle: true,
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
          title: const Text(
            'Privacy policy',
            style: TextStyle(
              fontSize: 17,
              color: AppColors.bottomSheetColor,
              fontWeight: FontWeight.w700,
              fontFamily: 'Nunito-Bold',
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 16, top: 2),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                Obx(() => Text(
                      controller.privacyPolicyText.value.isNotEmpty
                          ? controller.privacyPolicyText.value
                          : 'Loading privacy policy...',
                      textAlign: TextAlign.justify,
                      style: const TextStyle(
                        fontSize: 16,
                        fontFamily: "Nunito-Regular",
                        color: Color(0xFF656D7B),
                        fontWeight: FontWeight.w400,
                      ),
                    )),
                const SizedBox(height: 2),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
