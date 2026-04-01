import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kaistable_website/widgets/rectangle_widget.dart';

import '../../../constants/app_colors.dart';
import '../../../utils/responsive.dart';
import '../../nav_bar/restaurant_detail_screens/restaurant_detail_screen.dart';
import '../home_controller/home_location_controller.dart';
import '../location_pages/location_controller/location_controller.dart';

class FilterScreen extends StatelessWidget {
  final List<String> letters = [
    '#',
    'A',
    'B',
    'C',
    'D',
    'E',
    'F',
    'G',
    'H',
    'I',
    'J',
    'K',
    'L',
    'M',
    'N',
    'O',
    'P',
    'Q',
    'R',
    'S',
    'T',
    'U',
    'V',
    'W',
    'X',
    'Y',
    'Z'
  ];

  final HomeLocationController controller = Get.put(HomeLocationController());
  final Function(int)? onNavigate;
  final RxBool isTapped = false.obs;
  final RxBool showFilterOptions = false.obs;
  final LocationController locationController = Get.put(LocationController());

  FilterScreen({
    super.key,
    this.onNavigate,
  });
  @override
  Widget build(BuildContext context) {
    // Get the selected letter passed from the previous screen
    String selectedLetter =
        Get.arguments ?? ''; // Retrieve the letter passed via Get.to()

    return WillPopScope(
      onWillPop: () async {
        Get.back();
        return false;
      },
      child: LayoutBuilder(
        builder: (context, constraints) {
          int itemsPerRow = 2;
          double itemWidth = (constraints.maxWidth / itemsPerRow) - 16;
          double itemHeight = 320;

          return Scaffold(
            backgroundColor: AppColors.bgColor,
            appBar: AppBar(
              backgroundColor: AppColors.bgColor,
              iconTheme: IconThemeData(
                color: AppColors.primaryColor,
              ),
              centerTitle: true,
              automaticallyImplyLeading: true,
              leading: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Container(
                  height: 16,
                  width: 16,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        spreadRadius: 1,
                        blurRadius: 3,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                  child: GestureDetector(
                    onTap: () {
                      Get.back();
                    },
                    child: Icon(Icons.arrow_back, size: 18),
                  ),
                ),
              ),
              title: Text(
                'Available restaurants',
                style: const TextStyle(
                  fontSize: 17,
                  color: AppColors.bottomSheetColor,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'Nunito-Bold',
                ),
              ),
              actions: [
                GestureDetector(
                  onTap: () {
                    isTapped.value = !isTapped.value;
                    showFilterOptions.value = !showFilterOptions.value;
                    Get.back(); // Toggle visibility of filter options
                  },
                  child: Obx(
                    () => Container(
                      height: 38,
                      width: 38,
                      decoration: BoxDecoration(
                        color: isTapped.value
                            ? AppColors.primaryColor
                            : AppColors.whiteColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Image.asset(
                          "assets/images/filter_white.png",
                          height: 24,
                          width: 24,
                          color: isTapped.value
                              ? Colors.white
                              : AppColors.primaryColor,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 10,
                )
              ],
            ),
            body: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  // Obx(
                  //       () => showFilterOptions.value
                  //       ? Padding(
                  //     padding: const EdgeInsets.symmetric(horizontal: 16),
                  //     child: Container(
                  //       height: 109,
                  //       width: 358,
                  //       padding: const EdgeInsets.all(16),
                  //       decoration: BoxDecoration(
                  //         color: Colors.white,
                  //         borderRadius: BorderRadius.only(
                  //             bottomRight: Radius.circular(10),
                  //             bottomLeft: Radius.circular(10)),
                  //
                  //       ),
                  //       child: Column(
                  //         crossAxisAlignment: CrossAxisAlignment.start,
                  //         children: [
                  //           Text("Filter restaurants A to Z",
                  //             style: TextStyle(
                  //                 fontFamily: "Nunito-Bold",
                  //                 fontSize: 16,
                  //                 fontWeight: FontWeight.w600,
                  //                 color: AppColors.botomSheetColor
                  //             ),),
                  //
                  //           Expanded(
                  //             child: GridView.builder(
                  //               gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  //                 crossAxisCount: 12,
                  //                 childAspectRatio: 1.5,
                  //               ),
                  //               itemCount: letters.length,  // Assume letters is a list of alphabets like ['A', 'B', 'C', ...]
                  //               itemBuilder: (context, index) {
                  //                 String letter = letters[index];
                  //
                  //                 return GestureDetector(
                  //                   onTap: () {
                  //                     controller.selectedLetter.value = letter;
                  //                     Get.to(FilterScreen(),arguments: letter); // Update selected letter
                  //                     print('Filter by $letter');
                  //                   },
                  //                   child: Center(
                  //                     child: Obx(() {
                  //                       // Listen to the changes in selectedLetter
                  //                       return Text(
                  //                         letter,
                  //                         style: TextStyle(
                  //                           fontSize: 12,
                  //                           color: controller.selectedLetter.value == letter
                  //                               ? AppColors.primaryColor
                  //                               : AppColors.textColor,
                  //                           fontWeight: FontWeight.w500,
                  //                           fontFamily: "Nunito-Regular",
                  //                         ),
                  //                       );
                  //                     }),
                  //                   ),
                  //                 );
                  //               },
                  //             ),
                  //           )
                  //
                  //
                  //         ],
                  //       ),
                  //     ),
                  //   )
                  //       : SizedBox.shrink(),
                  // ),

                  SizedBox(height: Responsive.isMobile(context) ? 8 : 18),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: Responsive.isMobile(context) ? 16 : 46.0),
                    child: Text(
                      'Showing results for \'$selectedLetter\'',
                      style: TextStyle(
                        color: AppColors.bottomSheetColor,
                        fontFamily: 'Nunito-Bold',
                        fontSize: Responsive.isMobile(context) ? 18 : 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  SizedBox(height: Responsive.isMobile(context) ? 10 : 18),

                  SizedBox(height: Responsive.isMobile(context) ? 20 : 22),
                  Obx(() {
                    return Padding(
                      padding: EdgeInsets.only(
                        left: 14,
                        right: 14,
                      ),
                      child: GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          mainAxisExtent: 220,
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
                          return InkWell(
                            onTap: () {
                              Get.to(RestaurantDetailScreen());
                            },
                            child: RectangleWidget(
                              onNavigate: onNavigate,
                              title: item.title,
                              description: item.description,
                              imagePath: item.imagePath,
                              timetext: item.timetext,
                              percentText: item.percentText,
                              endTimeText: item.endTimeText,
                              isFavorite: false.obs,
                              //scrollcontroller: scrollcontroller,
                            ),
                          );
                        },
                      ),
                    );
                  }),
                  SizedBox(
                    height: 30,
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
