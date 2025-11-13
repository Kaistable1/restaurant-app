import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kaistable_website/widgets/custom_button.dart';
import '../constants/app_colors.dart';

loadingDialog(
    {String? message,
    String? endBtnText,
    double? padding,
    Color? clr,
    bool loading = false,
    bool button = false,
    bool top = false,
    button1 = false,
    VoidCallback? tap,
    double? height,
    Widget? topWidget,
    bool? isWrongPassword = false,
    bool? isFromForgotPassword = false,
    Widget? startWidget}) {
  showDialog(
    barrierDismissible: false,
    context: Get.context!,
    builder: (BuildContext context) {
      return AnimatedContainer(
        duration: Duration(seconds: 2),
        child: Padding(
          padding: EdgeInsets.only(top: 40.0),
          child: Dialog(
            alignment: Alignment.center,
            backgroundColor: Colors.white,
            insetPadding: EdgeInsets.symmetric(horizontal: 15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Container(
              height: height ?? 254,
              width: 100,
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(20)),
              child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 18.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      loading
                          ? Padding(
                              padding: EdgeInsets.only(top: 10),
                              child: CircularProgressIndicator(
                                color: AppColors.primaryColor,
                              ),
                            )
                          : top == true
                              ? topWidget!
                              : SizedBox(),
                      //  SizedBox(
                      //   height: padding ?? 20,
                      // ),
                      isWrongPassword == true
                          ? Icon(
                              Icons.lock,
                              size: 50,
                              color: AppColors.primaryColor,
                            )
                          : Text(''),

                      // SizedBox(
                      //   height: 20,
                      // ),

                      Center(
                        child: Text(
                          textAlign: TextAlign.center,
                          message.toString(),
                          style: TextStyle(
                            color: AppColors.darkGrey,
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      button
                          ? Padding(
                              padding: EdgeInsets.only(top: 20.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  button1 ? startWidget! : SizedBox(),
                                  button
                                      ? CustomButton(
                                          laBelText: endBtnText ?? "Okay",
                                          height: 40,
                                          width: 166,
                                          ontapp: tap ??
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
                                      : SizedBox()
                                ],
                              ),
                            )
                          : SizedBox(),

                      SizedBox(
                        height: 10,
                      )
                    ],
                  )),
            ),
          ),
        ),
      );
    },
  );
}
