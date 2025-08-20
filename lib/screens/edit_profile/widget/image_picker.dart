import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../constants/app_colors.dart';

void pickImageBottomSheet(
    void Function() onCameraPressed, void Function() onGalleryPressed) {
  Get.bottomSheet(
    BottomSheet(
      constraints: BoxConstraints(
        maxHeight: 200,
        minWidth: Get.width,
      ),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      onClosing: () {},
      builder: (context) {
        return Column(
          children: [
            IconButton(
              onPressed: () {
                Get.back();
              },
              icon: const Icon(
                Icons.arrow_drop_down_outlined,
                color: AppColors.primaryColor,
                size: 35,
              ),
            ),
            ImageSelectWidget(
              name: 'Take picture',
              imageIcon: 'assets/images/camera_icon.png',
              onTap: onCameraPressed,
            ),
            SizedBox(
              height: 16,
            ),
            ImageSelectWidget(
              name: 'Choose from gallery',
              imageIcon: 'assets/images/choosefrom_gallery.png',
              onTap: onGalleryPressed,
            ),
          ],
        );
      },
    ),
  );
}

class ImageSelectWidget extends StatelessWidget {
  final String name;
  final String imageIcon;
  final void Function()? onTap;

  const ImageSelectWidget({
    super.key,
    required this.name,
    this.onTap,
    required this.imageIcon,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 46,
        width: Get.width,
        margin: EdgeInsets.symmetric(horizontal: 24),
        padding: EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: AppColors.hintText.withOpacity(0.4),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Row(
          children: [
            Image.asset(
              imageIcon,
              height: 19,
              width: 24,
              fit: BoxFit.fill,
              color: AppColors.primaryColor,
            ),
            SizedBox(
              width: 8,
            ),
            Text(
              name,
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Nunito-Sans'),
            ),
          ],
        ),
      ),
    );
  }
}
