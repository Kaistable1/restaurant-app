
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../constants/app_colors.dart';


class CategoryController extends GetxController {
  var selectedIndex = (-1).obs; // Stores only one selected index

  void selectCategory(int index) {
    selectedIndex.value = index; // Only one selection at a time
  }
}


class HorizontalCategorySelector extends StatelessWidget {
  final List<String> categories = ["Concert", "Festival", "Sports",'Distance'];
   final List<String> categoriesImages = ["assets/images/concert_icon.png", "assets/images/festival_icon.png", "assets/images/sports_icon.png", "assets/images/distance.png"];
  final CategoryController controller = Get.put(CategoryController());

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 35,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (context, index) {
          return Obx(() {
            bool isSelected = controller.selectedIndex.value == index;
            return GestureDetector(
              onTap: () => controller.selectCategory(index), // Select only one at a time
              child: Container(
                width: 102,
                margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(.1),
                      spreadRadius: 0,
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                  color: isSelected ? AppColors.primaryColor : AppColors.whiteColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        categoriesImages[index],
                      color: isSelected? AppColors.whiteColor : AppColors.primaryColor,
                      height: 16,
                        width: 16,
                      ),
                      SizedBox(width: 12,),
                      Text(
                        categories[index],
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: isSelected ? AppColors.whiteColor : AppColors.bottomSheetColor,
                          fontFamily: 'Nunito-Bold',
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          });
        },
      ),
    );
  }
}
