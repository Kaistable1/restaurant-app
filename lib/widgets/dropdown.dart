// import 'package:flutter/cupertino.dart';
// import 'package:get/get_core/src/get_main.dart';
// import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
//
// import '../constants/app_colors.dart';
//
// class MyGalleryWidget extends StatelessWidget {
//   final String imagePath;
//   final int index;
//
//   final controller = Get.put(ProfileController());
//   MyGalleryWidget({
//     required this.imagePath,
//     required this.index,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Obx(() {
//       // RxBool isSelected = controller.selectedIndex.contains(index).obs;
//       return InkWell(
//         onTap: () {
//           if (controller.isCover.value) {
//             if (controller.selectedIndex.contains(index)) {
//               controller.selectedIndex.remove(index);
//             } else {
//               controller.selectedIndex.add(index);
//             }
//           }
//         },
//         onLongPress: () {
//           controller.isCover.value = true;
//
//           if (controller.selectedIndex.contains(index)) {
//             controller.selectedIndex.remove(index);
//           } else {
//             controller.selectedIndex.add(index);
//           }
//         },
//         child: Stack(
//           children: [
//             Container(
//               decoration: BoxDecoration(
//                 border: controller.selectPhotos.contains(index)
//                     ? Border.all(color: AppColors.theme, width: 2.5)
//                     : null,
//                 // borderRadius: BorderRadius.circular(8.0),
//                 image: DecorationImage(
//                   image: AssetImage(imagePath),
//                   fit: BoxFit.cover,
//                 ),
//               ),
//             ),
//             controller.isCover.value
//                 ? Positioned(
//               left: 5,
//               top: 5,
//               child: SquareCheckbox(
//                   ontap: () {},
//                   height: 16,
//                   width: 16,
//                   iconSize: 13,
//                   isChecked: controller.isDel.value
//                       ? controller.selectPhotos.contains(index)
//                       : controller.selectedIndex.contains(index)),
//             )
//                 : SizedBox()
//           ],
//         ),
//       );
//     });
//   }
// }