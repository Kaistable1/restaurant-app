import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../models/restaurant_management_model.dart';
import '../models/user_management_model.dart';

class RestaurantManagementController extends GetxController {
  final searchController = TextEditingController();
  RxString selectedCity = ''.obs;
  RxString selectedCuisine = ''.obs;

  RxList<String> cityList =
      <String>['Karachi', 'Lahore', 'Islamabad', 'Rawalpindi', 'Peshawar'].obs;

  RxList<String> cuisineList =
      <String>['Pakistani', 'Chinese', 'Italian', 'Fast Food', 'Indian'].obs;

  var restaurants =
      <RestaurantManagementModel>[
        RestaurantManagementModel(
          id: 1,
          name: 'Tandoori Flame',
          cuisine: 'Indian',
          city: 'Lahore',
          phone: '03001234567',
          status: 'Pending',
          photoUrl: 'assets/images/res_table_1.png',
        ),
        RestaurantManagementModel(
          id: 2,
          name: 'Pizza Roma',
          cuisine: 'Italian',
          city: 'Karachi',
          phone: '03111234567',
          status: 'Registered',
          photoUrl: 'assets/images/res_table_2.png',
        ),
        RestaurantManagementModel(
          id: 3,
          name: 'Tandoori Flame',
          cuisine: 'Indian',
          city: 'Lahore',
          phone: '03001234567',
          status: 'Pending',
          photoUrl: 'assets/images/res_table_3.png',
        ),
        RestaurantManagementModel(
          id: 4,
          name: 'Pizza Roma',
          cuisine: 'Italian',
          city: 'Karachi',
          phone: '03111234567',
          status: 'Registered',
          photoUrl: 'assets/images/res_table_4.png',
        ),
        RestaurantManagementModel(
          id: 5,
          name: 'Tandoori Flame',
          cuisine: 'Indian',
          city: 'Lahore',
          phone: '03001234567',
          status: 'Pending',
          photoUrl: 'assets/images/res_table_1.png',
        ),
        RestaurantManagementModel(
          id: 6,
          name: 'Pizza Roma',
          cuisine: 'Italian',
          city: 'Karachi',
          phone: '03111234567',
          status: 'Registered',
          photoUrl: 'assets/images/res_table_3.png',
        ),
        RestaurantManagementModel(
          id: 7,
          name: 'Tandoori Flame',
          cuisine: 'Indian',
          city: 'Lahore',
          phone: '03001234567',
          status: 'Pending',
          photoUrl: 'assets/images/res_table_1.png',
        ),
        RestaurantManagementModel(
          id: 8,
          name: 'Pizza Roma',
          cuisine: 'Italian',
          city: 'Karachi',
          phone: '03111234567',
          status: 'Registered',
          photoUrl: 'assets/images/res_table_4.png',
        ),
        RestaurantManagementModel(
          id: 9,
          name: 'Tandoori Flame',
          cuisine: 'Indian',
          city: 'Lahore',
          phone: '03001234567',
          status: 'Pending',
          photoUrl: 'assets/images/res_table_1.png',
        ),
        RestaurantManagementModel(
          id: 10,
          name: 'Pizza Roma',
          cuisine: 'Italian',
          city: 'Karachi',
          phone: '03111234567',
          status: 'Registered',
          photoUrl: 'assets/images/res_table_4.png',
        ),
        RestaurantManagementModel(
          id: 11,
          name: 'Tandoori Flame',
          cuisine: 'Indian',
          city: 'Lahore',
          phone: '03001234567',
          status: 'Pending',
          photoUrl: 'assets/images/res_table_3.png',
        ),
        RestaurantManagementModel(
          id: 12,
          name: 'Pizza Roma',
          cuisine: 'Italian',
          city: 'Karachi',
          phone: '03111234567',
          status: 'Registered',
          photoUrl: 'assets/images/res_table_2.png',
        ),
        RestaurantManagementModel(
          id: 13,
          name: 'Tandoori Flame',
          cuisine: 'Indian',
          city: 'Lahore',
          phone: '03001234567',
          status: 'Pending',
          photoUrl: 'assets/images/res_table_4.png',
        ),
        RestaurantManagementModel(
          id: 14,
          name: 'Pizza Roma',
          cuisine: 'Italian',
          city: 'Karachi',
          phone: '03111234567',
          status: 'Registered',
          photoUrl: 'assets/images/res_table_3.png',
        ),
        // Add more restaurants...
      ].obs;

  void deleteRestaurant(int index) {
    restaurants.removeAt(index);
  }
}
