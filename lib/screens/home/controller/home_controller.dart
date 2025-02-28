import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:savrly_data_entry_app/screens/service/yelp_api_model.dart';
import '../../service/GoogleResponse.dart';
import '../../restaurants/restaurant_list_screen.dart';
import '../../service/api_model.dart';
import '../../service/service.dart';
import 'package:http/http.dart' as http;


class HomeController extends GetxController {
  // final YelpService _yelpService = YelpService();
  // final Business model = Business.initialize();
  // final YelApiBusiness yelpModel = YelApiBusiness.initialize();


  var businesses = <YelpBusiness>[].obs;
  var selectedOption = "Option 1".obs; // Default selected option
  var isLoading = false.obs; // Loading state
  TextEditingController searchController =
      TextEditingController(); // Search field controller
  var errorMessage = "".obs; // Error message state

  void setSelected(String value) {
    selectedOption.value = value;
  }

  void search(String query) async {
    if (query.trim().isEmpty) {
      errorMessage.value = "Please enter the city name";
      return;
    }

    errorMessage.value = "";
    isLoading.value = true;

    try {
      if (selectedOption.value == "Option 1") {
        // Google API Call
        print("Searching restaurants in: $query using Google API");
        // var results = await model.name;

        // if (results.isNotEmpty) {
        //   print("Found ${results} Restaurants");
          Get.put(PlacesController()).fetchRestaurants(query);
          Get.to(() => RestaurantListScreen());
        // } else {
        //   errorMessage.value = "No restaurants found in Google API";
        //   print("No results found!");
        // }
      } else {
        // Yelp API Call
        print("Searching restaurants in: $query using Yelp API");
        // var results = await _yelpService.fetchBusinesses(query);

        // if (results.isNotEmpty) {
        //   print("Found ${results.length} Restaurants from Yelp");
          Get.put(PlacesController()).fetchBusinessesGoogle(query);
          Get.to(() => RestaurantListScreen());
        // } else {
        //   errorMessage.value = "No restaurants found in Yelp API";
        //   print("No results found!");
        // }
      }
    } catch (e) {
      print("Error: $e");
      errorMessage.value = "Error fetching data";
    } finally {
      isLoading.value = false;
    }
  }




}

class PlacesController extends GetxController {
  RxList<BusinessModel> businessList = <BusinessModel>[].obs;
  RxBool isLoading = false.obs;

  Future<void> fetchRestaurants(String? query) async {
    isLoading.value = true;
    try {
      String url = "https://maps.googleapis.com/maps/api/place/textsearch/json?query=$query&key=AIzaSyCh8VHJnq_7G4_lZ2t9hDkxdd_P2KTYuoI";
      final response = await http.get(Uri.parse(url));

      print("Response Url: ${response.request}");
      print("Response Status Code: ${response.statusCode}");
      if (response.statusCode == 200) {
        Map<String, dynamic> data = json.decode(response.body);
        List<dynamic> results = data["results"];

        businessList.assignAll(
          results.map((json) => BusinessModel.fromJson(json)).toList(),
        );
        print("Number of restaurants received: ${businessList.length}");
         } else {
        print("Error: ${response.reasonPhrase}");
      }
    } catch (e) {
      print("Error: $e");
    }
    isLoading.value = false;
  }

  // google api calling for restaurants searching
  RxList<YelApiBusiness> businessListGoogle = <YelApiBusiness>[].obs;
  RxBool isGoogleLoading = false.obs;

  final String googleApiKey = "wBmUkpCxkFo-bia5ASkZDYq2fvAyymH_NngnIslr_38pMC5S2_uf7l9mOHUD4lGMFT3hvszGvfM0PKblG-VAVfVa9LTU_C5h5UEcDiCLuLhtnIM5j3G8tp33a928Z3Yx";

  Future<void> fetchBusinessesGoogle(query) async {
    isGoogleLoading.value = true;
    try {
      var headers = {
        'Authorization': 'Bearer wBmUkpCxkFo-bia5ASkZDYq2fvAyymH_NngnIslr_38pMC5S2_uf7l9mOHUD4lGMFT3hvszGvfM0PKblG-VAVfVa9LTU_C5h5UEcDiCLuLhtnIM5j3G8tp33a928Z3Yx',
      };

      String url =
          "https://api.yelp.com/v3/businesses/search?location=$query&limit=10";
      final response = await http.get(Uri.parse(url), headers: headers);

      print("Response Url: ${url}");
      print("Response Status Code: ${response.statusCode}");
      if (response.statusCode == 200) {
        businessListGoogle.assignAll(YelApiBusiness.fromJsonList(response.body));
        print("Number of restaurants received: ${businessListGoogle.length}");
      } else {
        print("Error: ${response.reasonPhrase}");
      }
    } catch (e) {
      print("Error: $e");
    }
    isGoogleLoading.value = false;
  }
}
