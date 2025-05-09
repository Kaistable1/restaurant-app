import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:savrly/constants/text_styles.dart';
import 'package:savrly/controllers/add_restaurants_controller.dart';
import 'package:savrly/controllers/edit_restaurant_controller.dart';
import 'package:savrly/models/resaturant_model.dart';
import '../../constants/app_colors.dart';
import '../../controllers/drawer_controller.dart';
import '../../controllers/restaurant_management_controller.dart';
import '../../widgets/CustomDropDownWidget.dart';
import '../../widgets/button.dart';
import '../../widgets/custom_textfield.dart';
import '../../widgets/customheader_widget.dart';
import 'dialoge/featured_dialoge.dart';

class RestaurantManagementScreen extends StatefulWidget {
  const RestaurantManagementScreen({super.key});

  @override
  State<RestaurantManagementScreen> createState() =>
      _RestaurantManagementScreenState();
}

class _RestaurantManagementScreenState
    extends State<RestaurantManagementScreen> {
  final drawerController = Get.put(DrawerControllerX());
  final controller = Get.put(RestaurantManagementController());
  final addController = Get.put(AddRestaurantTabController());
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        if (controller.hasMoreData.value && !controller.isLoading.value) {
          controller.fetchRestaurants();
        }
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  // Method to clear all filters
  void clearFilters() {
    controller.searchController.clear();
    controller.selectedCity.value = '';
    controller.selectedCuisine.value = '';
    controller.currentSearchQuery.value = '';
    controller.currentCityFilter.value = '';
    controller.currentCuisineFilter.value = '';
    controller.filteredResults.clear();
    controller.fetchRestaurants(isRefresh: true);
  }

  @override
  Widget build(BuildContext context) {
    clearFilters();
    double screenWidth = MediaQuery.of(context).size.width;
    bool mobileView = screenWidth < 1000;

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
            title: 'Restaurant Management',
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
                addController.restaurantModel = null;
                addController.clearFields();
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
                      onChanged: (value) {
                        // Trigger search logic when search text changes
                        controller.currentSearchQuery.value = value ?? '';
                        if (value == null || value.isEmpty) {
                          controller.filteredResults.clear();
                          controller.fetchRestaurants(isRefresh: true);
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16),
                    CustomDropDownWidget(
                      hint: 'Filter by City',
                      items: controller.cityList,
                      onChanged: (value) {
                        controller.selectedCity.value = value!;
                        controller.currentCityFilter.value = value;
                        if (value.isEmpty || value == 'All') {
                          controller.filteredResults.clear();
                          controller.fetchRestaurants(isRefresh: true);
                        }
                      },
                    ),
                    SizedBox(height: 16),
                    CustomDropDownWidget(
                      hint: 'Filter by Cuisine',
                      items: controller.cuisineList,
                      onChanged: (value) {
                        controller.selectedCuisine.value = value!;
                        controller.currentCuisineFilter.value = value;

                        if (value.isEmpty || value == 'All') {
                          controller.filteredResults.clear();
                          controller.fetchRestaurants(isRefresh: true);
                        }
                      },
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
                        onChanged: (value) {
                          controller.selectedCity.value = value!;
                          controller.currentCityFilter.value = value;

                          if (value.isEmpty || value == 'All') {
                            controller.filteredResults.clear();
                            controller.fetchRestaurants(isRefresh: true);
                          }
                        },
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      flex: 2,
                      child: CustomDropDownWidget(
                        hint: 'Filter by Cuisine',
                        items: controller.cuisineList,
                        onChanged: (value) {
                          controller.selectedCuisine.value = value!;
                          controller.currentCuisineFilter.value = value;

                          if (value.isEmpty || value == 'All') {
                            controller.filteredResults.clear();
                            controller.fetchRestaurants(isRefresh: true);
                          }
                        },
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
                        onChanged: (value) {
                          // Trigger search logic when search text changes
                          controller.currentSearchQuery.value = value ?? '';
                          if (value == null || value.isEmpty) {
                            controller.filteredResults.clear();
                            controller.fetchRestaurants(isRefresh: true);
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
          SizedBox(height: 10),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: dimWhite.withOpacity(0.4),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Column(
                children: [
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
                              "Email",
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
                              "Featured",
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
                  Expanded(
                    child: Obx(
                      () => ListView.builder(
                        controller: _scrollController,
                        itemCount: controller.restaurants.length + 1,
                        itemBuilder: (context, index) {
                          if (index == controller.restaurants.length) {
                            if (controller.hasMoreData.value) {
                              return Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Center(
                                  child: controller.isLoading.value
                                      ? SizedBox(
                                          height: Get.height * 0.4,
                                          child: Center(
                                            child: CircularProgressIndicator(
                                              color: primaryColor,
                                            ),
                                          ),
                                        )
                                      : Text(
                                          'Load More',
                                          style: simpleText.copyWith(
                                            fontSize: tableTextSize,
                                            color: primaryColor,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                ),
                              );
                            } else {
                              return Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Center(
                                  child: Text(
                                    'No more restaurants to load',
                                    style: simpleText.copyWith(
                                      fontSize: tableTextSize,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                              );
                            }
                          }

                          final restaurant = controller.restaurants[index];
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
                                      borderRadius: BorderRadius.circular(8),
                                      image: restaurant.logoImage.isNotEmpty
                                          ? DecorationImage(
                                              image: NetworkImage(
                                                  restaurant.logoImage),
                                              fit: BoxFit.cover,
                                            )
                                          : null,
                                      color: restaurant.logoImage.isEmpty
                                          ? Colors.grey.shade300
                                          : null,
                                    ),
                                    child: restaurant.logoImage.isEmpty
                                        ? Icon(
                                            Icons.restaurant,
                                            color: Colors.grey.shade600,
                                            size: imageSize * 0.6,
                                          )
                                        : null,
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Center(
                                    child: Text(
                                      restaurant.resName,
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
                                      restaurant.menuList.isEmpty
                                          ? 'No Cuisine'
                                          : restaurant.menuList[0].cuisineType,
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
                                      restaurant.city,
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
                                      restaurant.resEmail == ''
                                          ? '${restaurant.resName.toLowerCase().toString().split(' ')[0]}@gmail.com'
                                          : restaurant.resEmail,
                                      textAlign: TextAlign.center,
                                      style: simpleText.copyWith(
                                        fontSize: tableTextSize,
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: StreamBuilder<Map<String, dynamic>?>(
                                    stream:
                                        controller.getFeaturedRestaurantID(),
                                    builder: (context, snapshot) {
                                      // Show loading state
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return CircleCheckbox(
                                          onChanged: (v) async {},
                                          value: false,
                                        );
                                      }

                                      // Handle error state
                                      if (snapshot.hasError) {
                                        return CircleCheckbox(
                                          onChanged: (v) async {},
                                          value: false,
                                        );
                                      }

                                      // Check if data exists and match restaurant ID
                                      final data = snapshot.data;
                                      final isFeatured = data != null &&
                                          data['restaurantID'] ==
                                              restaurant.docID;
                                      final currentDescription = data != null
                                          ? data['description'] as String?
                                          : '';

                                      return CircleCheckbox(
                                        onChanged: (v) async {
                                          // Show the dialog
                                          await showDialog(
                                            context: context,
                                            builder:
                                                (BuildContext dialogContext) {
                                              return FeatureDescriptionDialog(
                                                initialDescription:
                                                    currentDescription ?? '',
                                                onSubmit: (description) async {
                                                  try {
                                                    // Perform the Firestore update
                                                    await controller
                                                        .setFeaturedRestaurant(
                                                      restaurantID:
                                                          restaurant.docID,
                                                      description: description,
                                                    );
                                                    // Check if the widget is still mounted before showing SnackBar
                                                    if (context.mounted) {
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(
                                                        SnackBar(
                                                          content: Text(
                                                            'Featured restaurant updated successfully!',
                                                            style: simpleText
                                                                .copyWith(
                                                                    color: Colors
                                                                        .white),
                                                          ),
                                                          backgroundColor:
                                                              primaryColor,
                                                        ),
                                                      );
                                                    }
                                                  } catch (e) {
                                                    // Check if the widget is still mounted before showing error SnackBar
                                                    if (context.mounted) {
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(
                                                        SnackBar(
                                                          content: Text(
                                                              'Failed to update featured restaurant'),
                                                          backgroundColor:
                                                              Colors.red,
                                                        ),
                                                      );
                                                    }
                                                  }
                                                },
                                                onCancel: () {
                                                  setState(() {});
                                                },
                                              );
                                            },
                                          );
                                        },
                                        value: isFeatured,
                                      );
                                    },
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
                                        color: restaurant.resEmail == '' &&
                                                restaurant.dietaryList.isEmpty
                                            ? Colors.red
                                            : primaryColor,
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Text(
                                        restaurant.resEmail == '' &&
                                                restaurant.dietaryList.isEmpty
                                            ? 'Pending'
                                            : 'Registered',
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
                                      onSelected: (value) async {
                                        if (value == 'delete') {
                                          controller.deleteRestaurant(index);
                                        } else if (value == 'edit') {
                                          addController.restaurantModel =
                                              restaurant;
                                          addController.isNewRegistery =
                                              restaurant.resEmail == '';
                                          controller.update();
                                          final editRestaurantController =
                                              Get.put(
                                                  EditRestaurantController());
                                          await editRestaurantController
                                              .fillAllVarsInRestManagmentController();

                                          drawerController
                                              .addRestaurants.value = true;
                                        } else {
                                          addController.restaurantModel =
                                              restaurant;
                                          controller.update();
                                          drawerController
                                              .viewRestaurantsDetails
                                              .value = true;
                                        }
                                      },
                                      itemBuilder: (context) => [
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
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CircleCheckbox extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  const CircleCheckbox({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: Container(
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          color: value ? Colors.green : Colors.transparent,
          shape: BoxShape.circle,
          border: Border.all(
            color: Colors.green,
            width: 2,
          ),
        ),
        child: value
            ? const Center(
                child: Icon(
                  Icons.check,
                  size: 16,
                  color: Colors.white,
                ),
              )
            : null,
      ),
    );
  }
}
