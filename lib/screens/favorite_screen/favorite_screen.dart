import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:kaistable_website/constants/app_colors.dart';

import '../../utils/responsive.dart';
import '../../widgets/fav_rectangle_widget.dart';
import 'controller/favorite_controller.dart';

class FavoriteScreen extends StatelessWidget {
  final controller = Get.put(FavoriteController());

  FavoriteScreen({super.key});

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

        return Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Favorites',
                style: TextStyle(
                  color: AppColors.botomSheetColor,
                  fontFamily: 'aftika-regular',
                  fontSize: Responsive.isMobile(context) ? 22 : 40,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 20),

              // GridView for responsive grid layout
              Obx(() {
                return GridView.builder(
                  shrinkWrap: true, // To allow GridView inside a Column
                  physics:
                      const NeverScrollableScrollPhysics(), // Disable GridView scrolling, scroll with the page
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    mainAxisExtent: Responsive.isMobile(context) ? 263 : 450,
                    crossAxisCount: itemsPerRow, // Number of items per row
                    crossAxisSpacing: Responsive.isMobile(context)
                        ? 10
                        : Responsive.isTablet(context)
                            ? 8
                            : 10, // Space between columns
                    mainAxisSpacing: Responsive.isMobile(context)
                        ? 0
                        : Responsive.isTablet(context)
                            ? 2
                            : 20, // Space between rows
                    childAspectRatio: itemWidth /
                        itemHeight, // Adjust ratio based on item width/height
                  ),
                  itemCount: controller.favoriteItems.length,
                  itemBuilder: (context, index) {
                    final item = controller.favoriteItems[index];
                    return CustomRectangleWidget(
                      title: item.title,
                      description: item.description,
                      imagePath: item.imagePath,
                      timetext: item.timetext,
                      percentText: item.percentText,
                      isFavorite: item.isFavorite,
                    );
                  },
                );
              }),
            ],
          ),
        );
      },
    );
  }
}
