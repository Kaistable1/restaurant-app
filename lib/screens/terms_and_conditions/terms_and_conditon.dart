import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:savrly/constants/app_colors.dart';
import 'package:savrly/constants/text_styles.dart';
import 'package:savrly/widgets/button.dart';

import '../../controllers/terms_controller.dart';


class TermsAndConditions extends StatelessWidget {
  final TermsController controller = Get.put(TermsController());

  TermsAndConditions({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    bool isMobile = size.width < 600;
    double screenWidth = MediaQuery.of(context).size.width;
    bool isLargeScreen = screenWidth > 1600;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Column(
        children: [
          SizedBox(height: isMobile ? 10 : 26),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Terms and conditions',
                  style: headingText.copyWith(fontSize: isMobile ? 22 : 34),
                ),
                CustomButton(
                  ontapp: () {
                    addTermsAndConditions();
                  },
                  laBelText: 'Edit terms and conditions',
                  isPrefixIcon: true,
                  iconWidget: Icon(
                    Icons.edit_outlined,
                    color: Colors.white,
                    size: isMobile ? 14 : 24,
                  ),
                  width: isMobile ? 160 : 234,
                  height: isMobile ? 32 : 48,
                  fontSize: isMobile ? 10 : 16,
                ),
              ],
            ),
          ),
          SizedBox(height: isMobile ? 16 : 32),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Obx(
                  () => controller.isLoading.value
                  ? const Center(child: CircularProgressIndicator())
                  : Text(
                controller.terms.value.text,
                style: simpleText.copyWith(
                    fontSize: isLargeScreen
                        ? 22
                        : isMobile
                        ? 12
                        : 16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Future<bool> addTermsAndConditions() async {
  bool res = false;
  final TermsController controller = Get.find<TermsController>();
  final TextEditingController textEditingController =
  TextEditingController(text: controller.terms.value.text);

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
              color: white,
              border: Border.all(color: primaryColor),
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
                            "Terms and conditions",
                            style: TextStyle(
                              fontSize: isLargeScreen ? 26 : 20,
                              fontWeight: FontWeight.bold,
                            ), // Replaced headingText due to import issue
                          ),
                          const Spacer(),
                          InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: const Icon(
                              Icons.cancel_outlined,
                              color: backgroundBlack,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 44),
                    TextField(
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                        color: secondaryColor,
                        fontFamily: 'regular',
                      ),
                      controller: textEditingController,
                      maxLines: 10,
                      decoration: const InputDecoration(
                        hintText: "Enter your terms and conditions text...",
                        hintStyle: TextStyle(
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
                          await controller.updateTermsText(
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
