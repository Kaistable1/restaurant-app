import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kaistable_website/constants/app_colors.dart';
import 'package:kaistable_website/screens/change_pass/changePassword_dialoge.dart';
import 'package:kaistable_website/screens/home_screen/home_controller/home_location_controller.dart';

class LocationStarWidget extends StatefulWidget {
  final String timeText1;
  final String timeText2;
  final String percentageText;
  final int index;
  final String menuType;
  const LocationStarWidget(
      {super.key,
      required this.timeText1,
      required this.percentageText,
      required this.menuType,
      required this.timeText2,
      required this.index});

  @override
  _LocationStarWidgetState createState() => _LocationStarWidgetState();
}

class _LocationStarWidgetState extends State<LocationStarWidget> {
  HomeLocationController homeLocationController =
      Get.put(HomeLocationController());

  void _toggleTapped() {
    if (widget.menuType == 'PercentageOff' &&
        homeLocationController.selectedPersentage.isNotEmpty) {
      // Reset all values to false
      homeLocationController.selectedPersentage.fillRange(
          0, homeLocationController.selectedPersentage.length, false);
      // Set the clicked index to the opposite value (_isTapped toggles between true and false)
      homeLocationController.selectedPersentage[widget.index] =
          !homeLocationController.selectedPersentage[widget.index];
    }
    if (widget.menuType == 'HappyHour' &&
        homeLocationController.selectedHappyhour.isNotEmpty) {
      // Reset all values to false
      homeLocationController.selectedHappyhour
          .fillRange(0, homeLocationController.selectedHappyhour.length, false);
      // Set the clicked index to the opposite value (_isTapped toggles between true and false)
      homeLocationController.selectedHappyhour[widget.index] =
          !homeLocationController.selectedHappyhour[widget.index];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      bool isToggle = widget.menuType == 'HappyHour'
          ? homeLocationController.selectedHappyhour.isEmpty
              ? false
              : homeLocationController.selectedHappyhour[widget.index]
          : homeLocationController.selectedPersentage.isEmpty
              ? false
              : homeLocationController.selectedPersentage[widget.index];
      final String imagePath = isToggle == true
          ? 'assets/images/star_img.png'
          : 'assets/images/star_img2.png';
      final Color textColor =
          isToggle == true ? AppColors.whiteColor : AppColors.blackColor;

      return InkWell(
        onTap: _toggleTapped,
        child: Container(
          height: 200,
          width: 85,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(imagePath),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                '${widget.timeText1} to',
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 11,
                    color: textColor,
                    fontFamily: 'Nunito-Regular'),
                textAlign: TextAlign.center,
              ),
              Text(
                widget.timeText2,
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 11,
                    color: textColor,
                    fontFamily: 'Nunito-Regular'),
                textAlign: TextAlign.center,
              ),
              Text(
                '${widget.percentageText} off',
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 11,
                    color: textColor,
                    fontFamily: 'Nunito-Regular'),
              ),
            ],
          ),
        ),
      );
    });
  }
}
