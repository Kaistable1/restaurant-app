import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kaistable_website/constants/app_colors.dart';
import 'package:kaistable_website/main.dart';
import 'package:kaistable_website/models/recent_view.dart';
import 'package:kaistable_website/models/resaturant_model.dart';
import 'package:kaistable_website/models/review_model.dart';
import 'package:kaistable_website/utils/loading.dart';
import 'package:kaistable_website/widgets/global_functions.dart';
import '../model/home-model.dart';
// Import your model

class HomeLocationController extends GetxController {
  RxList selectedPersentage = [].obs;
  RxList selectedHappyhour = [].obs;
  @override
  void onInit() {
    super.onInit();
    // Ensure the list is cleared before adding false values
    selectedPersentage.clear();

    // Use forEach to add 'false' for each item in restaurant_list
    resaturant_list.forEach((v) {
      for (var x in v.menuList.percentageOff) {
        selectedPersentage.add(false);
      }
      for (var x in v.menuList.happyHourSpecials) {
        selectedHappyhour.add(false);
      }
    });
    if (selectedHappyhour.isNotEmpty) {
      selectedHappyhour[0] = true;
    }
    if (selectedPersentage.isNotEmpty) {
      selectedPersentage[0] = true;
    }
    print('selectedPersentage: $selectedPersentage');
    print('selectedHappyhour: $selectedHappyhour');
  }

  final searchController = TextEditingController();
  // ScrollController to control the ListView scroll position
  ScrollController scrollController = ScrollController();
  var selectedLetter = ''.obs; // Observable variable to store selected index
  List top = [
    'Most Reviewed',
    'Discount',
    'Dining',
  ];
  RxString selectedTop = ''.obs;
  var selectedDiscount = '10%'.obs;
  // Define the selectIndex methodi

  // List of CircleContainerModel objects
  final List<CircleContainerModel> circleItems = [
    CircleContainerModel(
      imgPath: 'assets/images/location_img1.png',
      titleText: 'Time Square',
      descriptionText: '14 restaurants',
    ),
    CircleContainerModel(
      imgPath: 'assets/images/location_img2.png',
      titleText: 'Midtown, Manhattan',
      descriptionText: '20 restaurants',
    ),
    CircleContainerModel(
      imgPath: 'assets/images/location_img3.png',
      titleText: 'Columbus Circle',
      descriptionText: '20 restaurants',
    ),
    CircleContainerModel(
      imgPath: 'assets/images/location_img1.png',
      titleText: 'Time Square',
      descriptionText: '14 restaurants',
    ),
  ];

  // Function to scroll left
  void scrollLeft() {
    scrollController.animateTo(
      scrollController.offset - 300, // Scroll left by 300 pixels
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  // Function to scroll right
  void scrollRight() {
    scrollController.animateTo(
      scrollController.offset + 300, // Scroll right by 300 pixels
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  void onClose() {
    scrollController.dispose(); // Dispose the controller when not in use
    super.onClose();
  }

  List<RestaurantModel> resaturant_list = [
    RestaurantModel(
      resName: "The Fancy Fork",
      averageRating: 3,
      docID: 'qA4ZwrICw8NWshCaZ52a5dqgDSj2',
      resEmail: "contact@fancyfork.com",
      specialConditions: "No pets allowed",
      socialLink: "https://instagram.com/fancyfork",
      password: "securepassword123",
      city: "New York",
      dateTime: DateTime.now().subtract(Duration(days: 2)),
      address: "123 Gourmet St",
      zipCode: "10001",
      logoImage:
          'https://plus.unsplash.com/premium_photo-1673108852141-e8c3c22a4a22?q=80&w=2940&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
      facilityList: ["Free WiFi", "Parking", "Outdoor Seating"],
      imagesList: [
        'https://plus.unsplash.com/premium_photo-1673108852141-e8c3c22a4a22?q=80&w=2940&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
        'https://images.unsplash.com/photo-1482049016688-2d3e1b311543?q=80&w=2810&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
        'https://images.unsplash.com/photo-1482049016688-2d3e1b311543?q=80&w=2810&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
        'https://images.unsplash.com/photo-1482049016688-2d3e1b311543?q=80&w=2810&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
      ],
      dietaryList: ["Vegan", "Gluten-Free"],
      atmopshereList: ["Casual", "Romantic"],
      spokenLanguage: "English",
      socialMedia: "Instagram",
      priceRange: "156",
      latitude: 33.6995,
      longitude: 73.0363,
      entertainmentScheduleList: [
        EntertainmentScheduleModel(
          eventName: "Live Jazz Night",
          eventBy: "The Smooth Band",
          startTime: "7:00 PM",
          endTime: "10:00 PM",
          day: "Friday",
          date: "2025-02-02",
          isSelected: false,
        ),
        EntertainmentScheduleModel(
          eventName: "Band",
          eventBy: "The Smooth Band",
          startTime: "7:00 PM",
          endTime: "10:00 PM",
          day: "Thursday",
          date: "2025-02-02",
          isSelected: false,
        ),
      ],
      menuList: MenuModel(
        percentageOff: [
          PersentageModel(
            startTime: "12:00 PM",
            endTime: "2:00 PM",
            percentage: '20 %',
            food: MealModel(
              offerName: "2 for 1",
              imagesList: [
                'https://images.unsplash.com/photo-1540189549336-e6e99c3679fe?q=80&w=2787&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
                'https://images.unsplash.com/photo-1482049016688-2d3e1b311543?q=80&w=2810&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
                'https://images.unsplash.com/photo-1540189549336-e6e99c3679fe?q=80&w=2787&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
              ],
            ),
            drink: MealModel(
              offerName: "Free",
              imagesList: [
                'https://plus.unsplash.com/premium_photo-1673108852141-e8c3c22a4a22?q=80&w=2940&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
                'https://images.unsplash.com/photo-1482049016688-2d3e1b311543?q=80&w=2810&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
                'https://images.unsplash.com/photo-1482049016688-2d3e1b311543?q=80&w=2810&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
              ],
            ),
            cuisine: "American",
          ),
          PersentageModel(
            startTime: "4:00 PM",
            endTime: "6:00 PM",
            percentage: '26 %',
            food: MealModel(
              offerName: "5 for 1",
              imagesList: [
                'https://images.unsplash.com/photo-1482049016688-2d3e1b311543?q=80&w=2810&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
                'https://images.unsplash.com/photo-1540189549336-e6e99c3679fe?q=80&w=2787&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
              ],
            ),
            drink: MealModel(
              offerName: "Free Iced",
              imagesList: [
                'https://plus.unsplash.com/premium_photo-1673108852141-e8c3c22a4a22?q=80&w=2940&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
                'https://images.unsplash.com/photo-1482049016688-2d3e1b311543?q=80&w=2810&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
              ],
            ),
            cuisine: "American",
          ),
          PersentageModel(
            startTime: "1:00 PM",
            endTime: "2:00 PM",
            percentage: '60 %',
            food: MealModel(
              offerName: "4 for 1",
              imagesList: [
                'https://images.unsplash.com/photo-1540189549336-e6e99c3679fe?q=80&w=2787&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
              ],
            ),
            drink: MealModel(
              offerName: "Free Coffee",
              imagesList: [
                'https://plus.unsplash.com/premium_photo-1673108852141-e8c3c22a4a22?q=80&w=2940&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
              ],
            ),
            cuisine: "American",
          ),
        ],
        happyHourSpecials: [
          HappyHourModel(
            startTime: "5:00 PM",
            endTime: "7:00 PM",
            percentage: '30 %',
            food: MealModel(
              offerName: "Free Buffalo Wings",
              imagesList: [
                'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?q=80&w=2960&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
                'https://images.unsplash.com/photo-1482049016688-2d3e1b311543?q=80&w=2810&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
                'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?q=80&w=2960&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
              ],
            ),
            drink: MealModel(
              offerName: "1 Margarita",
              imagesList: [
                'https://plus.unsplash.com/premium_photo-1673108852141-e8c3c22a4a22?q=80&w=2940&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
                'https://images.unsplash.com/photo-1482049016688-2d3e1b311543?q=80&w=2810&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
                'https://images.unsplash.com/photo-1482049016688-2d3e1b311543?q=80&w=2810&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
              ],
            ),
            cuisine: "Tex-Mex",
          ),
        ],
      ),
      about: "A modern restaurant offering the best dining experience.",
    ),
    RestaurantModel(
      resName: "Spice Symphony",
      averageRating: 2,
      dateTime: DateTime.now().subtract(Duration(days: 5)),
      docID: '2323452345345345345',
      resEmail: "contact@fancyfork.com",
      specialConditions: "No pets allowed",
      socialLink: "https://instagram.com/fancyfork",
      password: "securepassword123",
      city: "New York",
      address: "123 Gourmet St",
      zipCode: "10001",
      logoImage:
          'https://plus.unsplash.com/premium_photo-1673108852141-e8c3c22a4a22?q=80&w=2940&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
      facilityList: ["Free WiFi", "Parking", "Outdoor Seating"],
      imagesList: [
        'https://plus.unsplash.com/premium_photo-1673108852141-e8c3c22a4a22?q=80&w=2940&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
        'https://images.unsplash.com/photo-1482049016688-2d3e1b311543?q=80&w=2810&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
        'https://images.unsplash.com/photo-1482049016688-2d3e1b311543?q=80&w=2810&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
        'https://images.unsplash.com/photo-1482049016688-2d3e1b311543?q=80&w=2810&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
      ],
      dietaryList: ["Vegan", "Gluten-Free"],
      atmopshereList: ["Casual", "Romantic"],
      spokenLanguage: "English",
      socialMedia: "Instagram",
      priceRange: "156",
      latitude: 33.6995,
      longitude: 73.0363,
      entertainmentScheduleList: [
        EntertainmentScheduleModel(
          eventName: "Live Jazz Night",
          eventBy: "The Smooth Band",
          startTime: "7:00 PM",
          endTime: "10:00 PM",
          day: "Friday",
          date: "2025-02-02",
          isSelected: false,
        ),
        EntertainmentScheduleModel(
          eventName: "Band",
          eventBy: "The Smooth Band",
          startTime: "7:00 PM",
          endTime: "10:00 PM",
          day: "Thursday",
          date: "2025-02-02",
          isSelected: false,
        ),
      ],
      menuList: MenuModel(
        percentageOff: [
          PersentageModel(
            startTime: "12:00 PM",
            endTime: "2:00 PM",
            percentage: '20 %',
            food: MealModel(
              offerName: "2 for 1",
              imagesList: [
                'https://images.unsplash.com/photo-1540189549336-e6e99c3679fe?q=80&w=2787&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
                'https://images.unsplash.com/photo-1482049016688-2d3e1b311543?q=80&w=2810&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
                'https://images.unsplash.com/photo-1540189549336-e6e99c3679fe?q=80&w=2787&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
              ],
            ),
            drink: MealModel(
              offerName: "Free",
              imagesList: [
                'https://plus.unsplash.com/premium_photo-1673108852141-e8c3c22a4a22?q=80&w=2940&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
                'https://images.unsplash.com/photo-1482049016688-2d3e1b311543?q=80&w=2810&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
                'https://images.unsplash.com/photo-1482049016688-2d3e1b311543?q=80&w=2810&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
              ],
            ),
            cuisine: "American",
          ),
          PersentageModel(
            startTime: "4:00 PM",
            endTime: "6:00 PM",
            percentage: '26 %',
            food: MealModel(
              offerName: "5 for 1",
              imagesList: [
                'https://images.unsplash.com/photo-1482049016688-2d3e1b311543?q=80&w=2810&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
                'https://images.unsplash.com/photo-1540189549336-e6e99c3679fe?q=80&w=2787&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
              ],
            ),
            drink: MealModel(
              offerName: "Free Iced",
              imagesList: [
                'https://plus.unsplash.com/premium_photo-1673108852141-e8c3c22a4a22?q=80&w=2940&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
                'https://images.unsplash.com/photo-1482049016688-2d3e1b311543?q=80&w=2810&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
              ],
            ),
            cuisine: "American",
          ),
          PersentageModel(
            startTime: "1:00 PM",
            endTime: "2:00 PM",
            percentage: '60 %',
            food: MealModel(
              offerName: "4 for 1",
              imagesList: [
                'https://images.unsplash.com/photo-1540189549336-e6e99c3679fe?q=80&w=2787&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
              ],
            ),
            drink: MealModel(
              offerName: "Free Coffee",
              imagesList: [
                'https://plus.unsplash.com/premium_photo-1673108852141-e8c3c22a4a22?q=80&w=2940&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
              ],
            ),
            cuisine: "American",
          ),
        ],
        happyHourSpecials: [
          HappyHourModel(
            startTime: "5:00 PM",
            endTime: "7:00 PM",
            percentage: '30 %',
            food: MealModel(
              offerName: "Free Buffalo Wings",
              imagesList: [
                'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?q=80&w=2960&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
                'https://images.unsplash.com/photo-1482049016688-2d3e1b311543?q=80&w=2810&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
                'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?q=80&w=2960&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
              ],
            ),
            drink: MealModel(
              offerName: "1 Margarita",
              imagesList: [
                'https://plus.unsplash.com/premium_photo-1673108852141-e8c3c22a4a22?q=80&w=2940&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
                'https://images.unsplash.com/photo-1482049016688-2d3e1b311543?q=80&w=2810&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
                'https://images.unsplash.com/photo-1482049016688-2d3e1b311543?q=80&w=2810&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
              ],
            ),
            cuisine: "Tex-Mex",
          ),
        ],
      ),
      about: "A modern restaurant offering the best dining experience.",
    ),
    RestaurantModel(
      resName: "Shanwari",
      averageRating: 2,
      docID: '456456456786786978687',
      resEmail: "contact@fancyfork.com",
      specialConditions: "No pets allowed",
      dateTime: DateTime.now().subtract(Duration(days: 1)),
      socialLink: "https://instagram.com/fancyfork",
      password: "securepassword123",
      city: "New York",
      address: "123 Gourmet St",
      zipCode: "10001",
      logoImage:
          'https://plus.unsplash.com/premium_photo-1673108852141-e8c3c22a4a22?q=80&w=2940&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
      facilityList: ["Free WiFi", "Parking", "Outdoor Seating"],
      imagesList: [
        'https://plus.unsplash.com/premium_photo-1673108852141-e8c3c22a4a22?q=80&w=2940&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
        'https://images.unsplash.com/photo-1482049016688-2d3e1b311543?q=80&w=2810&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
        'https://images.unsplash.com/photo-1482049016688-2d3e1b311543?q=80&w=2810&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
        'https://images.unsplash.com/photo-1482049016688-2d3e1b311543?q=80&w=2810&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
      ],
      dietaryList: ["Vegan", "Gluten-Free"],
      atmopshereList: ["Casual", "Romantic"],
      spokenLanguage: "English",
      socialMedia: "Instagram",
      priceRange: "156",
      latitude: 33.6995,
      longitude: 73.0363,
      entertainmentScheduleList: [
        EntertainmentScheduleModel(
          eventName: "Live Jazz Night",
          eventBy: "The Smooth Band",
          startTime: "7:00 PM",
          endTime: "10:00 PM",
          day: "Friday",
          date: "2025-02-02",
          isSelected: false,
        ),
        EntertainmentScheduleModel(
          eventName: "Band",
          eventBy: "The Smooth Band",
          startTime: "7:00 PM",
          endTime: "10:00 PM",
          day: "Thursday",
          date: "2025-02-02",
          isSelected: false,
        ),
      ],
      menuList: MenuModel(
        percentageOff: [
          PersentageModel(
            startTime: "12:00 PM",
            endTime: "2:00 PM",
            percentage: '20 %',
            food: MealModel(
              offerName: "2 for 1",
              imagesList: [
                'https://images.unsplash.com/photo-1540189549336-e6e99c3679fe?q=80&w=2787&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
                'https://images.unsplash.com/photo-1482049016688-2d3e1b311543?q=80&w=2810&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
                'https://images.unsplash.com/photo-1540189549336-e6e99c3679fe?q=80&w=2787&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
              ],
            ),
            drink: MealModel(
              offerName: "Free",
              imagesList: [
                'https://plus.unsplash.com/premium_photo-1673108852141-e8c3c22a4a22?q=80&w=2940&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
                'https://images.unsplash.com/photo-1482049016688-2d3e1b311543?q=80&w=2810&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
                'https://images.unsplash.com/photo-1482049016688-2d3e1b311543?q=80&w=2810&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
              ],
            ),
            cuisine: "American",
          ),
          PersentageModel(
            startTime: "4:00 PM",
            endTime: "6:00 PM",
            percentage: '26 %',
            food: MealModel(
              offerName: "5 for 1",
              imagesList: [
                'https://images.unsplash.com/photo-1482049016688-2d3e1b311543?q=80&w=2810&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
                'https://images.unsplash.com/photo-1540189549336-e6e99c3679fe?q=80&w=2787&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
              ],
            ),
            drink: MealModel(
              offerName: "Free Iced",
              imagesList: [
                'https://plus.unsplash.com/premium_photo-1673108852141-e8c3c22a4a22?q=80&w=2940&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
                'https://images.unsplash.com/photo-1482049016688-2d3e1b311543?q=80&w=2810&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
              ],
            ),
            cuisine: "American",
          ),
          PersentageModel(
            startTime: "1:00 PM",
            endTime: "2:00 PM",
            percentage: '60 %',
            food: MealModel(
              offerName: "4 for 1",
              imagesList: [
                'https://images.unsplash.com/photo-1540189549336-e6e99c3679fe?q=80&w=2787&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
              ],
            ),
            drink: MealModel(
              offerName: "Free Coffee",
              imagesList: [
                'https://plus.unsplash.com/premium_photo-1673108852141-e8c3c22a4a22?q=80&w=2940&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
              ],
            ),
            cuisine: "American",
          ),
        ],
        happyHourSpecials: [
          HappyHourModel(
            startTime: "5:00 PM",
            endTime: "7:00 PM",
            percentage: '30 %',
            food: MealModel(
              offerName: "Free Buffalo Wings",
              imagesList: [
                'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?q=80&w=2960&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
                'https://images.unsplash.com/photo-1482049016688-2d3e1b311543?q=80&w=2810&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
                'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?q=80&w=2960&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
              ],
            ),
            drink: MealModel(
              offerName: "1 Margarita",
              imagesList: [
                'https://plus.unsplash.com/premium_photo-1673108852141-e8c3c22a4a22?q=80&w=2940&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
                'https://images.unsplash.com/photo-1482049016688-2d3e1b311543?q=80&w=2810&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
                'https://images.unsplash.com/photo-1482049016688-2d3e1b311543?q=80&w=2810&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
              ],
            ),
            cuisine: "Tex-Mex",
          ),
        ],
      ),
      about: "A modern restaurant offering the best dining experience.",
    ),
  ];

  addFavoriteResturants({required String restaurantID}) async {
    try {
      // Reference to the current user's favorite collection
      var favCollection = FirebaseFirestore.instance
          .collection('users')
          .doc(auth.currentUser!.uid)
          .collection('favorite');

      // Check if the restaurant already exists in the favorite collection
      var existingFav = await favCollection
          .where('resturantID', isEqualTo: restaurantID)
          .get();

      if (existingFav.docs.isEmpty) {
        // If the restaurant doesn't exist, add it
        String favId = favCollection.doc().id;
        await favCollection.doc(favId).set({
          'resturantID': restaurantID,
          'favID': favId,
        });
      } else {
        // If the restaurant exists, remove it
        for (var doc in existingFav.docs) {
          await doc.reference.delete();
        }
      }
    } catch (e) {
      // Handle errors here
      print('Error: $e');
    }
  }

  addRestaurantReview({
    required String restaurantID,
    required List<File> images, // List of image URLs
    required double starRating, // Total star rating (1-5)
    required String description, // Description note
  }) async {
    try {
      loadingDialog(message: 'Please wait!', loading: true, height: 150);
      List<String> imagesLinks = [];
      for (var v in images) {
        imagesLinks
            .add(await uploadImageToFirebase('reviews', v.readAsBytesSync()));
      }
      print('restaurantID ------- $restaurantID');
      var reviewCollection = FirebaseFirestore.instance
          .collection('restaurants')
          .doc(restaurantID)
          .collection('reviews');

      // Create a new review ID
      String reviewId = reviewCollection.doc().id;

      // Add the review
      await reviewCollection.doc(reviewId).set({
        'reviewID': reviewId,
        'restaurantID': restaurantID,
        'userName': currentUserDataModel?.value.username.text,
        'userID': auth.currentUser?.uid,
        'images': imagesLinks, // List of image URLs
        'starRating': starRating, // Star rating
        'description': description, // Description note
        'dateTime':
            FieldValue.serverTimestamp(), // Timestamp of review creation
      });

      print('Review added successfully!');
      Get.back();
    } catch (e) {
      Get.back();
      print('Error adding review: $e');
    }
  }

  Widget favoriteHeart({resturant_id}) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(auth.currentUser!.uid) // Current user's document
          .collection('favorite')
          .where('resturantID',
              isEqualTo: resturant_id) // Filter by restaurantID
          .snapshots(), // Stream the snapshot for real-time updates
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Icon(
            Icons.favorite_border_outlined,
            size: 18,
            color: AppColors.primaryColor,
          ); // Show loading indicator while waiting for data
        }

        if (snapshot.hasError) {
          return Icon(
            Icons.favorite_border_outlined,
            size: 18,
            color: AppColors.primaryColor,
          ); // Show error icon if there's an error
        }

        // Check if the restaurant exists in the favorite collection
        bool isFavorite = snapshot.data!.docs.isNotEmpty;

        return InkWell(
          onTap: () {
            // Toggle favorite status
            if (isFavorite) {
              // Remove the restaurant from favorites
              FirebaseFirestore.instance
                  .collection('users')
                  .doc(auth.currentUser!.uid)
                  .collection('favorite')
                  .where('resturantID', isEqualTo: resturant_id)
                  .get()
                  .then((snapshot) {
                for (var doc in snapshot.docs) {
                  doc.reference.delete(); // Remove from favorites
                }
              });
            } else {
              // Add the restaurant to favorites
              String favId = FirebaseFirestore.instance
                  .collection('users')
                  .doc(auth.currentUser!.uid)
                  .collection('favorite')
                  .doc()
                  .id;

              FirebaseFirestore.instance
                  .collection('users')
                  .doc(auth.currentUser!.uid)
                  .collection('favorite')
                  .doc(favId)
                  .set({
                'resturantID': resturant_id,
                'favID': favId,
              });
            }
          },
          child: isFavorite
              ? Image.asset(
                  'assets/images/heart_icon.png',
                  color: AppColors.primaryColor,
                  height: 16,
                  width: 16,
                )
              : Icon(
                  Icons.favorite_border_outlined,
                  size: 18,
                  color: AppColors.primaryColor,
                ),
        );
      },
    );
  }

  Stream<List<ReviewModel>> getReviews(String restaurantID) {
    return FirebaseFirestore.instance
        .collection('restaurants')
        .doc(restaurantID)
        .collection('reviews')
        .orderBy('dateTime',
            descending: true) // Sort by dateTime (most recent first)
        .snapshots()
        .map((querySnapshot) {
      return querySnapshot.docs.map((doc) {
        return ReviewModel.fromFirestore(doc.data() as Map<String, dynamic>);
      }).toList();
    });
  }

  //get trensing resturants base on totoal reviews and rating

  Future<List<RestaurantModel>> getTrendingRestaurants() async {
    final restaurantsSnapshot =
        await FirebaseFirestore.instance.collection('restaurants').get();

    List<RestaurantModel> restaurants = [];

    for (var doc in restaurantsSnapshot.docs) {
      final reviewsSnapshot = await doc.reference.collection('reviews').get();

      int totalReviews = reviewsSnapshot.size;
      double totalRating = reviewsSnapshot.docs
          .map((e) => double.parse(e['starRating'].toString()))
          .fold(0.0, (prev, rating) => prev + rating);
      double averageRating =
          totalReviews > 0 ? totalRating / totalReviews : 0.0;

      if (totalReviews > 0) {
        restaurants.add(
          RestaurantModel(
            resName: doc['resName'],
            docID: doc['docID'],
            resEmail: doc['resEmail'],
            averageRating: averageRating,
            specialConditions: doc['specialConditions'],
            socialLink: doc['socialLink'],
            password: "securepassword123",
            city: doc['city'],
            dateTime: DateTime.now().subtract(Duration(days: 30)),
            address: doc['address'],
            zipCode: doc['zipCode'],
            logoImage: doc['logoImage'],
            facilityList: (doc['facilityList'] as List<dynamic>).cast<String>(),
            imagesList: [
              'https://plus.unsplash.com/premium_photo-1673108852141-e8c3c22a4a22?q=80&w=2940&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
              'https://images.unsplash.com/photo-1482049016688-2d3e1b311543?q=80&w=2810&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
              'https://images.unsplash.com/photo-1482049016688-2d3e1b311543?q=80&w=2810&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
              'https://images.unsplash.com/photo-1482049016688-2d3e1b311543?q=80&w=2810&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
            ],
            dietaryList: ["Vegan", "Gluten-Free"],
            atmopshereList: ["Casual", "Romantic"],
            spokenLanguage: "English",
            socialMedia: "Instagram",
            priceRange: "156",
            latitude: 33.6995,
            longitude: 73.0363,
            entertainmentScheduleList: [
              EntertainmentScheduleModel(
                eventName: "Live Jazz Night",
                eventBy: "The Smooth Band",
                startTime: "7:00 PM",
                endTime: "10:00 PM",
                day: "Friday",
                date: "2025-02-02",
                isSelected: false,
              ),
              EntertainmentScheduleModel(
                eventName: "Band",
                eventBy: "The Smooth Band",
                startTime: "7:00 PM",
                endTime: "10:00 PM",
                day: "Thursday",
                date: "2025-02-02",
                isSelected: false,
              ),
            ],
            menuList: MenuModel(
              percentageOff: [
                PersentageModel(
                  startTime: "12:00 PM",
                  endTime: "2:00 PM",
                  percentage: '20 %',
                  food: MealModel(
                    offerName: "2 for 1",
                    imagesList: [
                      'https://images.unsplash.com/photo-1540189549336-e6e99c3679fe?q=80&w=2787&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
                      'https://images.unsplash.com/photo-1482049016688-2d3e1b311543?q=80&w=2810&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
                      'https://images.unsplash.com/photo-1540189549336-e6e99c3679fe?q=80&w=2787&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
                    ],
                  ),
                  drink: MealModel(
                    offerName: "Free",
                    imagesList: [
                      'https://plus.unsplash.com/premium_photo-1673108852141-e8c3c22a4a22?q=80&w=2940&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
                      'https://images.unsplash.com/photo-1482049016688-2d3e1b311543?q=80&w=2810&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
                      'https://images.unsplash.com/photo-1482049016688-2d3e1b311543?q=80&w=2810&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
                    ],
                  ),
                  cuisine: "American",
                ),
                PersentageModel(
                  startTime: "4:00 PM",
                  endTime: "6:00 PM",
                  percentage: '26 %',
                  food: MealModel(
                    offerName: "5 for 1",
                    imagesList: [
                      'https://images.unsplash.com/photo-1482049016688-2d3e1b311543?q=80&w=2810&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
                      'https://images.unsplash.com/photo-1540189549336-e6e99c3679fe?q=80&w=2787&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
                    ],
                  ),
                  drink: MealModel(
                    offerName: "Free Iced",
                    imagesList: [
                      'https://plus.unsplash.com/premium_photo-1673108852141-e8c3c22a4a22?q=80&w=2940&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
                      'https://images.unsplash.com/photo-1482049016688-2d3e1b311543?q=80&w=2810&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
                    ],
                  ),
                  cuisine: "American",
                ),
                PersentageModel(
                  startTime: "1:00 PM",
                  endTime: "2:00 PM",
                  percentage: '60 %',
                  food: MealModel(
                    offerName: "4 for 1",
                    imagesList: [
                      'https://images.unsplash.com/photo-1540189549336-e6e99c3679fe?q=80&w=2787&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
                    ],
                  ),
                  drink: MealModel(
                    offerName: "Free Coffee",
                    imagesList: [
                      'https://plus.unsplash.com/premium_photo-1673108852141-e8c3c22a4a22?q=80&w=2940&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
                    ],
                  ),
                  cuisine: "American",
                ),
              ],
              happyHourSpecials: [
                HappyHourModel(
                  startTime: "5:00 PM",
                  endTime: "7:00 PM",
                  percentage: '30 %',
                  food: MealModel(
                    offerName: "Free Buffalo Wings",
                    imagesList: [
                      'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?q=80&w=2960&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
                      'https://images.unsplash.com/photo-1482049016688-2d3e1b311543?q=80&w=2810&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
                      'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?q=80&w=2960&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
                    ],
                  ),
                  drink: MealModel(
                    offerName: "1 Margarita",
                    imagesList: [
                      'https://plus.unsplash.com/premium_photo-1673108852141-e8c3c22a4a22?q=80&w=2940&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
                      'https://images.unsplash.com/photo-1482049016688-2d3e1b311543?q=80&w=2810&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
                      'https://images.unsplash.com/photo-1482049016688-2d3e1b311543?q=80&w=2810&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
                    ],
                  ),
                  cuisine: "Tex-Mex",
                ),
              ],
            ),
            about: "A modern restaurant offering the best dining experience.",
          ),
        );
      }
    }

    // Sort by average rating or total reviews
    restaurants.sort((a, b) => b.averageRating.compareTo(a.averageRating));

    return restaurants;
  }

  addRecentView({
    required String restaurantID,
  }) async {
    try {
      var reviewCollection = FirebaseFirestore.instance
          .collection('users')
          .doc(auth.currentUser?.uid)
          .collection('recentView');

      // Check if a recent view already exists for the current user and the restaurant
      var existingView = await reviewCollection
          .where('userID', isEqualTo: auth.currentUser?.uid)
          .where('restaurantID', isEqualTo: restaurantID)
          .limit(1) // Limit to 1 to ensure we only get one document
          .get();

      if (existingView.docs.isNotEmpty) {
        // If the recent view exists, update the dateTime field
        String existingViewId = existingView.docs.first.id;

        await reviewCollection.doc(existingViewId).update({
          'dateTime': FieldValue.serverTimestamp(),
        });

        print('Recent view updated successfully!');
      } else {
        // If no recent view exists, create a new one
        String recentViewId = reviewCollection.doc().id;

        await reviewCollection.doc(recentViewId).set({
          'recentViewID': recentViewId,
          'restaurantID': restaurantID,
          'userName': currentUserDataModel?.value.username.text,
          'userID': auth.currentUser?.uid,
          'dateTime': FieldValue.serverTimestamp(),
        });

        print('Recent view added successfully!');
      }
    } catch (e) {
      Get.back();
      print('Error adding or updating recent view: $e');
    }
  }

Stream<List<RecentViewModel>> getRecentViews() {
  // Access the Firestore collection where recent views are stored for the current user
  var recentViewCollection = FirebaseFirestore.instance
      .collection('users')
      .doc(auth.currentUser?.uid)
      .collection('recentView');

  return recentViewCollection.snapshots().map((querySnapshot) {
    // Convert the documents to RecentViewModel objects
    return querySnapshot.docs.map((doc) {
      return RecentViewModel.fromMap(doc.data() as Map<String, dynamic>);
    }).toList();
  });
}

}
