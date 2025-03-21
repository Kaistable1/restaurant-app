import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:savrly_data_entry_app/models/my_resturant.dart';
import 'package:savrly_data_entry_app/screens/service/yelp_api_model.dart';
import '../../service/GoogleResponse.dart';
import '../../service/api_model.dart';
import 'package:http/http.dart' as http;

class HomeController extends GetxController {
  var businesses = <YelpBusiness>[].obs;
  var selectedOption = "Option 1".obs; // Default selected option
  var isLoading = false.obs; // Loading state
  TextEditingController searchController =
      TextEditingController(); // Search field controller
  var errorMessage = "".obs; // Error message state

  void setSelected(String value) {
    selectedOption.value = value;
  }

  addHistory({text}) async {
    try {
      await FirebaseFirestore.instance.collection('history').add({
        'searchText': text,
        'createdAt': DateTime.now(),
      });
    } catch (e) {
      print('Error $e');
    }
  }
}

class PlacesController extends GetxController {
  RxList<BusinessModel> businessList = <BusinessModel>[].obs;
  RxBool isLoading = false.obs;
// google api calling for restaurants searching
  RxList<YelApiBusiness> yelpAPIRestaurants = <YelApiBusiness>[].obs;
  RxBool isGoogleLoading = false.obs;

  final String googleApiKey =
      "wBmUkpCxkFo-bia5ASkZDYq2fvAyymH_NngnIslr_38pMC5S2_uf7l9mOHUD4lGMFT3hvszGvfM0PKblG-VAVfVa9LTU_C5h5UEcDiCLuLhtnIM5j3G8tp33a928Z3Yx";

  Future<void> fetchRestaurantsGoogle(String? query) async {
    isLoading.value = true;
    try {
      String queryData = '$query resraurants';
      String url =
          "https://maps.googleapis.com/maps/api/place/textsearch/json?query=$queryData&key=AIzaSyCh8VHJnq_7G4_lZ2t9hDkxdd_P2KTYuoI";
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

  int offset = 0;

  Future<void> fetchRestaurantsYelp(query, {limit}) async {
    isGoogleLoading.value = true;
    try {
      offset += int.parse(limit.toString());
      var headers = {
        'Authorization':
            'Bearer wBmUkpCxkFo-bia5ASkZDYq2fvAyymH_NngnIslr_38pMC5S2_uf7l9mOHUD4lGMFT3hvszGvfM0PKblG-VAVfVa9LTU_C5h5UEcDiCLuLhtnIM5j3G8tp33a928Z3Yx',
      };
      String url =
          "https://api.yelp.com/v3/businesses/search?location=$query&limit=$limit&offset=$offset";
      final response = await http.get(Uri.parse(url), headers: headers);

      print("Response Url: ${url}");
      print("Response Status Code: ${response.statusCode}");
      if (response.statusCode == 200) {
        yelpAPIRestaurants
            .assignAll(YelApiBusiness.fromJsonList(response.body));
      } else {
        print("Error: ${response.reasonPhrase}");
      }
    } catch (e) {
      print("Error: $e");
    }
    isGoogleLoading.value = false;
  }

  Future<Map<String, int>> addRestaurants(
      List<RestaurantModel> restaurants) async {
    final CollectionReference restaurantsCollection =
        FirebaseFirestore.instance.collection("restaurants");

    int duplicateCount = 0;
    int addedCount = 0;

    for (var restaurant in restaurants) {
      bool exists = await _checkIfRestaurantExists(restaurant.resName);

      if (exists) {
        duplicateCount++; // Increment if restaurant already exists
      } else {
        String docID = restaurantsCollection.doc().id;
        restaurant.docID = docID;
        await restaurantsCollection.doc(docID).set(await restaurant.toMap());
        addedCount++; // Increment if a new restaurant is added
      }
    }

    return {
      "duplicates": duplicateCount,
      "added": addedCount,
    };
  }

  Future<bool> _checkIfRestaurantExists(String resName) async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection("restaurants")
        .where("resName", isEqualTo: resName)
        .limit(1)
        .get();

    return querySnapshot.docs.isNotEmpty; // Returns true if restaurant exists
  }
}
