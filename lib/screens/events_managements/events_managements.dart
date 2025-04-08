import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../constants/app_colors.dart';
import '../../constants/text_styles.dart';
import '../../controllers/drawer_controller.dart';
import '../../controllers/event_management_controller.dart';
import '../../widgets/CustomDropDownWidget.dart';
import '../../widgets/button.dart';
import '../../widgets/custom_textfield.dart';
import '../../widgets/customheader_widget.dart';
class EventsManagements extends StatelessWidget {
  final controller =Get.put(EventManagementController());
  final drawerController =Get.put(DrawerControllerX());
   EventsManagements({super.key});

  @override
  Widget build(BuildContext context) {
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
            title: 'Event management',
            end: true,
            endWidget: CustomButton(
              laBelText: 'Add Event',
              isPrefixIcon: true,
              iconWidget: Icon(Icons.add_circle_outline_sharp, color: white),
              fontSize: buttonTextSize,
              width: mobileView ? 150 : 200,
              shadow: [],
              containerColor: primaryColor,
              ontapp: () {
            drawerController..addEvent.value = true;
              },
            ),
          ),
          SizedBox(height: 30),
          mobileView?
              Column(
                children: [
                  CustomDropDownWidget(
                    hint: 'State',
                    items: controller.stateList,
                    onChanged:
                        (value) => controller.selectedState.value = value!,
                  ),
                  SizedBox(height: 8),
                  CustomDropDownWidget(
                    hint: 'City',
                    items: controller.cityList,
                    onChanged:
                        (value) => controller.selectedCity.value = value!,
                  ),
                  SizedBox(height: 8),

                  CustomDropDownWidget(
                    hint: 'Event type',
                    items: controller.eventsList,
                    onChanged:
                        (value) => controller.selectedEvents.value = value!,
                  ),
                  SizedBox(height: 8),
                  CustomTextField(
                    controller: controller.searchController,
                    hintText: 'Search',
                    borderColor: primaryColor,
                    hintTextColor: primaryColor,
                    prefixIcon: Icon(Icons.search, color: primaryColor),
                  ),
                ],
              ):
          Row(
            children: [
              Expanded(
                flex: 2,
                child: CustomDropDownWidget(
                  hint: 'State',
                  items: controller.stateList,
                  onChanged:
                      (value) => controller.selectedState.value = value!,
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                flex: 2,
                child: CustomDropDownWidget(
                  hint: 'City',
                  items: controller.cityList,
                  onChanged:
                      (value) => controller.selectedCity.value = value!,
                ),
              ),
              SizedBox(width: 16),

              Expanded(
                flex: 2,
                child: CustomDropDownWidget(
                  hint: 'Event type',
                  items: controller.eventsList,
                  onChanged:
                      (value) => controller.selectedEvents.value = value!,
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
          SizedBox(height: 22,),

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
                    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
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
                              "Event name",
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
                          flex: 1,
                          child: Center(
                            child: Text(
                              "Location",
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
                              "Event type",
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
                              "Date",
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
                        Expanded(
                          flex: 2,
                          child: Center(
                            child: Text(
                              "Time",
                              textAlign: TextAlign.center,
                              style: simpleText.copyWith(
                                fontSize: tableHeaderTextSize,
                                fontWeight: FontWeight.w700,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
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
                            controller.restaurants.length,
                                (index) {
                              final user = controller.restaurants[index];
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
                                            borderRadius: BorderRadius.circular(8),
                                            image: DecorationImage(
                                              image: AssetImage(user.photoUrl),
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
                                          user.eventsName,
                                          textAlign: TextAlign.center,
                                          style: simpleText.copyWith(
                                            fontSize: tableTextSize,
                                          ),
                                        ),
                                      ),
                                    ),
                                    // Location column
                                    Expanded(
                                      flex: 1,
                                      child: Center(
                                        child: Text(
                                          user.location,
                                          textAlign: TextAlign.center,
                                          style: simpleText.copyWith(
                                            fontSize: tableTextSize,
                                          ),
                                        ),
                                      ),
                                    ),
                                    // Event type column
                                    Expanded(
                                      flex: 2, // Adjusted to match the header flex
                                      child: Center(
                                        child: Text(
                                          user.eventType,
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
                                          user.date,
                                          textAlign: TextAlign.center,
                                          style: simpleText.copyWith(
                                            fontSize: tableTextSize,
                                          ),
                                        ),
                                      ),
                                    ),
                                    // Time column
                                    Expanded(
                                      flex: 2,
                                      child: Center(
                                        child: Text(
                                          user.time,
                                          textAlign: TextAlign.center,
                                          style: simpleText.copyWith(
                                            fontSize: tableTextSize,
                                          ),
                                        ),
                                      ),
                                    ),
                                    // Status column
                                    Expanded(
                                      flex: 1,
                                      child: Center(
                                        child: Text(
                                          user.status,
                                          textAlign: TextAlign.center,
                                          style: simpleText.copyWith(
                                            fontSize: tableTextSize,
                                            color: user.status == "Pending" ? Colors.red : primaryColor,
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
                                          margin: const EdgeInsets.symmetric(horizontal: 4),
                                          decoration: BoxDecoration(
                                            color: primaryColor,
                                            borderRadius: BorderRadius.circular(
                                              mobileView ? 5 :  10,
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
                                                  controller.deleteRestaurant(index);
                                                }
                                                if(value=='View'){
                                                  drawerController.viewEvents.value=true;
                                                }
                                                if(value=='Edit'){
                                                  drawerController..addEvent.value = true;
                                                }
                                              },
                                              itemBuilder: (context) => [
                                                const PopupMenuItem(
                                                  value: 'View',
                                                  child: Text('View'),
                                                ),
                                                const PopupMenuItem(
                                                  value: 'Edit',
                                                  child: Text('Edit'),
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
