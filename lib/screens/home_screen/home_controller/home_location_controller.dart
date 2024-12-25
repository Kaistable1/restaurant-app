import 'package:flutter/animation.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../model/home-model.dart';
 // Import your model

class HomeLocationController extends GetxController {
  final searchController = TextEditingController();
  // ScrollController to control the ListView scroll position
  ScrollController scrollController = ScrollController();
  var selectedLetter = ''.obs; // Observable variable to store selected index
  List top = ['Most Reviewed', 'Discount', 'Dining',  ];
  RxString selectedTop = ''.obs;
  var selectedDiscount = '10%'.obs;
  // Define the selectIndex methodi

  // List of CircleContainerModel objects
  final List<CircleContainerModel> circleItems = [
    CircleContainerModel(
      imgPath: 'assets/images/location_img1.png',
      titleText: 'Hua hin beach side',
      descriptionText: '14 restaurants',
    ),
    CircleContainerModel(
      imgPath: 'assets/images/location_img2.png',
      titleText: 'Hua hin beach side',
      descriptionText: '20 restaurants',
    ),
    CircleContainerModel(
      imgPath: 'assets/images/location_img3.png',
      titleText: 'Hua hin beach side',
      descriptionText: '20 restaurants',
    ),
    CircleContainerModel(
      imgPath: 'assets/images/location_img1.png',
      titleText: 'Hua hin beach side',
      descriptionText: '14 restaurants',
    ),
    CircleContainerModel(
      imgPath: 'assets/images/location_img2.png',
      titleText: 'Hua hin beach side',
      descriptionText: '20 restaurants',
    ),
    CircleContainerModel(
      imgPath: 'assets/images/location_img3.png',
      titleText: 'Hua hin beach side',
      descriptionText: '20 restaurants',
    ),
    CircleContainerModel(
      imgPath: 'assets/images/location_img1.png',
      titleText: 'Hua hin beach side',
      descriptionText: '14 restaurants',
    ),
    CircleContainerModel(
      imgPath: 'assets/images/location_img2.png',
      titleText: 'Hua hin beach side',
      descriptionText: '20 restaurants',
    ),
    CircleContainerModel(
      imgPath: 'assets/images/location_img3.png',
      titleText: 'Hua hin beach side',
      descriptionText: '20 restaurants',
    ),

    // Add more items as needed
  ];

  // Function to scroll left
  void scrollLeft() {
    scrollController.animateTo(
      scrollController.offset - 300, // Scroll left by 300 pixels
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  // Function to scroll right
  void scrollRight() {
    scrollController.animateTo(
      scrollController.offset + 300, // Scroll right by 300 pixels
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  void onClose() {
    scrollController.dispose(); // Dispose the controller when not in use
    super.onClose();
  }
}
// Padding(
//   padding: EdgeInsets.only(
//       left: Responsive.isMobile(context) ? 8 : 42, right: 6),
//   child: SizedBox(
//     height: Get.height,
//     child: GridView.builder(
//       gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//         crossAxisCount: 3, // Number of items per row
//         crossAxisSpacing: 6, // Horizontal spacing between items
//         mainAxisSpacing: 6, // Vertical spacing between items
//         childAspectRatio: 1, // Aspect ratio for each item
//       ),
//       itemCount: controller.circleItems.length, // Number of items
//       itemBuilder: (context, index) {
//         final item = controller.circleItems[index]; // Get item from model list
//         return Padding(
//           padding: const EdgeInsets.symmetric(
//               horizontal: 6,
//               vertical: 6),
//           child: CircleContainerWidget(
//             ontap: () {
//               Get.to(LocationScreen());
//             },
//             isFavourite: false.obs,
//             isLocation: true,
//             imgPath: item.imgPath,
//             titleText: item.titleText,
//             descriptionText: item.descriptionText,
//           ),
//         );
//       },
//     ),
//   ),
// ),