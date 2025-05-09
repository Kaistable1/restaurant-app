import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:savrly/widgets/custom_textfield.dart';

import '../../constants/app_colors.dart';
import '../../constants/text_styles.dart';
import '../../controllers/drawer_controller.dart';
import '../../controllers/restaurants_claims_controller.dart';
import '../../widgets/customheader_widget.dart';

class RestaurantsClaimsScreen extends StatelessWidget {
  final controller = Get.put(RestaurantsClaimsController());
  final drawerController = Get.put(DrawerControllerX());

  RestaurantsClaimsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    bool mobileView = screenWidth < 900;
    // Responsive padding logic
    double paddingValue = mobileView ? 16 : 24;
    double tableTextSize = mobileView ? 9 : 14;
    double tableHeaderTextSize = mobileView ? 12 : 20;
    double imageSize = mobileView ? 30 : 50;
    double popUpContainerSize = mobileView ? 20 : 36;
    double popUpSize = mobileView ? 12 : 18;
    TextEditingController searchController = TextEditingController();
    return Padding(
      padding: EdgeInsets.only(
        right: paddingValue,
        top: paddingValue,
        left: paddingValue,
        bottom: paddingValue,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomHeaderWidget(
              title: 'Restaurant claims',
              end: true,
              endWidget: SizedBox(
                width: mobileView ? 200 : 279,
                height: mobileView ? 40 : 48,
                child: CustomTextField(
                  prefixIcon: Icon(Icons.search, color: primaryColor),
                  hintText: 'Search ',
                  controller: searchController,
                  hintTextColor: primaryColor,
                  borderColor: primaryColor,
                  onChanged: (v) {
                    controller.filteredClaims(search: v);
                    return null;
                  },
                ),
              )),
          SizedBox(height: 30),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: dimWhite.withOpacity(0.4),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Column(
                children: [
                  // Header
                  Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 16, horizontal: 12),
                    color: primaryColor,
                    child: Row(
                      children: [
                        // Photo column (fixed width)
                        SizedBox(
                          width: 60, // Match the width used in the list items
                          child: Center(
                            child: Text(
                              "Photo",
                              style: simpleText.copyWith(
                                fontSize: tableHeaderTextSize,
                                fontWeight: FontWeight.w700,
                                color: Colors.black,
                                // Ensure text is visible on primaryColor background
                              ),
                            ),
                          ),
                        ),
                        // Event name column
                        Expanded(
                          flex: 2,
                          child: Center(
                            child: Text(
                              "Restaurant name",
                              textAlign: TextAlign.center,
                              style: simpleText.copyWith(
                                fontSize: tableHeaderTextSize,
                                fontWeight: FontWeight.w700,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                        // Location column
                        Expanded(
                          flex: 2,
                          child: Center(
                            child: Text(
                              "Owner name",
                              textAlign: TextAlign.center,
                              style: simpleText.copyWith(
                                fontSize: tableHeaderTextSize,
                                fontWeight: FontWeight.w700,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                        // Event type column
                        Expanded(
                          flex: 2, // Adjusted to match the list item flex
                          child: Center(
                            child: Text(
                              "Email",
                              textAlign: TextAlign.center,
                              style: simpleText.copyWith(
                                fontSize: tableHeaderTextSize,
                                fontWeight: FontWeight.w700,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                        // Date column
                        Expanded(
                          flex: 2,
                          child: Center(
                            child: Text(
                              "Message",
                              textAlign: TextAlign.center,
                              style: simpleText.copyWith(
                                fontSize: tableHeaderTextSize,
                                fontWeight: FontWeight.w700,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                        // Time column

                        // Status column
                        Expanded(
                          flex: 1,
                          child: Center(
                            child: Text(
                              "Status",
                              textAlign: TextAlign.center,
                              style: simpleText.copyWith(
                                fontSize: tableHeaderTextSize,
                                fontWeight: FontWeight.w700,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                        // Action column (for the PopupMenuButton)
                        SizedBox(
                          width: 50, // Match the width used in the list items
                          child: Center(
                            child: Text(
                              "", // Empty text to reserve space for alignment
                              style: simpleText.copyWith(
                                fontSize: tableHeaderTextSize,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Scrollable rows
                  Expanded(
                    child: Obx(
                      () => SingleChildScrollView(
                        child: Column(
                          children: List.generate(
                            searchController.text.isEmpty
                                ? controller.restaurantsClaims.length
                                : controller.filteredClaimsRestaurants.length,
                            (index) {
                              final user = controller
                                      .filteredClaimsRestaurants.isEmpty
                                  ? controller.restaurantsClaims[index]
                                  : controller.filteredClaimsRestaurants[index];
                              return Container(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 14,
                                  horizontal: 12,
                                ),
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                      color: primaryColor,
                                      width: 0.3,
                                    ),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    // Photo column (fixed width)
                                    SizedBox(
                                      width: 60, // Match the header width
                                      child: Center(
                                        child: Container(
                                          height: imageSize,
                                          width: imageSize,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            image: DecorationImage(
                                              image:
                                                  NetworkImage(user.photoUrl),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    // Event name column
                                    Expanded(
                                      flex: 2,
                                      child: Center(
                                        child: Text(
                                          user.restaurantsName,
                                          textAlign: TextAlign.center,
                                          style: simpleText.copyWith(
                                            fontSize: tableTextSize,
                                          ),
                                        ),
                                      ),
                                    ),
                                    // Location column
                                    Expanded(
                                      flex: 2,
                                      child: Center(
                                        child: Text(
                                          user.ownerName,
                                          textAlign: TextAlign.center,
                                          style: simpleText.copyWith(
                                            fontSize: tableTextSize,
                                          ),
                                        ),
                                      ),
                                    ),
                                    // Event type column
                                    Expanded(
                                      flex:
                                          2, // Adjusted to match the header flex
                                      child: Center(
                                        child: Text(
                                          user.email,
                                          textAlign: TextAlign.center,
                                          style: simpleText.copyWith(
                                            fontSize: tableTextSize,
                                          ),
                                        ),
                                      ),
                                    ),
                                    // Date column
                                    Expanded(
                                      flex: 2,
                                      child: Center(
                                        child: Text(
                                          user.message,
                                          textAlign: TextAlign.center,
                                          style: simpleText.copyWith(
                                            fontSize: tableTextSize,
                                          ),
                                        ),
                                      ),
                                    ),
                                    // Time column

                                    // Status column
                                    Expanded(
                                      flex: 1,
                                      child: Center(
                                        child: Text(
                                          user.status,
                                          textAlign: TextAlign.center,
                                          style: simpleText.copyWith(
                                            fontSize: tableTextSize,
                                            color: user.status == "Pending"
                                                ? Colors.red
                                                : primaryColor,
                                          ),
                                        ),
                                      ),
                                    ),
                                    // Action column (PopupMenuButton)
                                    SizedBox(
                                      width: 50, // Match the header width
                                      child: Center(
                                        child: Container(
                                          height: popUpContainerSize,
                                          width: popUpContainerSize,
                                          margin: const EdgeInsets.symmetric(
                                              horizontal: 4),
                                          decoration: BoxDecoration(
                                            color: primaryColor,
                                            borderRadius: BorderRadius.circular(
                                              mobileView ? 5 : 10,
                                            ),
                                          ),
                                          child: Center(
                                            child: PopupMenuButton<String>(
                                              padding: EdgeInsets.zero,
                                              icon: Icon(
                                                Icons.more_vert,
                                                color: Colors.white,
                                                size: popUpSize,
                                              ),
                                              onSelected: (value) {
                                                if (value == 'Delete') {
                                                  controller
                                                      .deleteBusinessClaim(
                                                          user.id);
                                                }
                                                if (value == 'View') {
                                                  controller.viewClaimsDetails =
                                                      user;
                                                  controller.update();
                                                  drawerController
                                                      .viewClaimsDetails
                                                      .value = true;
                                                }
                                              },
                                              itemBuilder: (context) => [
                                                const PopupMenuItem(
                                                  value: 'View',
                                                  child: Text('View'),
                                                ),
                                                const PopupMenuItem(
                                                  value: 'Delete',
                                                  child: Text('Delete'),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
