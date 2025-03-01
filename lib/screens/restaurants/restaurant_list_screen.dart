import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:savrly_data_entry_app/models/my_resturant.dart';
import 'package:savrly_data_entry_app/screens/home/controller/home_controller.dart';
import 'package:savrly_data_entry_app/widgets/loading.dart';

import '../../constants/app_colors.dart';
import '../../constants/text_styles.dart';

class RestaurantListScreen extends StatelessWidget {
  RestaurantListScreen({super.key, required this.cityName});
  String cityName;
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
                if (placesController.yelpAPIRestaurants.isEmpty) {
                  return Center(child: Text("No businesses found"));
                }

                return ListView.builder(
                  itemCount: placesController.yelpAPIRestaurants.length,
                  itemBuilder: (context, index) {
                    final business = placesController.yelpAPIRestaurants[index];
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
          onPressed: () async {
            loadingDialog(message: 'Please wait!', loading: true, height: 150);

            List<RestaurantModel> restuants = [];

            if (Get.put(HomeController()).selectedOption.value == "Option 2") {
              print("Yelp");
              for (var v in placesController.yelpAPIRestaurants) {
                RestaurantModel restaurantModel = await RestaurantModel(
                  about: "Coming Soon!! Stay tuned for something exciting!",
                  address: v.address.split(',').first,
                  city: v.address.split(',')[1],
                  country: v.address.split(',').last,
                  createdAt: DateTime.now(),
                  docID: '',
                  latitude: v.latitude,
                  logoImage: v.imageUrl,
                  longitude: v.longitude,
                  password: '',
                  priceRange: v.price,
                  resEmail: '',
                  resName: v.name,
                  socialLink: '',
                  socialMedia: '',
                  specialConditions:
                      "Coming Soon!! Stay tuned for something exciting!",
                  spokenLanguage: '',
                  zipCode: '',
                  facilityList: [],
                  entertainmentScheduleList: [],
                  averageRating: 0,
                  imagesList: [],
                  dietaryList: [],
                  atmopshereList: [],
                );
                restuants.add(restaurantModel);
              }
              restuants.forEach((item) => print('logo imge ${item.logoImage}'));
              await placesController.addRestaurants(restuants);

              Get.back();
              showSuccessDialog(
                  context, cityName); // City name dynamic pass karein
            } else {
              print("Google");
              for (var v in placesController.businessList) {
                RestaurantModel restaurantModel = RestaurantModel(
                  about: "Coming Soon!! Stay tuned for something exciting!",
                  address: extractSecondLastWord(v.formattedAddress),
                  city: extractSecondLastWord(v.formattedAddress),
                  country: v.formattedAddress.split(',').last.trim(),
                  createdAt: DateTime.now(),
                  docID: '',
                  latitude: v.geometry.location.lat,
                  logoImage: v.icon,
                  longitude: v.geometry.location.lng,
                  password: '',
                  priceRange: '',
                  resEmail: '',
                  resName: v.name,
                  socialLink: '',
                  socialMedia: '',
                  specialConditions:
                      "Coming Soon!! Stay tuned for something exciting!",
                  spokenLanguage: '',
                  zipCode: '',
                  facilityList: [],
                  entertainmentScheduleList: [],
                  averageRating: 0,
                  imagesList: [],
                  dietaryList: [],
                  atmopshereList: [],
                );
                restuants.add(restaurantModel);
              }
              await placesController.addRestaurants(restuants);
              Get.back();
              showSuccessDialog(
                  context, cityName); // City name dynamic pass karein
            }
          },
          label: Text("    Save All    ",
              style: simpleText.copyWith(color: white)),
        ),
      ),
    );
  }
}

String extractSecondLastWord(String address) {
  List<String> words =
      address.split(RegExp(r'\s*,\s*| ')); // Split by spaces and commas
  if (words.length >= 2) {
    return "${words[words.length - 2]} ${words.last}"; // Get second last and last word
  }
  return address; // Return full address if it has less than two words
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
            child:
                Text("OK", style: TextStyle(color: Colors.black, fontSize: 13)),
          ),
        ],
      );
    },
  );
}
