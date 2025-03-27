import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:kaistable_website/constants/app_colors.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: AppBar(
        backgroundColor: AppColors.bgColor,
        iconTheme: const IconThemeData(
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
              child: Icon(Icons.arrow_back,
                  size: 18, color: AppColors.primaryColor),
            ),
          ),
        ),
        title: const Text(
          'Notifications',
          style: TextStyle(
            fontSize: 17,
            color: AppColors.bottomSheetColor,
            fontWeight: FontWeight.w700,
            fontFamily: 'Nunito-Bold',
          ),
        ),
      ),
      body:Column(
        mainAxisAlignment: MainAxisAlignment.center,

        children: [
          SizedBox(height: 10,),
          Center(
            child: Text('No notifications yet. Check back later!',
              style: TextStyle(
                  color: AppColors.bottomSheetColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Nunito-Bold'
              ),
            ),
          )
        ],
      ) ,
    );
  }
}
