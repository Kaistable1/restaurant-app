import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurant_web_app/widgets/round_button.dart';

import '../../../constants/colors.dart';

class CustomDialogBox extends StatelessWidget {
  final double width;
  final double height;
  final String title;
  final String description;
  final VoidCallback onConfirm;

  const CustomDialogBox({
    Key? key,
    required this.width,
    required this.height,
    required this.title,
    required this.description,
    required this.onConfirm,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.primaryColor,width: 2)
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              description,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16,fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomButton(
                  onPressed: (){
                    Get.back();
                  },
                  height: 38,
                  width: 90,
                  title: "Cancel",
                  borderClr: AppColors.primaryColor,
                  borderRadius: 8,
                  backgroundColor: AppColors.whiteColor,
                  textStyle: TextStyle(
                      color: AppColors.primaryColor,fontSize: 16
                  ),

                ),
                SizedBox(width: 30,),
                CustomButton(
                  onPressed:onConfirm,
                  height: 38,
                  width: 90,
                  title: "Logout",
                  borderClr: AppColors.primaryColor,
                  borderRadius: 8,
                  backgroundColor: AppColors.primaryColor,
                  textStyle: TextStyle(
                      color: AppColors.whiteColor,fontSize: 16
                  ),

                ),


              ],
            ),
          ],
        ),
      ),
    );
  }
}
