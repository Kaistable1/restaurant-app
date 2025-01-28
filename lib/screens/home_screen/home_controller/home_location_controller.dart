import 'package:flutter/animation.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:kaistable_website/models/resaturant_model.dart';
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
      longitude:73.0363,
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
          day: "Friday",
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
}
