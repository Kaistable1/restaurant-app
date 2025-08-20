import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kaistable_website/constants/app_colors.dart';
import '../widgets/custom_button.dart';

void dialogueBox({
  required String text,
  required void Function() onPressed,
  String? labelText,
  String? image,
  double? imgwidth,
  double? imgheight,
  Color? color,
}) {
  showDialog(
    context: Get.context!,
    builder: (context) {
      return BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          insetPadding: const EdgeInsets.symmetric(horizontal: 16),
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.only(
                  top: 16.0, bottom: 16, right: 20, left: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 12),
                  Image.asset(
                    image ?? 'assets/images/reset_image.png',
                    width: imgwidth ?? 48,
                    height: imgheight ?? 48,
                    fit: BoxFit.fill,
                    color: color,
                  ),
                  const SizedBox(
                    height: 19,
                  ),
                  Center(
                    child: Text(text,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Nunito-Sans',
                          color: AppColors.headingTextColor,
                          fontSize: 16,
                        )),
                  ),
                  const SizedBox(height: 36),
                  Center(
                    child: CustomButton(
                      width: 180,
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Nunito-Regular',
                      textColor: Colors.white,
                      ontapp: onPressed,
                      laBelText: labelText ?? 'Ok',
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ),
      );
    },
  );
}
