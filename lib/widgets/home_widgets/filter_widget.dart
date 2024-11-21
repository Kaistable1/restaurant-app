import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

import '../../../constants/app_colors.dart';
import '../../../utils/responsive.dart';
import '../../screens/home_screen/home_controller/home_location_controller.dart';


class FilterWidget extends StatelessWidget {
  final HomeLocationController controller = Get.put(HomeLocationController());
  final List<String> items = [
    '10%',
    '20%',
    '30%',
    '40%',
    '50%',

  ];
  final RxBool isTapped = false.obs;

  final RxBool showFilterOptions = false.obs;
  FilterWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [

        Padding(
          padding: const EdgeInsets.only(left: 16,top: 8,right: 14),
          child: Row(
            children: [
              Container(
                height: Responsive.isMobile(context) ? 44 : 55,
                width: Responsive.isMobile(context) ? 285 : 639,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(
                    Responsive.isMobile(context) ? 10 : 10,
                  ),
                  boxShadow: [

                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        maxLines: 1,
                        style: TextStyle(
                          color: AppColors.textColor,
                          fontFamily: "Lora-Regular",
                          fontSize: Responsive.isMobile(context) ? 12 : 16,
                        ),
                        cursorColor: AppColors.textColor,
                        decoration: InputDecoration(
                          hintText: 'Try searching for restaurant name',
                          hintStyle: TextStyle(
                            color: const Color(0xFF4F5762),
                            fontFamily: "Nunito-Regular",
                            fontWeight: FontWeight.w400,
                            fontSize:
                            Responsive.isMobile(context) ? 10 : 16,
                          ),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.only(
                            top: Responsive.isMobile(context) ? 10 : 18,
                            // bottom: Responsive.isMobile(context) ? 20 : 12,
                            //left: Responsive.isMobile(context) ? 9 : 20,
                          ),
                          prefixIcon: Padding(
                            padding: EdgeInsets.all(
                                Responsive.isMobile(context) ? 13 : 14),
                            child: Image.asset(
                              'assets/images/search_icon.png',
                              fit: BoxFit.contain,
                              height: 20,
                              width: 20,
                            ),
                          ),
                        ),
                      ),
                    ),

                    Container(
                      height: 55,
                      width: Responsive.isMobile(context) ? 66 : 106,
                      decoration: BoxDecoration(
                        color: AppColors.primaryColor,
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(
                              Responsive.isMobile(context) ? 10 : 10),
                          bottomRight: Radius.circular(
                              Responsive.isMobile(context) ? 10 : 10),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          'Search',
                          style: TextStyle(
                            color: AppColors.botomSheetColor,
                            fontFamily: "Nunito-Bold",
                            fontSize:
                            Responsive.isMobile(context) ? 12 : 16,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ),

                  ],
                ),
              ),
              const SizedBox(width: 4,),
              GestureDetector(
                onTap: () {
                  isTapped.value = !isTapped.value;
                  showFilterOptions.value = !showFilterOptions.value; // Toggle visibility of filter options
                },
                child: Obx(
                      () => Container(
                    height: 44,
                    width: 38,
                    decoration: BoxDecoration(
                      color: isTapped.value ? AppColors.primaryColor : AppColors.whiteColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Image.asset(
                        "assets/images/filter_white.png",
                        height: 24,
                        width: 24,
                        color: isTapped.value ? AppColors.whiteColor : AppColors.primaryColor,
                      ),
                    ),
                  ),
                ),
              ),

            ],
          ),
        ),
        SizedBox(height: 10),
        Obx(
              () => showFilterOptions.value
              ? Padding(
            padding: EdgeInsets.only(
              left: Responsive.isMobile(context) ? 16 : 46.0,
              right: 22,
            ),
            child: Container(
              height: Responsive.isMobile(context) ? 38: 55,
              decoration: BoxDecoration(
                color: const Color(0xFFEEEFF2),
                borderRadius: BorderRadius.circular(
                  Responsive.isMobile(context) ? 4 : 10,
                ),
              ),
              child: Row(
                children: [
                  SizedBox(
                    width: Responsive.isMobile(context) ? 12 : Get.width * 0.03,
                  ),
                  Text(
                    'sort:',
                    style: TextStyle(
                      fontFamily: 'Nunito-Regular',
                      fontSize: Responsive.isMobile(context) ? 10 : 14,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textColor,
                    ),
                  ),
                  const SizedBox(
                    width: 4,
                  ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: List.generate(
                        controller.top.length,
                            (index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 6),
                            child: Obx(() {
                              return InkWell(
                                onTap: () {
                                  // Handle the tap for non-dropdown items
                                  if (controller.top[index] != 'Discount') {
                                    controller.selectedTop.value =
                                    controller.top[index];
                                  }
                                },
                                child: Container(
                                  height: Responsive.isMobile(context) ? 26 : 40,
                                  decoration: BoxDecoration(
                                    color: controller.selectedTop.value ==
                                        controller.top[index] ||
                                        (controller.top[index] == 'Discount' &&
                                            items.contains(controller.selectedTop.value))
                                        ? AppColors.whiteColor // White background if selected
                                        : Colors.transparent, // Transparent background if not selected
                                    borderRadius: BorderRadius.circular(
                                        Responsive.isMobile(context) ? 4 : 10),
                                  ),
                                  child: Center(
                                    child: controller.top[index] == 'Discount'
                                        ? Padding(
                                      padding: EdgeInsets.all(
                                          Responsive.isMobile(context) ? 4 : 8.0),
                                      child:DropdownButtonHideUnderline(
                                        child: DropdownButton2<String>(
                                          iconStyleData: IconStyleData(
                                            icon: Image.asset(
                                              'assets/images/drop_down_img.png', // Path to your image asset
                                              width: Responsive.isMobile(context) ? 8 : 12, // Adjust width of the image as per your requirement
                                              height: Responsive.isMobile(context) ? 8 : 12,
                                            ),
                                          ),
                                          dropdownStyleData: DropdownStyleData(
                                            width: 200,
                                            maxHeight: 200,
                                            decoration: BoxDecoration(
                                              color: AppColors.whiteColor,
                                              borderRadius: BorderRadius.circular(10),
                                            ),
                                          ),
                                          value: items.contains(controller.selectedTop.value)
                                              ? controller.selectedTop.value
                                              : null, // Fallback to null if no matching item is found

                                          // Hint when nothing is selected
                                          hint: Padding(
                                            padding: EdgeInsets.only(right: Responsive.isMobile(context) ? 10 : 8.0),
                                            child: Text(
                                              'Discount',
                                              style: TextStyle(
                                                fontSize: Responsive.isMobile(context) ? 10 : 14,
                                                fontWeight: FontWeight.w500,
                                                color: AppColors.darkGrey,
                                                fontFamily: 'Nunito-Regular',
                                              ),
                                            ),
                                          ),

                                          selectedItemBuilder: (BuildContext context) {
                                            return items.map((String item) {
                                              return Text(
                                                item,
                                                style: TextStyle(
                                                  color: AppColors.darkGrey,
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: Responsive.isMobile(context) ? 12 : 14,
                                                  fontFamily: 'Nunito-Regular',
                                                ),
                                              );
                                            }).toList();
                                          },

                                          items: items.map((String item) {
                                            return DropdownMenuItem<String>(
                                              value: item,
                                              child: Row(
                                                children: [
                                                  Checkbox(
                                                    fillColor: MaterialStateProperty.resolveWith<Color>(
                                                          (Set<MaterialState> states) {
                                                        if (states.contains(MaterialState.selected)) {
                                                          return AppColors.primaryColor;
                                                        }
                                                        return AppColors.whiteColor;
                                                      },
                                                    ),
                                                    side: MaterialStateBorderSide.resolveWith((Set<MaterialState> states) {
                                                      return BorderSide(color: AppColors.primaryColor);
                                                    }),
                                                    value: controller.selectedTop.value == item, // Ensure the correct item is checked
                                                    onChanged: (bool? isSelected) {
                                                      if (isSelected == true) {
                                                        // If the item is selected, set it as the selected value
                                                        controller.selectedTop.value = item;
                                                      } else {
                                                        // If the item is unselected, reset the selected value
                                                        controller.selectedTop.value = ''; // Set to null or empty string to unselect
                                                      }
                                                      Navigator.pop(context); // Close dropdown after selection/unselection
                                                    },
                                                  ),

                                                  Text(
                                                    item,
                                                    style: TextStyle(
                                                      color: AppColors.darkGrey,
                                                      fontWeight: FontWeight.w500,
                                                      fontSize: Responsive.isMobile(context) ? 10 : 14,
                                                      fontFamily: 'Nunito-Regular',
                                                    ),
                                                    overflow: TextOverflow.ellipsis,
                                                  ),
                                                ],
                                              ),
                                            );
                                          }).toList(),

                                          // Modified onChanged function to allow unselecting the currently selected value
                                          onChanged: (String? newValue) {
                                            if (newValue == controller.selectedTop.value) {
                                              // If the selected value is clicked again, unselect it
                                              controller.selectedTop.value = ''; // Set to null or empty string to unselect
                                            } else {
                                              controller.selectedTop.value = newValue!;
                                            }
                                          },
                                        ),
                                      ),


                                    )
                                        : Padding(
                                      padding: EdgeInsets.all(
                                          Responsive.isMobile(context) ? 2 : 18.0),
                                      // Text outside the dropdown without checkboxes
                                      child: Text(
                                        controller.top[index],
                                        style: TextStyle(
                                          fontWeight: controller.selectedTop.value !=
                                              controller.top[index]
                                              ? FontWeight.w500
                                              : FontWeight.w700,
                                          fontSize: Responsive.isMobile(context) ? 10 : 14,
                                          color: controller.selectedTop.value !=
                                              controller.top[index]
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
          )


              : SizedBox.shrink(),
        ),
        SizedBox(height: Responsive.isMobile(context) ? 8 : 50),
      ],
    );
  }
}
