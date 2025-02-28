import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:savrly_data_entry_app/constants/text_styles.dart';
import 'package:savrly_data_entry_app/screens/restaurants/restaurant_list_screen.dart';
import 'package:savrly_data_entry_app/widgets/custom_textfield.dart';

import '../../constants/app_colors.dart';

import '../../widgets/custom_button.dart';
import 'controller/home_controller.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});
  final HomeController controller = Get.put(HomeController());
  final PlacesController placesController = Get.put(PlacesController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start, // Align error to left
            children: [
              CustomTextField(
                hintText: 'Search for restaurants...',
                fillColor: white,
                borderRadius: 20,
                controller: controller.searchController,
                onChanged: (value) {
                  controller.errorMessage.value = ""; // Clear error when typing
                },
              ),
              Obx(() => controller.errorMessage.value.isNotEmpty
                  ? Padding(
                      padding: const EdgeInsets.only(top: 5.0, left: 5.0),
                      child: Text(
                        controller.errorMessage.value,
                        style: TextStyle(color: Colors.red, fontSize: 14),
                      ),
                    )
                  : SizedBox()), // Show error message if exists
              SizedBox(height: 20),
              Obx(() => Column(
                    children: [
                      ListTile(
                        title: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 30.0),
                          child: Container(
                            height: 30,
                            decoration: BoxDecoration(
                              color: blackColor,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Center(
                              child: Text(
                                "Google Api",
                                style: btnTextCustom,
                              ),
                            ),
                          ),
                        ),
                        leading: Radio<String>(
                          value: "Option 1",
                          groupValue: controller.selectedOption.value,
                          onChanged: (value) {
                            controller.setSelected(value!);
                          },
                        ),
                      ),
                      ListTile(
                        title: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 30.0),
                          child: Container(
                            height: 30,
                            decoration: BoxDecoration(
                              color: blackColor,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Center(
                              child: Text(
                                "Yelp Api",
                                style: btnTextCustom,
                              ),
                            ),
                          ),
                        ),
                        leading: Radio<String>(
                          value: "Option 2",
                          groupValue: controller.selectedOption.value,
                          onChanged: (value) {
                            controller.setSelected(value!);
                          },
                        ),
                      ),
                    ],
                  )),
              SizedBox(height: 20),
              Center(
                child: Obx(
                  () => controller.isLoading.value
                      ? CircularProgressIndicator() // Show loading when isLoading is true
                      : CustomButton(
                          btnText: 'Search',
                          onTap: () {
                            if(controller.searchController.text.isEmpty){
                              controller.errorMessage.value = "Please enter the city name";
                            } else if(controller.selectedOption.value == "Option 1" ){
                              placesController.fetchRestaurants(controller.searchController.text);
                              Get.to(RestaurantListScreen());
                            } else{
                              placesController.fetchBusinessesGoogle(controller.searchController.text);
                              Get.to(RestaurantListScreen());
                            }
                            // placesController.fetchRestaurants(controller.searchController.text);
                            // Get.to(RestaurantListScreen());
                            /* if (selectedOption.value == "Option 1") {
        // Google API Call
        print("Searching restaurants in: $query using Google API");
        var results = await model.name;

        if (results.isNotEmpty) {
          print("Found ${results} Restaurants");
          Get.put(PlacesController()).fetchRestaurants(query);
          Get.to(() => RestaurantListScreen(), arguments: results);
        } else {
          errorMessage.value = "No restaurants found in Google API";
          print("No results found!");
        }
      } else {
        // Yelp API Call
        print("Searching restaurants in: $query using Yelp API");
        var results = await _yelpService.fetchBusinesses(query);

        if (results.isNotEmpty) {
          print("Found ${results.length} Restaurants from Yelp");
          Get.put(PlacesController()).fetchBusinessesGoogle(query);
          Get.to(() => RestaurantListScreen(), arguments: results);
        } else {
          errorMessage.value = "No restaurants found in Yelp API";
          print("No results found!");
        }*/
                            // controller.search(controller.searchController.text);
                          },
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
