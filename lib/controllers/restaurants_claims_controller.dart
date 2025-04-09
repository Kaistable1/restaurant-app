import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/claims_model.dart';

class RestaurantsClaimsController extends GetxController{
  final passwordController=TextEditingController();

  var restaurantsClaims =
      <RestaurantClaimsModel>[
        RestaurantClaimsModel(
          id: 1,
          restaurantsName: 'Sushi Haven',
          ownerName: 'Esther Howard',
          email: 'bill.sanders@example.com',
          message: 'I\'m claiming for a service delay that affected our clients.',
          status: 'Pending',
          photoUrl: 'assets/images/res_table_1.png',

        ),
        RestaurantClaimsModel(
          id: 1,
          restaurantsName: 'Sushi Haven',
          ownerName: 'Esther Howard',
          email: 'bill.sanders@example.com',
          message: 'I\'m claiming for a service delay that affected our clients.',
          status: 'Pending',
          photoUrl: 'assets/images/res_table_1.png',

        ),
        RestaurantClaimsModel(
          id: 1,
          restaurantsName: 'Sushi Haven',
          ownerName: 'Esther Howard',
          email: 'bill.sanders@example.com',
          message: 'I\'m claiming for a service delay that affected our clients.',
          status: 'Accepted',
          photoUrl: 'assets/images/res_table_1.png',

        ),
        RestaurantClaimsModel(
          id: 1,
          restaurantsName: 'Sushi Haven',
          ownerName: 'Esther Howard',
          email: 'bill.sanders@example.com',
          message: 'I\'m claiming for a service delay that affected our clients.',
          status: 'Pending',
          photoUrl: 'assets/images/res_table_1.png',

        ),
        RestaurantClaimsModel(
          id: 1,
          restaurantsName: 'Sushi Haven',
          ownerName: 'Esther Howard',
          email: 'bill.sanders@example.com',
          message: 'I\'m claiming for a service delay that affected our clients.',
          status: 'Pending',
          photoUrl: 'assets/images/res_table_1.png',

        ),
        RestaurantClaimsModel(
          id: 1,
          restaurantsName: 'Sushi Haven',
          ownerName: 'Esther Howard',
          email: 'bill.sanders@example.com',
          message: 'I\'m claiming for a service delay that affected our clients.',
          status: 'Accepted',
          photoUrl: 'assets/images/res_table_1.png',

        ),
        RestaurantClaimsModel(
          id: 1,
          restaurantsName: 'Sushi Haven',
          ownerName: 'Esther Howard',
          email: 'bill.sanders@example.com',
          message: 'I\'m claiming for a service delay that affected our clients.',
          status: 'Accepted',
          photoUrl: 'assets/images/res_table_1.png',

        ),
        RestaurantClaimsModel(
          id: 1,
          restaurantsName: 'Sushi Haven',
          ownerName: 'Esther Howard',
          email: 'bill.sanders@example.com',
          message: 'I\'m claiming for a service delay that affected our clients.',
          status: 'Accepted',
          photoUrl: 'assets/images/res_table_1.png',

        ),
        RestaurantClaimsModel(
          id: 1,
          restaurantsName: 'Sushi Haven',
          ownerName: 'Esther Howard',
          email: 'bill.sanders@example.com',
          message: 'I\'m claiming for a service delay that affected our clients.',
          status: 'Pending',
          photoUrl: 'assets/images/res_table_1.png',

        ),


        // Add more restaurants...
      ].obs;

  void deleteRestaurant(int index) {
    restaurantsClaims.removeAt(index);
  }
}