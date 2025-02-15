import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:savrly_data_entry_app/screens/restaurants/restaurant_detail_screen/restaurant_detail_screen.dart';

import '../../constants/app_colors.dart';
import '../../constants/text_styles.dart';
import 'controller/restaurant_list_controller.dart';

class RestaurantListScreen extends StatelessWidget {
  final RestaurantListController controller =
      Get.put(RestaurantListController());

  @override
  Widget build(BuildContext context) {
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Obx(
          () => ListView.builder(
            itemCount: controller.restaurants.length,
            itemBuilder: (context, index) {
              final restaurant = controller.restaurants[index];
              return GestureDetector(
                onTap: () {
                  PersistentNavBarNavigator.pushNewScreen(
                    context,
                    screen: RestaurantScreen(),
                    withNavBar: true,
                    pageTransitionAnimation: PageTransitionAnimation.cupertino,
                  );
                },
                child: Card(
                  margin: EdgeInsets.symmetric(vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(16)),
                        child: Image.asset(
                          restaurant.imageUrl,
                          height: 150,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              restaurant.name,
                              style: subHeadingText,
                            ),
                            SizedBox(height: 5),
                            Text(restaurant.address, style: hintText),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
      floatingActionButton: SizedBox(
        height: 40,
        child: FloatingActionButton.extended(
          backgroundColor: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(40),
          ),
          onPressed: () {
            Get.snackbar("Saved", "All restaurants have been saved!",
                snackPosition: SnackPosition.TOP);
          },
          label: Text("    Save All    ",
              style: simpleText.copyWith(color: white)),
        ),
      ),
    );
  }
}
