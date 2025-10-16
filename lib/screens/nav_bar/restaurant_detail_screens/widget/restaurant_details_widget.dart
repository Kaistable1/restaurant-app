import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kaistable_website/constants/app_colors.dart';
import 'package:kaistable_website/models/restaurant_model.dart';
import 'package:kaistable_website/screens/nav_bar/widgets/custom_button.dart';

import '../../../../widgets/claim_dialog.dart';

class MapDetailWidget extends StatelessWidget {
  MapDetailWidget({
    super.key,
    required this.restaurantModel,
    this.isCommingSoon,
  });

  bool? isCommingSoon;
  RestaurantModel restaurantModel;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 20,
          ),
          restaurantModel.address.isEmpty
              ? SizedBox()
              : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    'Address',
                    style: TextStyle(
                      color: AppColors.headingTextColor,
                      fontSize: 14,
                      fontFamily: 'Nunito-Regular',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 4,
              ),
              SizedBox(
                height: 40,
                width: 290,
                child: Text(
                  restaurantModel.address.isEmpty
                      ? "coming Soon!"
                      : restaurantModel.address +
                      ',${restaurantModel.city} ${restaurantModel
                          .zipCode},${restaurantModel.country}',
                  style: TextStyle(
                    color: AppColors.darkGrey,
                    fontSize: 14,
                    fontFamily: 'Nunito-Regular',
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ],
          ),
          restaurantModel.atmosphereList.isEmpty
              ? SizedBox()
              : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Atmospheres',
                style: TextStyle(
                  color: AppColors.headingTextColor,
                  fontSize: 14,
                  fontFamily: 'Nunito-Regular',
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              SizedBox(
                width: 325,
                child: restaurantModel.atmosphereList.isEmpty
                    ? Text("comming Soon!")
                    : _buildStarBox(
                  titleList: restaurantModel.atmosphereList,
                  context,
                ),
              ),
              SizedBox(
                height: 20,
              ),
            ],
          ),
          restaurantModel.facilityList.isEmpty
              ? SizedBox()
              : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Facilities/services',
                style: TextStyle(
                  color: AppColors.headingTextColor,
                  fontSize: 14,
                  fontFamily: 'Nunito-Regular',
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              SizedBox(
                width: 325,
                child: restaurantModel.facilityList.isEmpty
                    ? Text("comming Soon!")
                    : _buildStarBox(
                  titleList: restaurantModel.facilityList,
                  context,
                ),
              ),
              SizedBox(
                height: 20,
              ),
            ],
          ),
          restaurantModel.dietaryList.isEmpty
              ? SizedBox()
              : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Dietary Preferences',
                style: TextStyle(
                  color: AppColors.headingTextColor,
                  fontSize: 14,
                  fontFamily: 'Nunito-Regular',
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(
                height: 16,
              ),
              SizedBox(
                width: 325,
                child: restaurantModel.dietaryList.isEmpty
                    ? Text("comming Soon!")
                    : _buildStarBox(
                  titleList: restaurantModel.dietaryList,
                  context,
                ),
              ),
              SizedBox(
                height: 10,
              ),
            ],
          ),
          restaurantModel.entertainmentScheduleList.isEmpty
              ? SizedBox()
              : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Entertainment',
                style: TextStyle(
                  color: AppColors.headingTextColor,
                  fontSize: 14,
                  fontFamily: 'Nunito-Regular',
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              SizedBox(
                width: 325,
                child: restaurantModel.entertainmentScheduleList.isEmpty
                    ? Text("comming Soon!")
                    : _buildStarBox(
                  titleList: restaurantModel
                      .entertainmentScheduleList
                      .map((event) => event.eventName)
                      .toList(),
                  context,
                ),
              ),
              SizedBox(
                height: 10,
              ),
            ],
          ),
          restaurantModel.priceRange.isEmpty ||
              restaurantModel.priceRange == '\$\$'
              ? SizedBox()
              : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Price Range',
                style: TextStyle(
                  color: AppColors.headingTextColor,
                  fontSize: 14,
                  fontFamily: 'Nunito-Regular',
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              SizedBox(
                width: 325,
                child: restaurantModel.priceRange == '\$\$'
                    ? Text("comming Soon!")
                    : _buildStarBox(
                  titleList: ['${restaurantModel.priceRange}'],
                  context,
                ),
              ),
            ],
          ),
          restaurantModel.spokenLanguage.isEmpty
              ? SizedBox()
              : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Spoken language',
                style: TextStyle(
                  color: AppColors.headingTextColor,
                  fontSize: 14,
                  fontFamily: 'Nunito-Regular',
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              restaurantModel.spokenLanguage.isEmpty
                  ? Text("comming Soon!")
                  : _buildStarBox(
                titleList: [restaurantModel.spokenLanguage],
                context,
              ),
            ],
          ),
          isCommingSoon == true
              ? Column(
            children: [
              SizedBox(
                height: 20,
              ),
              CustomButton(
                laBelText: 'Claim your business',
                textColor: AppColors.whiteColor,
                fontSize: 16,
                ontapp: () {
                  showCustomDialog(context,
                      resaturant_model: restaurantModel);
                },
                fontWeight: FontWeight.bold,
              ),
            ],
          )
              : SizedBox(),
          SizedBox(
            height: 20,
          )
        ],
      ),
    );
  }

  Widget _buildStarBox(BuildContext context, {
    required List<String> titleList,
  }) {
    return Wrap(
      direction: Axis.horizontal,
      alignment: WrapAlignment.start,
      spacing: 4,
      // Horizontal spacing between items
      runSpacing: 8,
      // Vertical spacing between rows
      children: titleList
          .map((title) =>
          Container(
            padding: const EdgeInsets.symmetric(
                horizontal: 8, vertical: 4), // Add padding around the text
            decoration: BoxDecoration(
              color: AppColors.primaryColor.withOpacity(.5),
              borderRadius: BorderRadius.circular(32),
            ),
            child: Text(
              title,
              style: TextStyle(
                fontFamily: 'Nunito-Regular',
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: AppColors.textColor,
              ), // Adjust font size as needed
            ),
          ))
          .toList(),
    );
  }

}
