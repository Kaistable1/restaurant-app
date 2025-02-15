import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:savrly_data_entry_app/constants/app_colors.dart';
import 'package:savrly_data_entry_app/widgets/custom_button.dart';

import '../../../constants/text_styles.dart';
import '../restaurant_list_screen.dart';
import 'controller/restaurant_detail_controller.dart';

class RestaurantScreen extends StatelessWidget {
  final RestaurantDetailController controller =
      Get.put(RestaurantDetailController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        backgroundColor: white,
        title: Text(
          'Restaurant Details',
          textAlign: TextAlign.center,
          style: headingText,
        ),
        centerTitle: true,
        leading: GestureDetector(
          onTap: () {
            PersistentNavBarNavigator.pushNewScreen(
              context,
              screen: RestaurantListScreen(),
              withNavBar: true, // OPTIONAL VALUE. True by default.
              pageTransitionAnimation: PageTransitionAnimation.cupertino,
            );
          },
          child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(
                Icons.arrow_back_outlined,
                size: 30,
              )),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Restaurant Image & Name
            Card(
              color: white,
              elevation: 6,
              shadowColor: bdrColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: Column(
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(
                      "assets/images/img1.png",
                      width: Get.width * .85,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          controller.name,
                          style: headingText,
                        ),
                        Row(
                          children: [
                            Icon(Icons.star, color: Colors.amber, size: 18),
                            Text(
                              "${controller.rating} (${controller.reviewsCount} reviews)",
                              style: simpleText,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 12),

            // Address Section
            _buildCard(
              title: "Address",
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    controller.address,
                    style: simpleText,
                  ),
                  SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.asset("assets/images/map.png",
                        width: Get.width * .85, fit: BoxFit.cover),
                  ),
                ],
              ),
            ),

            SizedBox(height: 12),

            // Reviews Section
            // Reviews Section
            _buildCard(
              title: "Reviews",
              child: Column(
                children: List.generate(controller.reviews.length, (index) {
                  final review = controller.reviews[index];
                  return Column(
                    children: [
                      ListTile(
                        title: Row(
                          children: [
                            Text(
                              review["name"],
                              style: subHeadingText.copyWith(
                                  fontWeight: FontWeight.w900),
                            ),
                            SizedBox(width: 10),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: List.generate(
                                review["rating"].toInt(),
                                (index) => Icon(Icons.star,
                                    color: amberColor, size: 20),
                              ),
                            ),
                          ],
                        ),
                        subtitle: Text(
                          review["comment"],
                          style: simpleText,
                        ),
                      ),
                      if (index != controller.reviews.length - 1)
                        Divider(), // Divider after each comment except last
                    ],
                  );
                }),
              ),
            ),

            SizedBox(height: 12),

            // Contact Information
            _buildCard(
              title: "Contact Information",
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Phone: ${controller.phone}",
                    style: simpleText,
                  ),
                  SizedBox(height: 4),
                  RichText(
                    text: TextSpan(
                      style: simpleText, // Default style for the whole text
                      children: [
                        TextSpan(
                          text: "Email: ",
                          style: simpleText, // Normal text
                        ),
                        TextSpan(
                          text: controller.email,
                          style: simpleText.copyWith(
                            decoration: TextDecoration
                                .underline, // Underline only the email
                            color: Colors
                                .blue, // Optional: Make it look like a link
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 12),
                  CustomButton(btnText: 'Call now', onTap: () {}),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper function for reusable card sections
  Widget _buildCard({required String title, required Widget child}) {
    return Card(
      color: white,
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: headingText,
            ),
            SizedBox(height: 8),
            child,
          ],
        ),
      ),
    );
  }
}
