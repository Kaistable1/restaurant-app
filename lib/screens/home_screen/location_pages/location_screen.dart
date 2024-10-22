import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../../constants/app_colors.dart';
import '../../../utils/responsive.dart';
import '../../../widgets/fav_rectangle_widget.dart';
import 'location_controller/location_controller.dart';

class LocationScreen extends StatelessWidget {
  final List<String> items = [
    '10%',
    '20%',
    '30%',
    '40%',
    '50%',

  ];
  final LocationController locationController = Get.put(LocationController());
  LocationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    bool isLargeScreen = screenWidth > 1400;
    return LayoutBuilder(
      builder: (context, constraints) {
        int itemsPerRow = Responsive.isMobile(context)
            ? 2
            : Responsive.isTablet(context)
                ? 3
                : 4;
        double itemWidth = (constraints.maxWidth / itemsPerRow) - 16;
        double itemHeight = Responsive.isMobile(context)
            ? 320
            : (isLargeScreen ? 500 : 500); // Set a fixed height for items

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(
                  left: Responsive.isMobile(context) ? 22 : 46.0),
              child: Text(
                'New york ',
                style: TextStyle(
                  color: AppColors.primaryColor,
                  fontFamily: 'aftika-regular',
                  fontSize: Responsive.isMobile(context) ? 22 : 40,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            SizedBox(height: Responsive.isMobile(context) ? 8 : 18),
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: Responsive.isMobile(context) ? 22 : 46.0),
              child: Text(
                'The area is lively with restaurants, bars and nightlife.',
                style: TextStyle(
                  color: Color(0xFF1E0E0E),
                  fontFamily: 'Nunito-Regular',
                  fontSize: Responsive.isMobile(context) ? 8 : 16,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            SizedBox(height: Responsive.isMobile(context) ? 10 : 18),

            Padding(
              padding: EdgeInsets.only(
                left: Responsive.isMobile(context) ? 22 : 46.0,
                right: 22,
              ),
              child: Container(
                height: Responsive.isMobile(context) ? 25 : 55,
                decoration: BoxDecoration(
                  color: const Color(0xFFEEEFF2),
                  borderRadius: BorderRadius.circular(
                    Responsive.isMobile(context) ? 4 : 10,
                  ),
                ),
                child: Row(
                  children: [
                    SizedBox(
                      width: Responsive.isMobile(context) ? 16 : Get.width * 0.03,
                    ),
                    Text(
                      'sort:',
                      style: TextStyle(
                        fontFamily: 'Nunito-Regular',
                        fontSize: Responsive.isMobile(context) ? 8 : 14,
                        fontWeight: FontWeight.w400,
                        color: AppColors.textColor,
                      ),
                    ),
                    SizedBox(
                      width: 18,
                    ),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: List.generate(
                          locationController.top.length,
                              (index) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 12),
                              child: Obx(() {
                                return GestureDetector(
                                  onTap: () {
                                    // Handle the tap for non-dropdown items
                                    if (locationController.top[index] != 'Discount') {
                                      locationController.selectedTop.value =
                                      locationController.top[index];
                                    }
                                  },
                                  child: Container(
                                    height: Responsive.isMobile(context) ? 20 : 40,
                                    decoration: BoxDecoration(
                                      color: locationController.selectedTop.value ==
                                          locationController.top[index] ||
                                          (locationController.top[index] == 'Discount' &&
                                              items.contains(locationController.selectedTop.value))
                                          ? AppColors.whiteColor // White background if selected
                                          : Colors.transparent, // Transparent background if not selected
                                      borderRadius: BorderRadius.circular(
                                          Responsive.isMobile(context) ? 4 : 10),
                                    ),
                                    child: Center(
                                      child: locationController.top[index] == 'Discount'
                                          ? Padding(
                                        padding:  EdgeInsets.all(Responsive.isMobile(context) ? 0:8.0),
                                        child: DropdownButtonHideUnderline(
                                          child: DropdownButton2<String>(
                                            iconStyleData: IconStyleData(
                                              icon: Align(
                                                alignment: Alignment.centerLeft,
                                                child: Image.asset(
                                                  'assets/images/drop_down_img.png', // Path to your image asset
                                                  width: Responsive.isMobile(context) ? 6:12, // Adjust width of the image as per your requirement
                                                  height: Responsive.isMobile(context) ? 6: 12,
                                                ),
                                              ),
                                            ),
                                            dropdownStyleData: DropdownStyleData(
                                                width: 200,
                                                maxHeight: 200,
                                                decoration: BoxDecoration(
                                                    color: AppColors.whiteColor,
                                                    borderRadius: BorderRadius.circular(10))),
                                            // Handle selected value
                                            value: items.contains(
                                                locationController.selectedTop.value)
                                                ? locationController.selectedTop.value
                                                : null, // Fallback to null if no matching item is found

                                            // Hint when nothing is selected
                                            hint: Padding(
                                              padding:  EdgeInsets.only(right: Responsive.isMobile(context) ? 0:8.0),
                                              child: Text(
                                                'Discount',
                                                style: TextStyle(
                                                  fontSize: Responsive.isMobile(context) ? 8 : 14,
                                                  fontWeight: FontWeight.w500,
                                                  color: AppColors.darkGrey,
                                                  fontFamily: 'Nunito-Regular',
                                                ),
                                              ),
                                            ),

                                            // Dropdown items with checkboxes
                                            items: items.map((String item) {
                                              return DropdownMenuItem<String>(
                                                value: item,
                                                child: Row(
                                                  children: [
                                                    // Checkbox only in dropdown menu
                                                    Checkbox(
                                                      fillColor: MaterialStateProperty
                                                          .resolveWith<Color>(
                                                              (Set<MaterialState> states) {
                                                            if (states.contains(
                                                                MaterialState.selected)) {
                                                              return AppColors.primaryColor;
                                                            }
                                                            return AppColors.whiteColor;
                                                          }),

                                                      side: MaterialStateBorderSide
                                                          .resolveWith(
                                                            (Set<MaterialState> states) {
                                                          return BorderSide(
                                                              color: AppColors.primaryColor);
                                                        },
                                                      ),
                                                      value: locationController
                                                          .selectedTop.value ==
                                                          item,
                                                      onChanged: (bool? isSelected) {
                                                        if (isSelected == true) {
                                                          locationController.selectedTop
                                                              .value = item;
                                                          Navigator.pop(context); // Close dropdown after selection
                                                        }
                                                      },
                                                    ),
                                                    // Text inside the dropdown
                                                    Text(
                                                      item,
                                                      style: TextStyle(
                                                        color: AppColors.darkGrey,
                                                        fontWeight: FontWeight.w500,
                                                        fontSize: Responsive.isMobile(context)
                                                            ? 8
                                                            : 14,
                                                        fontFamily: 'Nunito-Regular',
                                                      ),
                                                      overflow: TextOverflow.ellipsis,
                                                    ),
                                                  ],
                                                ),
                                              );
                                            }).toList(),

                                            onChanged: (String? newValue) {
                                              if (newValue != null) {
                                                locationController.selectedTop.value = newValue;
                                              }
                                            },
                                          ),
                                        ),
                                      )
                                          : Padding(
                                        padding:  EdgeInsets.all(Responsive.isMobile(context) ? 2:8.0),
                                        // Text outside the dropdown without checkboxes
                                        child: Text(
                                          locationController.top[index],
                                          style: TextStyle(
                                            fontWeight: locationController.selectedTop.value !=
                                                locationController.top[index]
                                                ? FontWeight.w500
                                                : FontWeight.w700,
                                            fontSize:
                                            Responsive.isMobile(context) ? 8 : 14,
                                            color: locationController.selectedTop.value !=
                                                locationController.top[index]
                                                ? AppColors.darkGrey
                                                : AppColors.primaryColor,
                                            fontFamily: 'Nunito-Regular',
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }),
                            );
                          },
                        ),
                      ),
                    )



        ],
                ),
              ),
            ),

            SizedBox(height: Responsive.isMobile(context) ? 2 : 22),
            Obx(() {
              return Padding(
                padding: EdgeInsets.only(
                  left: Responsive.isMobile(context)
                      ? 18
                      : (isLargeScreen ? 48 : 30.0),
                  right: Responsive.isMobile(context)
                      ? 18
                      : (isLargeScreen ? 48 : 30.0),
                ),
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    mainAxisExtent: Responsive.isMobile(context)
                        ? 263
                        : (isLargeScreen ? 430 : 350),
                    crossAxisCount: Responsive.isMobile(context)
                        ? 2
                        : (Responsive.isTablet(context) ? 3 : 4),
                    crossAxisSpacing: Responsive.isMobile(context)
                        ? 10
                        : (Responsive.isTablet(context) ? 8 : 10),
                    mainAxisSpacing: Responsive.isMobile(context)
                        ? 0
                        : (Responsive.isTablet(context) ? 2 : 20),
                    childAspectRatio: itemWidth / itemHeight,
                  ),
                  itemCount: locationController.locationItem.length,
                  itemBuilder: (context, index) {
                    final item = locationController.locationItem[index];
                    return CustomRectangleWidget(
                      title: item.title,
                      description: item.description,
                      imagePath: item.imagePath,
                      timetext: item.timetext,
                      percentText: item.percentText,
                      isFavorite: false.obs,
                    );
                  },
                ),
              );
            })
          ],
        );
      },
    );
  }
}
