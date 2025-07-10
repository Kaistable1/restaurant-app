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

class MapDetailWidget extends StatefulWidget {
  final RestaurantModel restaurantModel;
  final bool? isCommingSoon;

  const MapDetailWidget({
    super.key,
    required this.restaurantModel,
    this.isCommingSoon,
  });

  @override
  State<MapDetailWidget> createState() => _MapDetailWidgetState();
}

class _MapDetailWidgetState extends State<MapDetailWidget> {
  bool _showFilters = false;

  List<String> _getAllFilters() {
    final model = widget.restaurantModel;

    return [
      ...(model.atmosphereList.isEmpty
          ? ['Outdoor Seating', 'Karaoke', 'Good for Kids']
          : model.atmosphereList),
      ...(model.facilityList.isEmpty
          ? ['Free Wifi', 'Free Parking', 'Delivery']
          : model.facilityList),
      ...(model.dietaryList.isEmpty
          ? ['Vegan Options', 'Gluten Free']
          : model.dietaryList),
      ...(model.entertainmentScheduleList.isEmpty
          ? ['Live Music', 'DJs', 'Games']
          : model.entertainmentScheduleList.map((e) => e.eventName)),
      ...(model.spokenLanguage.isEmpty ? ['English'] : [model.spokenLanguage]),
    ];
  }


  

  @override
  Widget build(BuildContext context) {
    final allFilters = _getAllFilters();

    return Padding(
      padding: const EdgeInsets.only(left: 15.0, right: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
        
          /// Filters Dropdown
          GestureDetector(
            onTap: () {
              setState(() {
                _showFilters = !_showFilters;
              });
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Filters',
                  style: TextStyle(
                    color: AppColors.headingTextColor,
                    fontSize: 18,
                    fontFamily: 'Nunito-Regular',
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Icon(
                  _showFilters
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                  color: AppColors.primaryColor,
                ),
              ],
            ),
          ),

        //  if (_showFilters) const SizedBox(height: 10),

        //   Chips Dropdown List

          if (_showFilters)
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: allFilters
                  .map((filter) => Chip(
                        label: Text(
                          filter,
                        ),
                        backgroundColor: Colors.grey.shade200,
                        shape: StadiumBorder(
                          side: BorderSide(
                            color: AppColors.primaryColor,
                            width: 1.2,
                          ),
                        ),
                      ))
                  .toList(),
            ),

       
          const SizedBox(height: 20),

          widget.isCommingSoon == true
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
                            resaturant_model: widget.restaurantModel);
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
            child: SingleChildScrollView(
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
                                'socialLink': resaturant_model.instaLink,
                                'socialMedia': resaturant_model.tiktokLink,
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

class ExpandableAddressTile extends StatefulWidget {
  final String address;
  final String city;
  final String zipCode;
  final String country;
  final String email;
  final String? phone;
  final String? website;

  const ExpandableAddressTile({
    Key? key,
    required this.address,
    required this.city,
    required this.zipCode,
    required this.country,
    required this.email,
    this.phone,
    this.website,
  }) : super(key: key);

  @override
  State<ExpandableAddressTile> createState() => _ExpandableAddressTileState();
}

class _ExpandableAddressTileState extends State<ExpandableAddressTile> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final fullAddress = widget.address.isEmpty
        ? 'Coming Soon!'
        : '${widget.address}, ${widget.city}, ${widget.zipCode}, ${widget.country}';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Top row (icon + Address + arrow)
        InkWell(
          onTap: () => setState(() => isExpanded = !isExpanded),
          child: Padding(
            padding: const EdgeInsets.only(right: 15),
            child: Row(
              children: [
                const Icon(Icons.location_on, color: Colors.teal),
                const SizedBox(width: 8),
                const Text(
                  'Address',
                  style: TextStyle(
                    color: AppColors.headingTextColor,
                    fontSize: 14,
                    fontFamily: 'Nunito-Regular',
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const Spacer(),
                Icon(
                  isExpanded
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                  color: Colors.teal,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 4),

        // Address line (aligned)
        Padding(
          padding: const EdgeInsets.only(left: 32),
          child: Text(
            fullAddress,
            style: const TextStyle(color: Colors.grey),
          ),
        ),

        // Extra content when expanded
        if (isExpanded) ...[
          const SizedBox(height: 12),
          // Email Row
          Padding(
            padding: const EdgeInsets.only(left: 5),
            child: Row(
              children: [
                const Icon(Icons.email, color: Colors.teal, size: 20),
                const SizedBox(width: 10),
                const Text('Email',
                    style: TextStyle(
                      color: AppColors.headingTextColor,
                      fontSize: 14,
                      fontFamily: 'Nunito-Regular',
                      fontWeight: FontWeight.w700,
                    )),
              ],
            ),
          ),
          const SizedBox(height: 4),
          Padding(
            padding: const EdgeInsets.only(left: 32),
            child:
                Text(widget.email, style: const TextStyle(color: Colors.grey)),
          ),

          // Phone Row
        ]
      ],
    );
  }
}
