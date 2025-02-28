import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:savrly_data_entry_app/screens/home/controller/home_controller.dart';
import 'package:savrly_data_entry_app/screens/restaurants/restaurant_detail_screen/restaurant_detail_screen.dart';

import '../../constants/app_colors.dart';
import '../../constants/text_styles.dart';
import 'controller/restaurant_list_controller.dart';

class RestaurantListScreen extends StatelessWidget {
  // final RestaurantListController controller = Get.put(RestaurantListController());
  final PlacesController placesController = Get.put(PlacesController());

  @override
  Widget build(BuildContext context) {
    // Get the selected API from arguments
    // var selectedApi = Get.arguments['selectedApi']; // 'google' or 'yelp'

    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        backgroundColor: white,
        title: Text(
          'List of restaurants',
          textAlign: TextAlign.center,
          style: headingText,
        ),
        centerTitle: true,
        leading: Icon(Icons.home, color: blackColor, size: 30),
      ),
      body: Obx(
        () => Get.put(HomeController()).selectedOption.value == "Option 1"
            ? Padding(
                padding: const EdgeInsets.all(16.0),
                child: Obx(() {
                  if (placesController.isLoading.value) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (placesController.businessList.isEmpty) {
                    return Center(child: Text("No restaurants found"));
                  }

                  return ListView.builder(
                    itemCount: placesController.businessList.length,
                    itemBuilder: (context, index) {
                      final business = placesController.businessList[index];
                      return ListTile(
                        leading: Image.network(
                          business.icon,
                          width: 40,
                          height: 40,
                          errorBuilder: (context, error, stackTrace) =>
                              Icon(Icons.image),
                        ),
                        onTap: () {
                          // Get.defaultDialog(title: '${business.}');
                        },
                        title: Text(business.name),
                        subtitle: Text(business.formattedAddress),
                        trailing: Text("⭐ ${business.rating}"),
                      );
                    },
                  );
                }),
              )
            : Obx(() {
                if (placesController.isGoogleLoading.value) {
                  return Center(child: CircularProgressIndicator());
                }
                if (placesController.businessListGoogle.isEmpty) {
                  return Center(child: Text("No businesses found"));
                }

                return ListView.builder(
                  itemCount: placesController.businessListGoogle.length,
                  itemBuilder: (context, index) {
                    final business = placesController.businessListGoogle[index];
                    return Card(
                      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      child: ListTile(
                        leading: Image.network(
                          business.imageUrl,
                          width: 60,
                          height: 60,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              Icon(Icons.image),
                        ),
                        title: Text(business.name),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(business.address),
                            Text(
                                "⭐ ${business.rating} (${business.reviewCount} reviews)"),
                            Text(
                                "📍 ${business.latitude}, ${business.longitude}"),
                            Text("💵 ${business.price}"),
                            Text(business.isOpenNow ? "🟢 Open" : "🔴 Closed"),
                          ],
                        ),
                        trailing: Icon(Icons.arrow_forward_ios),
                        onTap: () {
                          Get.snackbar(
                            business.name,
                            "More details at Yelp!",
                            snackPosition: SnackPosition.BOTTOM,
                          );
                        },
                      ),
                    );
                  },
                );
              }),
      ),
      floatingActionButton: SizedBox(
        height: 40,
        child: FloatingActionButton.extended(
          backgroundColor: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(40),
          ),
          onPressed: () {
            showSuccessDialog(
                context, "Lahore"); // City name dynamic pass karein

            // if(Get.put(HomeController()).selectedOption.value == "Option 2"){
            //   print("Yelp");
            //   FirebaseFirestore.instance.collection("Restaurants").add({
            //     "restaurants": placesController.businessListGoogle.map((business) => business).toList()
            //   });
            //
            // }else{
            //   print("Google");
            //   FirebaseFirestore.instance.collection("Restaurants").add({
            //     "restaurants": placesController.businessList.map((business) => business.toJson()).toList()
            //   });
            // }
          },
          label: Text("    Save All    ",
              style: simpleText.copyWith(color: white)),
        ),
      ),
    );
  }
}

void showSuccessDialog(BuildContext context, String cityName) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: Text("Success",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
        content: Text(
            "Restaurant data has been successfully added to Firebase.\n\nCity: $cityName"),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text("OK", style: TextStyle(color: Colors.black,fontSize: 13)),
          ),
        ],
      );
    },
  );
}
