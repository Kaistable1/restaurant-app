import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:savrly/constants/text_styles.dart';

import '../../constants/app_colors.dart';
import '../../controllers/drawer_controller.dart';
import '../../controllers/restaurant_management_controller.dart';
import '../../widgets/CustomDropDownWidget.dart';
import '../../widgets/button.dart';
import '../../widgets/custom_textfield.dart';
import '../../widgets/customheader_widget.dart';

class RestaurantManagementScreen extends StatelessWidget {
  RestaurantManagementScreen({super.key});

  final drawerController = Get.put(DrawerControllerX());

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(RestaurantManagementController());
    double screenWidth = MediaQuery.of(context).size.width;
    bool mobileView = screenWidth < 900;

    // Responsive padding logic
    double paddingValue = mobileView ? 16 : 24;
    double tableTextSize = mobileView ? 9 : 14;
    double buttonTextSize = mobileView ? 11 : 16;
    double tableHeaderTextSize = mobileView ? 12 : 20;
    double imageSize = mobileView ? 30 : 50;
    double popUpContainerSize = mobileView ? 20 : 36;
    double popUpSize = mobileView ? 12 : 18;
    double statusSize = mobileView ? 60 : 100;

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
            title: 'Restaurant  Management',
            end: true,
            endWidget: CustomButton(
              laBelText: 'Add Restaurant',
              isPrefixIcon: true,
              iconWidget: Icon(Icons.add_circle_outline_sharp, color: white),
              fontSize: buttonTextSize,
              width: mobileView ? 150 : 200,
              shadow: [],
              containerColor: primaryColor,
              ontapp: () {
                drawerController.addRestaurants.value = true;
              },
            ),
          ),
          SizedBox(height: 30),
          mobileView
              ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomTextField(
                    controller: controller.searchController,
                    hintText: 'Search',
                    borderColor: primaryColor,
                    hintTextColor: primaryColor,
                    prefixIcon: Icon(Icons.search, color: primaryColor),
                  ),
                  SizedBox(height: 16),
                  CustomDropDownWidget(
                    hint: 'Filter by City',
                    items: controller.cityList,
                    onChanged:
                        (value) => controller.selectedCity.value = value!,
                  ),
                  SizedBox(height: 16),
                  CustomDropDownWidget(
                    hint: 'Filter by Cuisine',
                    items: controller.cuisineList,
                    onChanged:
                        (value) => controller.selectedCuisine.value = value!,
                  ),
                ],
              )
              : Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: CustomDropDownWidget(
                      hint: 'Filter by City',
                      items: controller.cityList,
                      onChanged:
                          (value) => controller.selectedCity.value = value!,
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    flex: 2,
                    child: CustomDropDownWidget(
                      hint: 'Filter by Cuisine',
                      items: controller.cuisineList,
                      onChanged:
                          (value) => controller.selectedCuisine.value = value!,
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    flex: 2,
                    child: CustomTextField(
                      controller: controller.searchController,
                      hintText: 'Search',
                      borderColor: primaryColor,
                      hintTextColor: primaryColor,
                      prefixIcon: Icon(Icons.search, color: primaryColor),
                    ),
                  ),
                ],
              ),
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
                    padding: EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                    color: primaryColor,
                    child: Row(
                      children: [
                        SizedBox(
                          width: 60,
                          child: Center(
                            child: Text(
                              "Photo",
                              style: simpleText.copyWith(
                                fontSize: tableHeaderTextSize,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Center(
                            child: Text(
                              "Restaurant Name",
                              textAlign: TextAlign.center,
                              style: simpleText.copyWith(
                                fontSize: tableHeaderTextSize,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Center(
                            child: Text(
                              "Cuisine",
                              textAlign: TextAlign.center,
                              style: simpleText.copyWith(
                                fontSize: tableHeaderTextSize,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Center(
                            child: Text(
                              "City",
                              textAlign: TextAlign.center,
                              style: simpleText.copyWith(
                                fontSize: tableHeaderTextSize,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Center(
                            child: Text(
                              "Phone",
                              textAlign: TextAlign.center,
                              style: simpleText.copyWith(
                                fontSize: tableHeaderTextSize,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Center(
                            child: Text(
                              "Status",
                              textAlign: TextAlign.center,
                              style: simpleText.copyWith(
                                fontSize: tableHeaderTextSize,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 50),
                      ],
                    ),
                  ),

                  // Scrollable rows
                  Expanded(
                    child: Obx(
                      () => SingleChildScrollView(
                        child: Column(
                          children: List.generate(
                            controller.restaurants.length,
                            (index) {
                              final user = controller.restaurants[index];
                              return Container(
                                padding: EdgeInsets.symmetric(
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
                                    Center(
                                      child: Container(
                                        height: imageSize,
                                        width: imageSize,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                          image: DecorationImage(
                                            image: AssetImage(user.photoUrl),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Center(
                                        child: Text(
                                          user.name,
                                          textAlign: TextAlign.center,
                                          style: simpleText.copyWith(
                                            fontSize: tableTextSize,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Center(
                                        child: Text(
                                          user.cuisine,
                                          textAlign: TextAlign.center,
                                          style: simpleText.copyWith(
                                            fontSize: tableTextSize,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Center(
                                        child: Text(
                                          user.city,
                                          textAlign: TextAlign.center,
                                          style: simpleText.copyWith(
                                            fontSize: tableTextSize,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Center(
                                        child: Text(
                                          user.phone,
                                          textAlign: TextAlign.center,
                                          style: simpleText.copyWith(
                                            fontSize: tableTextSize,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Center(
                                        child: Container(
                                          width: statusSize,
                                          padding: EdgeInsets.symmetric(
                                            vertical: 6,
                                            horizontal: 8,
                                          ),
                                          decoration: BoxDecoration(
                                            color:
                                                user.status == "Pending"
                                                    ? Colors.red
                                                    : primaryColor,
                                            borderRadius: BorderRadius.circular(
                                              6,
                                            ),
                                          ),
                                          child: Text(
                                            user.status,
                                            textAlign: TextAlign.center,
                                            style: simpleText.copyWith(
                                              fontSize: tableTextSize,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      height: popUpContainerSize,
                                      width: popUpContainerSize,
                                      margin: EdgeInsets.symmetric(
                                        horizontal: 4,
                                      ),
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
                                            if (value == 'delete') {
                                              controller.deleteRestaurant(
                                                index,
                                              );
                                            } else if (value == 'view') {
                                              drawerController
                                                  .viewRestaurantsDetails
                                                  .value = true;
                                            } else if (value == 'edit') {}
                                          },
                                          itemBuilder:
                                              (context) => [
                                                PopupMenuItem(
                                                  value: 'view',
                                                  child: Text('View'),
                                                ),
                                                PopupMenuItem(
                                                  value: 'edit',
                                                  child: Text('Edit'),
                                                ),
                                                PopupMenuItem(
                                                  value: 'delete',
                                                  child: Text('Delete'),
                                                ),
                                              ],
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
