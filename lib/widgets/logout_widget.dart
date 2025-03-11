import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:savrly_data_entry_app/constants/text_styles.dart';

import '../screens/auth/login/login_screen.dart';
import 'custom_button.dart';

Widget logoutBottomSheet(
  BuildContext context,
) {
  Size size = MediaQuery.of(context).size;
  return BackdropFilter(
    filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
    child: Container(
      width: double.infinity,
      height: size.height * 0.241,
      margin: const EdgeInsets.symmetric(horizontal: 10),
      decoration: const BoxDecoration(
        color: Colors.transparent,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            // height: 75,
            width: Get.width,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 12.0, bottom: 9),
                  child: Text(
                    "Are you sure you want to logout?",
                    style: subHeadingText,
                  ),
                ),
                Container(
                  width: Get.width,
                  height: 0.8,
                  decoration: BoxDecoration(color: Color(0xFFDDDCD9)),
                ),
                GestureDetector(
                  onTap: () async {
                    await FirebaseAuth.instance.signOut();
                    Get.offAll(LoginScreen());
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 9, top: 9),
                    child: Text(
                      "Yes",
                      style: hintText,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 4,
          ),
          CustomButton(
            onTap: () {
              Navigator.pop(context);
            },
            height: 42,
            btnText: 'Cancel',
            width: Get.width,
          ),
          const SizedBox(height: 10),
        ],
      ),
    ),
  );
}
