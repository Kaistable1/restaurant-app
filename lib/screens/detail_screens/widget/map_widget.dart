import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:kaistable_website/constants/app_colors.dart';
import 'package:kaistable_website/models/resaturant_model.dart';
import 'package:kaistable_website/screens/detail_screens/controller/restaurant_detail_controller.dart';
import 'package:kaistable_website/screens/nav_bar/widgets/custom_button.dart';

class MapWidget extends StatelessWidget {
  MapWidget({
    super.key,
    required this.controller,
    required this.lat,
    required this.long,
    this.isCommingSoon,
  });
  bool? isCommingSoon;
  double lat, long;
  final RestaurantDetailController controller;

  @override
  Widget build(BuildContext context) {
    print('lat----$lat    long-----$long');
    return ClipRRect(
      borderRadius: BorderRadius.only(
          topRight: Radius.circular(10), topLeft: Radius.circular(10)),
      child: GoogleMap(
        markers: {
          Marker(
            markerId: MarkerId('Property location'),
            position: LatLng(lat, long),
          ),
        },
        mapType: MapType.normal,
        initialCameraPosition: CameraPosition(
          target: LatLng(lat, long),
          zoom: 14.4746,
        ),
        // ListPropertyController.kGooglePlex,
        onMapCreated: (GoogleMapController gController) {
          // controller.completer.complete(gController);
        },
      ),
    );
  }
}

class MapDetailWidget extends StatelessWidget {
  MapDetailWidget({
    super.key,
    required this.address,
    required this.atmospher,
    required this.dietaryList,
    required this.entertainmentList,
    required this.facilitiesList,
    required this.priceRange,
    required this.spokenLanguage,
    this.isCommingSoon,
  });
  bool? isCommingSoon;
  String address;
  List<String> atmospher = [];
  List<String> facilitiesList = [];
  List<String> dietaryList = [];
  List<EntertainmentScheduleModel> entertainmentList = [];
  String priceRange;
  String spokenLanguage;
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
          Row(
            children: [
              Text(
                'Area',
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
              address.isEmpty ? "comming Soon!" : address,
              style: TextStyle(
                color: AppColors.darkGrey,
                fontSize: 14,
                fontFamily: 'Nunito-Regular',
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
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
            child: atmospher.isEmpty
                ? Text("comming Soon!")
                : _buildStarBox(
                    titleList: atmospher,
                    context,
                  ),
          ),
          SizedBox(
            height: 20,
          ),
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
            child: facilitiesList.isEmpty
                ? Text("comming Soon!")
                : _buildStarBox(
                    titleList: facilitiesList,
                    context,
                  ),
          ),
          SizedBox(
            height: 20,
          ),
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
            child: dietaryList.isEmpty
                ? Text("comming Soon!")
                : _buildStarBox(
                    titleList: dietaryList,
                    context,
                  ),
          ),
          SizedBox(
            height: 10,
          ),
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
            child: entertainmentList.isEmpty
                ? Text("comming Soon!")
                : _buildStarBox(
                    titleList: entertainmentList
                        .map((event) => event.eventName)
                        .toList(),
                    context,
                  ),
          ),
          SizedBox(
            height: 10,
          ),
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
            child: priceRange == '\$\$'
                ? Text("comming Soon!")
                : _buildStarBox(
                    titleList: ['${priceRange}'],
                    context,
                  ),
          ),
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
          spokenLanguage.isEmpty
              ? Text("comming Soon!")
              : _buildStarBox(
                  titleList: [spokenLanguage],
                  context,
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
                        showCustomDialog(context);
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

  Widget _buildStarBox(
    BuildContext context, {
    required List<String> titleList,
  }) {
    return Wrap(
      direction: Axis.horizontal,
      alignment: WrapAlignment.start,
      spacing: 4, // Horizontal spacing between items
      runSpacing: 8, // Vertical spacing between rows
      children: titleList
          .map((title) => Container(
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

  void showCustomDialog(BuildContext context) {
    TextEditingController nameController = TextEditingController();
    TextEditingController emailController = TextEditingController();
    TextEditingController messageController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Dialog Title
                Center(
                  child: Text(
                    "Claim your business",
                    style: TextStyle(
                      fontFamily: 'Nunito-Regular',
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textColor,
                    ),
                  ),
                ),
                SizedBox(height: 15),

                // Name Field
                Text("Name", style: _textStyle()), SizedBox(height: 10),
                TextField(
                  controller: nameController,
                  decoration: _inputDecoration("Enter your name"),
                ),
                SizedBox(height: 10),

                // Email Field
                Text("Email", style: _textStyle()), SizedBox(height: 10),
                TextField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: _inputDecoration("Enter your email"),
                ),
                SizedBox(height: 10),

                // Message Field
                Text("Message", style: _textStyle()), SizedBox(height: 10),
                TextField(
                  controller: messageController,
                  maxLines: 3,
                  decoration: _inputDecoration("Enter your message"),
                ),
                SizedBox(height: 20),

                // Buttons Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Cancel Button
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        "Cancel",
                        style: TextStyle(
                          fontFamily: 'Nunito-Regular',
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                      ),
                    ),

                    // Submit Button (Same as your UI)
                    CustomButton(
                      laBelText: 'Submit',
                      textColor: AppColors.whiteColor,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      width: Get.width * 0.3,
                      height: 40,
                      ontapp: () {
                        if (nameController.text.isEmpty ||
                            emailController.text.isEmpty ||
                            messageController.text.isEmpty) {
                          Get.snackbar('SAVRLY', 'Please fill all fields');
                        } else {
                          Navigator.pop(context);
                          Get.snackbar('SAVRLY', 'Message sent successfully!');
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

// Common TextStyle for Labels
  TextStyle _textStyle() {
    return TextStyle(
      fontFamily: 'Nunito-Regular',
      fontSize: 12,
      fontWeight: FontWeight.w400,
      color: AppColors.textColor,
    );
  }

// Common InputDecoration for TextFields
  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: _textStyle(),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
    );
  }
}
