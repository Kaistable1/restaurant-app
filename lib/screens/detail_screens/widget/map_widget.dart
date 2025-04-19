import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:kaistable_website/constants/app_colors.dart';
import 'package:kaistable_website/models/resaturant_model.dart';
import 'package:kaistable_website/screens/detail_screens/controller/restaurant_detail_controller.dart';
import 'package:kaistable_website/screens/nav_bar/widgets/custom_button.dart';
import 'package:kaistable_website/utils/loading.dart';

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
  GoogleMapController? _controller;

  @override
  Widget build(BuildContext context) {
    print('isCommig ---- $isCommingSoon');
    return ClipRRect(
      borderRadius: BorderRadius.only(
          topRight: Radius.circular(10), topLeft: Radius.circular(10)),
      child: googleMap(),
    );
  }

  Future<void> _setMapStyle() async {
    String style = await rootBundle.loadString('assets/map_style.json');
    _controller?.setMapStyle(style);
  }

  void _zoomIn() {
    _controller?.getZoomLevel().then((zoom) {
      _controller?.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: LatLng(lat, long), zoom: zoom + 1),
      ));
    });
  }

  void _zoomOut() {
    _controller?.getZoomLevel().then((zoom) {
      _controller?.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: LatLng(lat, long), zoom: zoom - 1),
      ));
    });
  }

  GoogleMap googleMap() {
    return GoogleMap(
      markers: {
        Marker(
          markerId: MarkerId('Property location'),
          position: LatLng(lat, long),
        ),
      },
      mapType: MapType.terrain,
      initialCameraPosition: CameraPosition(
        target: LatLng(lat, long),
        zoom: 14.4746,
      ),
      onMapCreated: (GoogleMapController gController) {
        _controller = gController;
        _setMapStyle();
      },
    );
  }
}

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
              restaurantModel.address.isEmpty
                  ? "comming Soon!"
                  : restaurantModel.address,
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
                    titleList: restaurantModel.entertainmentScheduleList
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
            child: restaurantModel.priceRange == '\$\$'
                ? Text("comming Soon!")
                : _buildStarBox(
                    titleList: ['${restaurantModel.priceRange}'],
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
          restaurantModel.spokenLanguage.isEmpty
              ? Text("comming Soon!")
              : _buildStarBox(
                  titleList: [restaurantModel.spokenLanguage],
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

  void showCustomDialog(BuildContext context,
      {required RestaurantModel resaturant_model}) {
    TextEditingController nameController = TextEditingController();
    TextEditingController resNameController = TextEditingController();
    TextEditingController emailController = TextEditingController();
    TextEditingController messageController = TextEditingController();
    TextEditingController contactController = TextEditingController();

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
                Text("Your Name", style: _textStyle()), SizedBox(height: 10),
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
                // Email Field
                Text("Contact No.", style: _textStyle()), SizedBox(height: 10),
                TextField(
                  controller: contactController,
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
                      ontapp: () async {
                        if (nameController.text.isEmpty ||
                            emailController.text.isEmpty ||
                            messageController.text.isEmpty ||
                            contactController.text.isEmpty) {
                          Get.snackbar('SAVRLY', 'Please fill all fields');
                        } else {
                          try {
                            Navigator.pop(context);

                            // Get reference and auto-generate doc
                            final docRef = FirebaseFirestore.instance
                                .collection('businessClaims')
                                .doc();

                            // Prepare data
                            final data = {
                              'id': docRef.id,
                              'ownerName': nameController.text.trim(),
                              'contact': contactController.text.trim(),
                              'message': messageController.text.trim(),
                              'createdAt': FieldValue.serverTimestamp(),
                              'status': 'Pending',
                              'about': resaturant_model.about,
                              'address': resaturant_model.address,
                              'atmopshereList': resaturant_model
                                  .atmosphereList, // Empty array as per your data
                              'averageRating': resaturant_model.averageRating,
                              'city': resaturant_model.city,
                              'country': resaturant_model.country,
                              'dietaryList': [], // Empty array as per your data
                              'resID': resaturant_model
                                  .docID, // Will be set after adding the document
                              'entertainmentScheduleList': resaturant_model
                                  .entertainmentScheduleList, // Empty array as per your data
                              'facilityList': resaturant_model
                                  .facilityList, // Empty array as per your data
                              'resImages': resaturant_model.imagesList,
                              'latitude': resaturant_model
                                  .latitude, // Hardcoded for now; you can add a map picker later
                              'photoUrl': resaturant_model.logoImage,
                              'longitude': resaturant_model
                                  .longitude, // Hardcoded for now; you can add a map picker later
                              'menuList': [], // Empty array as per your data
                              'password': '',
                              'priceRange':
                                  '', // Hardcoded for now; you can add a field for this
                              'email': emailController.text.trim(),
                              'restaurantsName': resaturant_model.resName,
                              'InstagramLink': resaturant_model.instaLink,
                              'TiktokLink': resaturant_model.tiktokLink,
                              'specialConditions':
                                  resaturant_model.specialConditions,
                              'spokenLanguage': resaturant_model.spokenLanguage,
                            };

                            // Upload to Firestore
                            await docRef.set(data);

                            // Show success message
                            Get.snackbar(
                              'SAVRLY',
                              'Your claim submitted successfully!',
                              backgroundColor: Colors.green,
                              colorText: Colors.white,
                              maxWidth: 400,
                            );
                          } catch (e) {
                            print('Error submitting claim: $e');
                            Get.snackbar('Error',
                                'Something went wrong. Please try again later.');
                          }
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
