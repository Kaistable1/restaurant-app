import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:savrly/constants/app_colors.dart';
import 'package:savrly/constants/text_styles.dart';
import 'package:savrly/widgets/button.dart';

import '../../controllers/about_app_controller.dart';
import '../../widgets/customheader_widget.dart';

class AboutApp extends StatelessWidget {
  final AboutAppController controller = Get.put(AboutAppController());

  AboutApp({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    bool mobileView = size.width < 1000;
    double screenWidth = MediaQuery.of(context).size.width;
    bool isLargeScreen = screenWidth > 1600;
    double paddingValue = mobileView ? 16 : 24;

    return Padding(
      padding: EdgeInsets.all(paddingValue),
      child: Column(
        children: [
          CustomHeaderWidget(
            title: 'About app',
            end: true,
            endWidget: CustomButton(
              ontapp: () {
                addAbout();
              },
              laBelText: 'Edit about',
              isPrefixIcon: true,
              iconWidget: Icon(
                Icons.edit_outlined,
                color: Colors.white,
                size: mobileView ? 14 : 24,
              ),
              width: mobileView ? 160 : 234,
              height: mobileView ? 32 : 48,
              fontSize: mobileView ? 12 : 16,
            ),
          ),
          SizedBox(height: mobileView ? 16 : 32),
          Obx(
                () => controller.isLoading.value
                ? const Center(child: CircularProgressIndicator())
                : Text(
              controller.aboutApp.value.text, // Use model field
              style: TextStyle( // Replaced simpleText
                fontSize: isLargeScreen
                    ? 22
                    : mobileView
                    ? 12
                    : 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Future<bool> addAbout() async {
  bool res = false;
  final AboutAppController controller = Get.find<AboutAppController>();
  final TextEditingController textEditingController =
  TextEditingController(text: controller.aboutApp.value.text);

  await showDialog(
    barrierDismissible: true,
    context: Get.context!,
    builder: (BuildContext context) {
      double screenWidth = MediaQuery.of(context).size.width;
      bool isLargeScreen = screenWidth > 1600;

      return Dialog(
        backgroundColor: Colors.white,
        alignment: AlignmentDirectional.center,
        insetPadding: const EdgeInsets.symmetric(horizontal: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
          child: Container(
            width: isLargeScreen ? 790 : 730,
            height: isLargeScreen ? 650 : 500,
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.white.withOpacity(0.5),
                  blurRadius: 10,
                  spreadRadius: 2,
                  offset: const Offset(0, 4),
                ),
              ],
              color: Colors.white,
              border: Border.all(color: primaryColor), // Replace with primaryColor
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 46, vertical: 34),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: Row(
                        children: [
                          const Spacer(),
                          Text(
                            "About app",
                            style:  headingText.copyWith(
                              fontSize: isLargeScreen ? 26 : 20,
                            ),
                          ),
                          const Spacer(),
                          InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: const Icon(
                              Icons.cancel_outlined,
                              color: Colors.black, // Replace with backgroundBlack
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 44),
                    TextField(
                      style: simpleText.copyWith(
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                        color: secondaryColor,
                        fontFamily: 'regular',
                      ),
                      controller: textEditingController,
                      maxLines: 10,
                      decoration:  InputDecoration(
                        hintText: "Enter your about app text...",
                        hintStyle: simpleText.copyWith(
                          fontWeight: FontWeight.w500,
                          fontSize: 20,
                          color: secondaryColor,
                        ),
                        border: InputBorder.none,
                      ),
                    ),
                    SizedBox(height: isLargeScreen ? 150 : 60),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: CustomButton(
                        width: 200,
                        height: 40,
                        laBelText: 'Update',
                        ontapp: () async {
                          await controller.updateAboutAppText(
                              textEditingController.text);
                          Navigator.of(context).pop();
                          res = true;
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    },
  );

  return res;
}
