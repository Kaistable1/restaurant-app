import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurant_web_app/widgets/round_button.dart';

import '../constants/colors.dart';

loadingDialog(
    {String? message,
    String? endBtnText,
    double? padding,
    Color? clr,
    bool loading = false,
    bool button = false,
    button1 = false,
    VoidCallback? tap,
    bool? isFromForgotPassword = false,
    Widget? startWidget}) {
  showDialog(
    barrierDismissible: false,
    context: Get.context!,
    builder: (context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: Colors.white,
        elevation: 1,
        actions: [
          Center(
            child: Padding(
                padding: const EdgeInsets.all(7.0),
                child: Column(
                  children: [
                    loading
                        ? const Padding(
                            padding: EdgeInsets.only(top: 20),
                            child: CircularProgressIndicator(
                              color: AppColors.darkGrey,
                            ),
                          )
                        : const SizedBox(),
                    const SizedBox(
                      height: 20,
                    ),
                    Center(
                      child: Text(
                        textAlign: TextAlign.center,
                        message.toString(),
                        style:const TextStyle(
                          color: Color(0xFF2B2B2B),
                          fontSize: 14,
                          fontFamily: 'Avenir',
                          fontWeight: FontWeight.w600,
                          // letterSpacing: -0.32,
                        ),
                      ),
                    ),
                    // const SizedBox(
                    //   height: 20,
                    // ),
                    button
                        ? Padding(
                            padding: const EdgeInsets.only(top: 20.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                button1 ? startWidget! : const SizedBox(),
                                button
                                    ? CustomButton(
                                        title: endBtnText ?? "Okay",
                                        height: 40,
                                        width: 80,fontSize: 16,
                                        onPressed: tap ??
                                            () {
                                              if (isFromForgotPassword ==
                                                  true) {
                                                Get.back();
                                                Get.back();
                                              } else {
                                                Get.back();
                                              }
                                            },
                                      )
                                    : const SizedBox()
                              ],
                            ),
                          )
                        : const SizedBox()
                  ],
                )),
          )
        ],
      );
    },
  );
}


void customAlertDialog2(
    String title,
    String content,
    ) {
  showDialog(
    context: Get.context!,
    builder: (BuildContext context) {
      return BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: AlertDialog(
          backgroundColor: Colors.purple.withOpacity(0.7),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          actionsAlignment: MainAxisAlignment.center,
          title: Container(
            padding: const EdgeInsets.all(15),
            decoration: const BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10.0),
                topRight: Radius.circular(10.0),
              ),
            ),
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                fontFamily: 'sans-serif',
                color: Colors.white,
              ),
            ),
          ),
          titlePadding: EdgeInsets.zero,
          content: Text(
            content,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              fontFamily: 'sans-serif',
              color: Colors.white,
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: CustomButton(
                onPressed: () {
                  Get.back();
                },
                title: 'Ok',
                // textColor: white,
                // backgroundColor: blueColor,
                // borderColor: blueColor,
                width: 147,
                height: 28,
                // borderRadius: 4,
                fontSize: 12,
              ),
            ),
          ],
        ),
      );
    },
  );
}