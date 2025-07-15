// import 'package:dotted_border/dotted_border.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:get/get_core/src/get_main.dart';
// import 'package:savrly/controllers/video_controller.dart';

// class UploadVideoForm extends StatelessWidget {
//   final nameController = TextEditingController();
//   final locationController = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     final videoController = Get.find<VideoController>();

//     return Padding(
//       padding: const EdgeInsets.all(24),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const Text("Upload video", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
//           const SizedBox(height: 20),
//           GestureDetector(
//             onTap: () => videoController.pickAndUploadVideoForAdmin(context),
//             child: DottedBorder(
//               borderType: BorderType.RRect,
//               radius: Radius.circular(12),
//               dashPattern: [8, 4],
//               color: Colors.grey,
//               strokeWidth: 2,
//               child: Container(
//                 height: 150,
//                 width: double.infinity,
//                 alignment: Alignment.center,
//                 child: const Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Icon(Icons.upload_rounded, size: 40),
//                     SizedBox(height: 8),
//                     Text("Drag video here", style: TextStyle(fontSize: 16)),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//           const SizedBox(height: 20),
//           TextField(
//             controller: nameController,
//             decoration: const InputDecoration(labelText: "Restaurant name"),
//           ),
//           const SizedBox(height: 12),
//           TextField(
//             controller: locationController,
//             decoration: const InputDecoration(labelText: "Location"),
//           ),
//           const SizedBox(height: 12),
//           // Add Dropdowns here as needed
//           const SizedBox(height: 20),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               TextButton(
//                 onPressed: () => videoController.toggleUploadMode(),
//                 child: const Text("Cancel", style: TextStyle(color: Colors.red)),
//               ),
//               ElevatedButton(
//                 onPressed: () {
//                   // upload logic with controllers
//                 },
//                 child: const Text("Upload"),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:savrly/constants/app_colors.dart';
// import 'package:savrly/controllers/video_controller.dart';
// import 'package:video_player/video_player.dart';

// class UploadVideoForm extends StatefulWidget {
//   @override
//   _UploadVideoFormState createState() => _UploadVideoFormState();
// }

// class _UploadVideoFormState extends State<UploadVideoForm> {
//   final nameController = TextEditingController();
//   final locationController = TextEditingController();
//   String? selectedRestaurant;
//   String? selectedFacility;
//   String? selectedDietary;
//   String? selectedAtmosphere;

//   final List<String> restaurants = [
//     'Kristalle',
//     'Bistro',
//     'Cafe Delight',
//     'The Grill'
//   ];
//   final List<String> facilities = [
//     'WiFi',
//     'Parking',
//     'Outdoor Seating',
//     'Wheelchair Access'
//   ];
//   final List<String> dietaryOptions = [
//     'Vegetarian',
//     'Vegan',
//     'Gluten-Free',
//     'Halal'
//   ];
//   final List<String> atmosphereOptions = [
//     'Family',
//     'Romantic',
//     'Business',
//     'Casual'
//   ];

//   @override
//   void dispose() {
//     nameController.dispose();
//     locationController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final videoController = Get.find<VideoController>();

//     return Scaffold(
//       appBar: AppBar(
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back),
//           onPressed: () {
//             videoController.clearSelection();
//             videoController.toggleUploadMode(); // switch back to grid view
//           },
//         ),
//         title: Text("Upload video"),
//         centerTitle: true,
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(24),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             // Video upload area with preview
//             Obx(() {
//               final hasVideo =
//                   videoController.videoPlayerController.value != null &&
//                       videoController
//                           .videoPlayerController.value!.value.isInitialized;

//               return GestureDetector(
//                 onTap: () => videoController.pickVideo(context),
//                 child: Container(
//                   height: 334,
//                   width: 604,
//                   alignment: Alignment.center,
//                   decoration: BoxDecoration(
//                     border: Border.all(color: backgroundBlack,),
//                     borderRadius: BorderRadius.circular(25.0)
//                   ),
//                   child: hasVideo
//                       ? Stack(
//                           alignment: Alignment.center,
//                           children: [
//                             AspectRatio(
//                               aspectRatio: videoController
//                                   .videoPlayerController
//                                   .value!
//                                   .value
//                                   .aspectRatio,
//                               child: VideoPlayer(videoController
//                                   .videoPlayerController.value!),
//                             ),
//                             Positioned.fill(
//                               child: GestureDetector(
//                                 onTap: () {
//                                   if (videoController.videoPlayerController
//                                       .value!.value.isPlaying) {
//                                     videoController
//                                         .videoPlayerController.value!
//                                         .pause();
//                                   } else {
//                                     videoController
//                                         .videoPlayerController.value!
//                                         .play();
//                                   }
//                                 },
//                                 child: Container(
//                                   color: Colors.transparent,
//                                   child: Center(
//                                     child: Icon(
//                                       videoController.videoPlayerController
//                                               .value!.value.isPlaying
//                                           ? Icons.pause
//                                           : Icons.play_arrow,
//                                       size: 50,
//                                       color: Colors.white.withOpacity(0.7),
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ),
//                             Positioned(
//                               bottom: 8,
//                               right: 8,
//                               child: Container(
//                                 padding: EdgeInsets.all(4),
//                                 decoration: BoxDecoration(
//                                   color: Colors.black54,
//                                   borderRadius: BorderRadius.circular(4),
//                                 ),
//                                 child: Text(
//                                   videoController.videoName.value,
//                                   style: TextStyle(
//                                     color: Colors.white,
//                                     fontSize: 12,
//                                   ),
//                                   maxLines: 1,
//                                   overflow: TextOverflow.ellipsis,
//                                 ),
//                               ),
//                             ),
//                           ],
//                         )
//                       : Column(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Icon(Icons.upload_rounded, size: 40),
//                             SizedBox(height: 8),
//                             Text("Drag video here",
//                                 style: TextStyle(fontSize: 16)),
//                             if (videoController.isUploading.value)
//                               Padding(
//                                 padding: EdgeInsets.only(top: 10),
//                                 child: Column(
//                                   children: [
//                                     CircularProgressIndicator(),
//                                     SizedBox(height: 8),
//                                     Text(
//                                       "${(videoController.uploadProgress.value * 100).toStringAsFixed(1)}%",
//                                       style: TextStyle(fontSize: 12),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                           ],
//                         ),
//                 ),
//               );
//             }),
//             SizedBox(height: 30),

//             // Restaurant name field
//             TextField(
//               controller: nameController,
//               decoration: InputDecoration(
//                 labelText: "Restaurant name",
//                 border: OutlineInputBorder(),
//                 hintText: "Kristalle",
//               ),
//             ),
//             SizedBox(height: 16),

//             // Location field
//             TextField(
//               controller: locationController,
//               decoration: InputDecoration(
//                 labelText: "Location",
//                 border: OutlineInputBorder(),
//                 hintText: "United States/unstraighted/",
//               ),
//             ),
//             SizedBox(height: 16),

//             // Restaurant dropdown
//             InputDecorator(
//               decoration: InputDecoration(
//                 labelText: "Restaurant",
//                 border: OutlineInputBorder(),
//               ),
//               child: DropdownButtonHideUnderline(
//                 child: DropdownButton<String>(
//                   value: selectedRestaurant,
//                   isDense: true,
//                   isExpanded: true,
//                   hint: Text("Select restaurant"),
//                   items: restaurants.map((String value) {
//                     return DropdownMenuItem<String>(
//                       value: value,
//                       child: Text(value),
//                     );
//                   }).toList(),
//                   onChanged: (newValue) {
//                     setState(() {
//                       selectedRestaurant = newValue;
//                     });
//                   },
//                 ),
//               ),
//             ),
//             SizedBox(height: 16),

//             // Facilities dropdown
//             InputDecorator(
//               decoration: InputDecoration(
//                 labelText: "Facilities/Services",
//                 border: OutlineInputBorder(),
//               ),
//               child: DropdownButtonHideUnderline(
//                 child: DropdownButton<String>(
//                   value: selectedFacility,
//                   isDense: true,
//                   isExpanded: true,
//                   hint: Text("Select facilities"),
//                   items: facilities.map((String value) {
//                     return DropdownMenuItem<String>(
//                       value: value,
//                       child: Text(value),
//                     );
//                   }).toList(),
//                   onChanged: (newValue) {
//                     setState(() {
//                       selectedFacility = newValue;
//                     });
//                   },
//                 ),
//               ),
//             ),
//             SizedBox(height: 16),

//             // Dietary Preferences dropdown
//             InputDecorator(
//               decoration: InputDecoration(
//                 labelText: "Dietary Preferences",
//                 border: OutlineInputBorder(),
//               ),
//               child: DropdownButtonHideUnderline(
//                 child: DropdownButton<String>(
//                   value: selectedDietary,
//                   isDense: true,
//                   isExpanded: true,
//                   hint: Text("Select dietary preferences"),
//                   items: dietaryOptions.map((String value) {
//                     return DropdownMenuItem<String>(
//                       value: value,
//                       child: Text(value),
//                     );
//                   }).toList(),
//                   onChanged: (newValue) {
//                     setState(() {
//                       selectedDietary = newValue;
//                     });
//                   },
//                 ),
//               ),
//             ),
//             SizedBox(height: 16),

//             // Atmosphere dropdown
//             InputDecorator(
//               decoration: InputDecoration(
//                 labelText: "Atmosphere",
//                 border: OutlineInputBorder(),
//               ),
//               child: DropdownButtonHideUnderline(
//                 child: DropdownButton<String>(
//                   value: selectedAtmosphere,
//                   isDense: true,
//                   isExpanded: true,
//                   hint: Text("Select atmosphere"),
//                   items: atmosphereOptions.map((String value) {
//                     return DropdownMenuItem<String>(
//                       value: value,
//                       child: Text(value),
//                     );
//                   }).toList(),
//                   onChanged: (newValue) {
//                     setState(() {
//                       selectedAtmosphere = newValue;
//                     });
//                   },
//                 ),
//               ),
//             ),
//             SizedBox(height: 30),

//             // Action buttons
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Expanded(
//                   child: OutlinedButton(
//                     onPressed: () {
//                       videoController.clearSelection();
//                       videoController.toggleUploadMode();
//                     },
//                     style: OutlinedButton.styleFrom(
//                       padding: EdgeInsets.symmetric(vertical: 16),
//                       side: BorderSide(color: Colors.red),
//                     ),
//                     child: Text(
//                       "Cancel",
//                       style: TextStyle(color: Colors.red),
//                     ),
//                   ),
//                 ),
//                 SizedBox(width: 16),
//                 Expanded(
//                   child: Obx(() => ElevatedButton(
//                         onPressed: videoController.isUploading.value
//                             ? null
//                             : () {
//                                 if (nameController.text.isEmpty ||
//                                     locationController.text.isEmpty) {
//                                   Get.snackbar(
//                                     "Error",
//                                     "Please fill required fields",
//                                     snackPosition: SnackPosition.BOTTOM,
//                                     backgroundColor: Colors.red,
//                                     colorText: Colors.white,
//                                   );
//                                   return;
//                                 }

//                                 if (videoController.pickedVideo.value == null) {
//                                   Get.snackbar(
//                                     "Error",
//                                     "Please select a video first",
//                                     snackPosition: SnackPosition.BOTTOM,
//                                     backgroundColor: Colors.red,
//                                     colorText: Colors.white,
//                                   );
//                                   return;
//                                 }

//                                 videoController.uploadVideo(
//                                   context: context,
//                                   restaurantName: nameController.text,
//                                   location: locationController.text,
//                                   restaurantType: selectedRestaurant,
//                                   facilities: selectedFacility,
//                                   dietary: selectedDietary,
//                                   atmosphere: selectedAtmosphere,
//                                 );
//                               },
//                         style: ElevatedButton.styleFrom(
//                           padding: EdgeInsets.symmetric(vertical: 16),
//                           backgroundColor: Colors.blue,
//                         ),
//                         child: videoController.isUploading.value
//                             ? Row(
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 children: [
//                                   SizedBox(
//                                     width: 20,
//                                     height: 20,
//                                     child: CircularProgressIndicator(
//                                       strokeWidth: 2,
//                                       color: Colors.white,
//                                     ),
//                                   ),
//                                   SizedBox(width: 8),
//                                   Text("Uploading..."),
//                                 ],
//                               )
//                             : Text("Upload"),
//                       )),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

//...................,,,,,,,,,,,,,,,,,,,,,----------------------------------------====================-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:video_player/video_player.dart';
// import 'package:savrly/controllers/video_controller.dart';

// class UploadVideoForm extends StatefulWidget {
//   @override
//   _UploadVideoFormState createState() => _UploadVideoFormState();
// }

// class _UploadVideoFormState extends State<UploadVideoForm> {
//   final nameController = TextEditingController();
//   final locationController = TextEditingController();
//   String? selectedRestaurant;
//   String? selectedFacility;
//   String? selectedDietary;
//   String? selectedAtmosphere;

//   final List<String> restaurants = [
//     'Kristalle',
//     'Bistro',
//     'Cafe Delight',
//     'The Grill'
//   ];
//   final List<String> facilities = [
//     'WiFi',
//     'Parking',
//     'Outdoor Seating',
//     'Wheelchair Access'
//   ];
//   final List<String> dietaryOptions = [
//     'Vegetarian',
//     'Vegan',
//     'Gluten-Free',
//     'Halal'
//   ];
//   final List<String> atmosphereOptions = [
//     'Family',
//     'Romantic',
//     'Business',
//     'Casual'
//   ];

//   @override
//   void dispose() {
//     nameController.dispose();
//     locationController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final videoController = Get.find<VideoController>();

//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         elevation: 0,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back, color: Colors.black),
//           onPressed: () {
//             final videoController = Get.find<VideoController>();
//             videoController.clearSelection();
//             videoController.toggleUploadMode();
//           },
//         ),
//       ),
//       body: SingleChildScrollView(
//         child: Center(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               const SizedBox(height: 40),
//               Obx(() {
//                 final hasVideo =
//                     videoController.videoPlayerController.value != null &&
//                         videoController
//                             .videoPlayerController.value!.value.isInitialized;

//                 return GestureDetector(
//                   onTap: () => videoController.pickVideo(context),
//                   child: Container(
//                     height: 289,
//                     width: 604,
//                     decoration: BoxDecoration(
//                       border: Border.all(color: Colors.black),
//                       borderRadius: BorderRadius.circular(16),
//                     ),
//                     child: hasVideo
//                         ? Stack(
//                             alignment: Alignment.center,
//                             children: [
//                               AspectRatio(
//                                 aspectRatio: videoController
//                                     .videoPlayerController
//                                     .value!
//                                     .value
//                                     .aspectRatio,
//                                 child: VideoPlayer(videoController
//                                     .videoPlayerController.value!),
//                               ),
//                               Positioned.fill(
//                                 child: GestureDetector(
//                                   onTap: () {
//                                     if (videoController.videoPlayerController
//                                         .value!.value.isPlaying) {
//                                       videoController
//                                           .videoPlayerController.value!
//                                           .pause();
//                                     } else {
//                                       videoController
//                                           .videoPlayerController.value!
//                                           .play();
//                                     }
//                                   },
//                                   child: Center(
//                                     child: Icon(
//                                       videoController.videoPlayerController
//                                               .value!.value.isPlaying
//                                           ? Icons.pause
//                                           : Icons.play_arrow,
//                                       size: 50,
//                                       color: Colors.white.withOpacity(0.7),
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                               Positioned(
//                                 bottom: 8,
//                                 right: 8,
//                                 child: Container(
//                                   padding: EdgeInsets.all(4),
//                                   decoration: BoxDecoration(
//                                     color: Colors.black54,
//                                     borderRadius: BorderRadius.circular(4),
//                                   ),
//                                   child: Text(
//                                     videoController.videoName.value,
//                                     style: TextStyle(
//                                         color: Colors.white, fontSize: 12),
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           )
//                         : Column(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: const [
//                               SizedBox(height: 12),
//                               Text("Upload video",
//                                   style: TextStyle(
//                                       fontWeight: FontWeight.bold,
//                                       fontSize: 18)),
//                               SizedBox(height: 24),
//                               Icon(Icons.upload_rounded, size: 40),
//                               SizedBox(height: 20),
//                               Text("Drag  video here",
//                                   style: TextStyle(fontSize: 16)),
//                             ],
//                           ),
//                   ),
//                 );
//               }),
//               const SizedBox(height: 30),

//               _buildTextField(nameController, "Kaistable", "Restaurant name"),

//               const SizedBox(height: 16),

//               _buildTextField(locationController,
//                   "United Stated, uncategorized.", "Location"),

//               const SizedBox(height: 16),

//               // Dropdowns
//               _buildDropdown("Restaurant", selectedRestaurant, restaurants,
//                   (value) {
//                 setState(() => selectedRestaurant = value);
//               }),
//               const SizedBox(height: 16),

//               _buildDropdown(
//                   "Facilities/ Services", selectedFacility, facilities,
//                   (value) {
//                 setState(() => selectedFacility = value);
//               }),
//               const SizedBox(height: 16),

//               _buildDropdown(
//                   "Dietary Preferences", selectedDietary, dietaryOptions,
//                   (value) {
//                 setState(() => selectedDietary = value);
//               }),
//               const SizedBox(height: 16),

//               _buildDropdown(
//                   "Atmosphere", selectedAtmosphere, atmosphereOptions, (value) {
//                 setState(() => selectedAtmosphere = value);
//               }),
//               const SizedBox(height: 30),

//               SizedBox(
//                 width: 604,
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     SizedBox(
//                       width: 136,
//                       height: 47,
//                       child: TextButton(
//                         onPressed: () {
//                           videoController.clearSelection();
//                           videoController.toggleUploadMode();
//                         },
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: Colors.transparent,
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(30),
//                           ),
//                           padding: EdgeInsets.symmetric(
//                               horizontal: 20), // Add left padding
//                           alignment: Alignment.centerLeft,
//                         ),
//                         child: const Text(
//                           "Cancel",
//                           style: TextStyle(
//                               color: Colors.red,
//                               fontWeight: FontWeight.w500,
//                               fontSize: 18),
//                         ),
//                       ),
//                     ),
//                     const SizedBox(width: 16),
//                     Obx(() => SizedBox(
//                           width: 136,
//                           height: 40,
//                           child: ElevatedButton(
//                             onPressed: videoController.isUploading.value
//                                 ? null
//                                 : () {
//                                     if (nameController.text.isEmpty ||
//                                         locationController.text.isEmpty) {
//                                       Get.snackbar("Error",
//                                           "Please fill required fields",
//                                           snackPosition: SnackPosition.BOTTOM,
//                                           backgroundColor: Colors.red,
//                                           colorText: Colors.white);
//                                       return;
//                                     }

//                                     if (videoController.pickedVideo.value ==
//                                         null) {
//                                       Get.snackbar("Error",
//                                           "Please select a video first",
//                                           snackPosition: SnackPosition.BOTTOM,
//                                           backgroundColor: Colors.red,
//                                           colorText: Colors.white);
//                                       return;
//                                     }

//                                     videoController.uploadVideo(
//                                       context: context,
//                                       restaurantName: nameController.text,
//                                       location: locationController.text,
//                                       restaurantType: selectedRestaurant,
//                                       facilities: selectedFacility,
//                                       dietary: selectedDietary,
//                                       atmosphere: selectedAtmosphere,
//                                     );
//                                   },
//                             style: ElevatedButton.styleFrom(
//                               backgroundColor: const Color(0xFF2FD2AF),
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(30),
//                               ),
//                             ),
//                             child: videoController.isUploading.value
//                                 ? const Row(
//                                     mainAxisAlignment: MainAxisAlignment.center,
//                                     children: [
//                                       SizedBox(
//                                         width: 20,
//                                         height: 20,
//                                         child: CircularProgressIndicator(
//                                             strokeWidth: 2,
//                                             color: Colors.white),
//                                       ),
//                                       SizedBox(width: 8),
//                                       Text("Uploading...",
//                                           style:
//                                               TextStyle(color: Colors.white)),
//                                     ],
//                                   )
//                                 : const Text("Upload",
//                                     style: TextStyle(
//                                       color: Colors.white,
//                                       fontWeight: FontWeight.w500,
//                                     )),
//                           ),
//                         )),
//                   ],
//                 ),
//               ),

//               const SizedBox(height: 40),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildTextField(
//       TextEditingController controller, String hint, String label) {
//     return SizedBox(
//       //height: 56,
//       width: 604,
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(label, style: const TextStyle(fontSize: 14)),
//           SizedBox(
//             height: 10,
//           ),
//           TextField(
//             controller: controller,
//             decoration: InputDecoration(
//               hintText: hint,
//               contentPadding:
//                   const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
//               border:
//                   OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildDropdown(String label, String? selectedValue,
//       List<String> options, ValueChanged<String?> onChanged) {
//     return SizedBox(
//       height: 56,
//       width: 604,
//       child: InputDecorator(
//         decoration: InputDecoration(
//           labelText: label,
//           contentPadding: const EdgeInsets.symmetric(horizontal: 16),
//           border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
//         ),
//         child: DropdownButtonHideUnderline(
//           child: DropdownButton<String>(
//             value: selectedValue,
//             isDense: true,
//             isExpanded: true,
//             hint: Text(label),
//             items: options.map((String value) {
//               return DropdownMenuItem<String>(value: value, child: Text(value));
//             }).toList(),
//             onChanged: onChanged,
//           ),
//         ),
//       ),
//     );
//   }
// }

//............................

// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:video_player/video_player.dart';
// import 'package:savrly/controllers/video_controller.dart';

// class UploadVideoForm extends StatefulWidget {
//   @override
//   _UploadVideoFormState createState() => _UploadVideoFormState();
// }

// class _UploadVideoFormState extends State<UploadVideoForm> {
//   final nameController = TextEditingController();
//   final locationController = TextEditingController();
//   String? selectedRestaurant;
//   String? selectedFacility;
//   String? selectedDietary;
//   String? selectedAtmosphere;

//   bool showNameError = false;
//   bool showLocationError = false;
//   bool showVideoError = false;

//   final List<String> restaurants = [
//     'Kristalle',
//     'Bistro',
//     'Cafe Delight',
//     'The Grill'
//   ];
//   final List<String> facilities = [
//     'WiFi',
//     'Parking',
//     'Outdoor Seating',
//     'Wheelchair Access'
//   ];
//   final List<String> dietaryOptions = [
//     'Vegetarian',
//     'Vegan',
//     'Gluten-Free',
//     'Halal'
//   ];
//   final List<String> atmosphereOptions = [
//     'Family',
//     'Romantic',
//     'Business',
//     'Casual'
//   ];

//   @override
//   void dispose() {
//     nameController.dispose();
//     locationController.dispose();
//     super.dispose();
//   }

//   void clearFormFields() {
//     nameController.clear();
//     locationController.clear();
//     selectedRestaurant = null;
//     selectedFacility = null;
//     selectedDietary = null;
//     selectedAtmosphere = null;
//     showNameError = false;
//     showLocationError = false;
//     showVideoError = false;
//   }

//   @override
//   Widget build(BuildContext context) {
//     final videoController = Get.find<VideoController>();

//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         elevation: 0,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back, color: Colors.black),
//           onPressed: () {
//             videoController.clearSelection();
//             videoController.toggleUploadMode();
//           },
//         ),
//       ),
//       body: SingleChildScrollView(
//         child: Center(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               const SizedBox(height: 40),
//               Obx(() {
//                 final hasVideo =
//                     videoController.videoPlayerController.value != null &&
//                         videoController.videoPlayerController.value!.value.isInitialized;

//                 return Column(
//                   children: [
//                     GestureDetector(
//                       onTap: () => videoController.pickVideo(context),
//                       child: Container(
//                         height: 289,
//                         width: 604,
//                         decoration: BoxDecoration(
//                           border: Border.all(color: Colors.black),
//                           borderRadius: BorderRadius.circular(16),
//                         ),
//                         child: hasVideo
//                             ? Stack(
//                                 alignment: Alignment.center,
//                                 children: [
//                                   AspectRatio(
//                                     aspectRatio: videoController
//                                         .videoPlayerController
//                                         .value!
//                                         .value
//                                         .aspectRatio,
//                                     child: VideoPlayer(
//                                         videoController.videoPlayerController.value!),
//                                   ),
//                                   Positioned.fill(
//                                     child: GestureDetector(
//                                       onTap: () {
//                                         if (videoController.videoPlayerController
//                                             .value!.value.isPlaying) {
//                                           videoController.videoPlayerController.value!.pause();
//                                         } else {
//                                           videoController.videoPlayerController.value!.play();
//                                         }
//                                       },
//                                       child: Center(
//                                         child: Icon(
//                                           videoController.videoPlayerController.value!.value.isPlaying
//                                               ? Icons.pause
//                                               : Icons.play_arrow,
//                                           size: 50,
//                                           color: Colors.white.withOpacity(0.7),
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                   Positioned(
//                                     bottom: 8,
//                                     right: 8,
//                                     child: Container(
//                                       padding: EdgeInsets.all(4),
//                                       decoration: BoxDecoration(
//                                         color: Colors.black54,
//                                         borderRadius: BorderRadius.circular(4),
//                                       ),
//                                       child: Text(
//                                         videoController.videoName.value,
//                                         style: TextStyle(
//                                             color: Colors.white, fontSize: 12),
//                                       ),
//                                     ),
//                                   ),
//                                 ],
//                               )
//                             : Column(
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 children: const [
//                                   SizedBox(height: 12),
//                                   Text("Upload video",
//                                       style: TextStyle(
//                                           fontWeight: FontWeight.bold,
//                                           fontSize: 18)),
//                                   SizedBox(height: 24),
//                                   Icon(Icons.upload_rounded, size: 40),
//                                   SizedBox(height: 20),
//                                   Text("upload  video here",
//                                       style: TextStyle(fontSize: 16)),
//                                 ],
//                               ),
//                       ),
//                     ),
//                     if (showVideoError)
//                       const Padding(
//                         padding: EdgeInsets.only(top: 8),
//                         child: Text(
//                           'Please select a video',
//                           style: TextStyle(color: Colors.red, fontSize: 12),
//                         ),
//                       ),
//                   ],
//                 );
//               }),
//               const SizedBox(height: 30),
//               _buildTextField(nameController, "Kaistable", "Restaurant name", showNameError),
//               const SizedBox(height: 16),
//               _buildTextField(locationController, "United States, uncategorized.", "Location", showLocationError),
//               const SizedBox(height: 16),
//               _buildDropdown("Restaurant", selectedRestaurant, restaurants, (value) {
//                 setState(() => selectedRestaurant = value);
//               }),
//               const SizedBox(height: 16),
//               _buildDropdown("Facilities/ Services", selectedFacility, facilities, (value) {
//                 setState(() => selectedFacility = value);
//               }),
//               const SizedBox(height: 16),
//               _buildDropdown("Dietary Preferences", selectedDietary, dietaryOptions, (value) {
//                 setState(() => selectedDietary = value);
//               }),
//               const SizedBox(height: 16),
//               _buildDropdown("Atmosphere", selectedAtmosphere, atmosphereOptions, (value) {
//                 setState(() => selectedAtmosphere = value);
//               }),
//               const SizedBox(height: 30),
//               SizedBox(
//                 width: 604,
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     SizedBox(
//                       width: 136,
//                       height: 47,
//                       child: TextButton(
//                         onPressed: () {
//                           videoController.clearSelection();
//                           videoController.toggleUploadMode();
//                         },
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: Colors.transparent,
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(30),
//                           ),
//                           padding: EdgeInsets.symmetric(horizontal: 20),
//                           alignment: Alignment.centerLeft,
//                         ),
//                         child: const Text(
//                           "Cancel",
//                           style: TextStyle(
//                               color: Colors.red,
//                               fontWeight: FontWeight.w500,
//                               fontSize: 18),
//                         ),
//                       ),
//                     ),
//                     const SizedBox(width: 16),
//                     Obx(() => SizedBox(
//                           width: 136,
//                           height: 40,
//                           child: ElevatedButton(
//                             onPressed: videoController.isUploading.value
//                                 ? null
//                                 : () async {
//                                     setState(() {
//                                       showNameError = nameController.text.isEmpty;
//                                       showLocationError = locationController.text.isEmpty;
//                                       showVideoError = videoController.pickedVideo.value == null;
//                                     });

//                                     if (showNameError || showLocationError || showVideoError) {
//                                       return;
//                                     }

//                                     await videoController.uploadVideo(
//                                       context: context,
//                                       restaurantName: nameController.text,
//                                       location: locationController.text,
//                                       restaurantType: selectedRestaurant,
//                                       facilities: selectedFacility,
//                                       dietary: selectedDietary,
//                                       atmosphere: selectedAtmosphere,
//                                     );

//                                     Get.snackbar("Success", "Video uploaded successfully!",
//                                         snackPosition: SnackPosition.BOTTOM,
//                                         backgroundColor: Colors.green,
//                                         colorText: Colors.white);

//                                     setState(() {
//                                       clearFormFields();
//                                       videoController.clearSelection();
//                                     });
//                                   },
//                             style: ElevatedButton.styleFrom(
//                               backgroundColor: const Color(0xFF2FD2AF),
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(30),
//                               ),
//                             ),
//                             child: videoController.isUploading.value
//                                 ? const Row(
//                                     mainAxisAlignment: MainAxisAlignment.center,
//                                     children: [
//                                       SizedBox(
//                                         width: 20,
//                                         height: 20,
//                                         child: CircularProgressIndicator(
//                                             strokeWidth: 2,
//                                             color: Colors.white),
//                                       ),
//                                       SizedBox(width: 8),
//                                       Text("Uploading...",
//                                           style: TextStyle(color: Colors.white)),
//                                     ],
//                                   )
//                                 : const Text("Upload",
//                                     style: TextStyle(
//                                       color: Colors.white,
//                                       fontWeight: FontWeight.w500,
//                                     )),
//                           ),
//                         )),
//                   ],
//                 ),
//               ),
//               const SizedBox(height: 40),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildTextField(TextEditingController controller, String hint, String label, bool showError) {
//     return SizedBox(
//       width: 604,
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(label, style: const TextStyle(fontSize: 14)),
//           const SizedBox(height: 10),
//           TextField(
//             controller: controller,
//             decoration: InputDecoration(
//               hintText: hint,
//               contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
//               border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
//             ),
//           ),
//           if (showError)
//             const Padding(
//               padding: EdgeInsets.only(top: 8),
//               child: Text(
//                 'This field is required',
//                 style: TextStyle(color: Colors.red, fontSize: 12),
//               ),
//             ),
//         ],
//       ),
//     );
//   }

//   Widget _buildDropdown(String label, String? selectedValue, List<String> options, ValueChanged<String?> onChanged) {
//     return SizedBox(
//       height: 56,
//       width: 604,
//       child: InputDecorator(
//         decoration: InputDecoration(
//           labelText: label,
//           contentPadding: const EdgeInsets.symmetric(horizontal: 16),
//           border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
//         ),
//         child: DropdownButtonHideUnderline(
//           child: DropdownButton<String>(
//             value: selectedValue,
//             isDense: true,
//             isExpanded: true,
//             hint: Text(label),
//             items: options.map((String value) {
//               return DropdownMenuItem<String>(value: value, child: Text(value));
//             }).toList(),
//             onChanged: onChanged,
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:savrly/constants/app_colors.dart';
import 'package:savrly/constants/text_styles.dart';
import 'package:savrly/models/resaturant_model.dart';
import 'package:video_player/video_player.dart';
import 'package:savrly/controllers/video_controller.dart';

class UploadVideoForm extends StatefulWidget {
  final bool isEdit;
  final Map<String, dynamic>? initialData; // For editing
  final String? docId; // Firebase doc ID

  const UploadVideoForm({
    super.key,
    this.isEdit = false,
    this.initialData,
    this.docId,
  });

  @override
  _UploadVideoFormState createState() => _UploadVideoFormState();
}

class _UploadVideoFormState extends State<UploadVideoForm> {
  final nameController = TextEditingController();
  final streetController = TextEditingController();
  final cityController = TextEditingController();
  final stateController = TextEditingController();
  final zipCodeController = TextEditingController();

  final videoController = Get.find<VideoController>();
  String? selectedRestaurant;
  String? selectCusine;
  String? selectAtmosphere;
  String? selectVibes;
  String? selectExperience;

  bool showNameError = false;
  bool showCityError = false;
  bool showStateError = false;
  bool showStreetError = false;
  bool showZipcodeError = false;

  bool showVideoError = false;

// 1. Add this to your state class
  List<RestaurantModel> allRestaurants = [];
  final List<String> causine = [
    "American",
    "Mexican",
    "Italian",
    "French",
    "Chinese",
    "Japanese",
    "Thai",
    "Indian",
    "Korean",
    "Vietnamese",
    "Mediterranean",
    "Caribbean",
    "African",
    "Middle Eastern",
    "Spanish",
    "Filipino",
    "Brazilian",
    "Peruvian",
    "Russian",
    "German",
  ];
  final List<String> atmosphere = [
    "Casual Dining",
    "Fine Dining",
    "Fast Food",
    "Date Night",
    "Candlelit",
    "Outdoor",
  ];
  final List<String> vibes = [
    "Brunch Party",
    "Bottomless Brunch",
    "Day Party",
    "Pool Party",
    "Happy Hours",
    "Open Bar",
    "Rooftop Vibes"
  ];

  final List<String> experinece = [
    "Live Music",
    "Dj Night",
    "Silent Party",
    "Karaoke",
    "Trivia Nights",
    "Sports screenings",
    "Hookah",
    "Sip & Paint",
    "Ladies Night",
    "RnB Night"
  ];
  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance.collection('restaurants').get().then((snapshot) {
      setState(() {
        allRestaurants = snapshot.docs
            .map((doc) => RestaurantModel.fromDocumentSnapshot(doc))
            .toList();
      });
    });

    if (widget.isEdit && widget.initialData != null) {
      nameController.text = widget.initialData!['restaurantName'] ?? '';
      streetController.text = widget.initialData!['streetNo'] ?? '';

      cityController.text = widget.initialData!['city'] ?? '';
      stateController.text = widget.initialData!['state'] ?? '';
      zipCodeController.text = widget.initialData!['zipCode'] ?? '';

      selectCusine = causine.contains(widget.initialData!['causines'])
          ? widget.initialData!['causines']
          : null;

      selectVibes = vibes.contains(widget.initialData!['vibes'])
          ? widget.initialData!['vibes']
          : null;

      selectAtmosphere = atmosphere.contains(widget.initialData!['atmosphere'])
          ? widget.initialData!['atmosphere']
          : null;

      selectExperience = experinece.contains(widget.initialData!['experience'])
          ? widget.initialData!['experience']
          : null;

      // If you stored video URL in Firebase, load video from URL:
      final url = widget.initialData!['url'];
      final controller = VideoPlayerController.network(url);
      controller.initialize().then((_) {
        videoController.videoPlayerController.value = controller;
        videoController.videoPlayerController.refresh();
        setState(() {});
      });
    }

    // Auto-update every second
    Timer.periodic(Duration(seconds: 1), (timer) {
      if (mounted &&
          videoController.videoPlayerController.value?.value.isInitialized ==
              true) {
        setState(() {}); // rebuild for timer & progress bar
      }
    });
  }

  @override
  void dispose() {
    nameController.dispose();
    streetController.dispose();
    cityController.dispose();
    stateController.dispose();
    zipCodeController.dispose();

    super.dispose();
  }

  void clearFormFields() {
    nameController.clear();
    streetController.clear();
    stateController.clear();
    cityController.clear();
    zipCodeController.clear();

    selectedRestaurant = null;
    selectAtmosphere = null;
    selectCusine = null;
    selectExperience = null;
    selectVibes = null;
    showNameError = false;
    showStreetError = false;
    showStateError = false;
    showCityError = false;
    showZipcodeError = false;
    showVideoError = false;
  }

  Widget _buildDropdown(String hint, String? value, List<String> options,
      ValueChanged<String?> onChanged) {
    return SizedBox(
      width: 604,
      height: 56,
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(horizontal: 20),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: const BorderSide(color: Colors.black),
          ),
        ),
        value: value,
        hint: Text(
          hint,
          style: simpleText.copyWith(fontSize: 14, fontWeight: FontWeight.w500),
        ),
        onChanged: onChanged,
        items: options
            .map((e) => DropdownMenuItem<String>(value: e, child: Text(e)))
            .toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              if (widget.isEdit) {
                // Edit mode ke liye flag off karein
                videoController.isEditMode.value = false;
              } else {
                // Add mode ke liye flag toggle karein
                videoController.toggleUploadMode();
              }
              // Dono case mein controller clear karein
              videoController.clearSelection();
            },
          ),
        ),
        body: SingleChildScrollView(
            child: Center(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
            Obx(() {
              final hasVideo =
                  videoController.videoPlayerController.value != null &&
                      videoController
                          .videoPlayerController.value!.value.isInitialized;

              return Column(
                children: [
                  GestureDetector(
                    onTap: hasVideo
                        ? null
                        : () => videoController.pickVideo(context),
                    child: Container(
                      height: 289,
                      width: 604,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: hasVideo
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: Stack(
                                children: [
                                  Container(
                                    color: Colors.black,
                                    width: double.infinity,
                                    child: Center(
                                      child: AspectRatio(
                                        aspectRatio: videoController
                                            .videoPlayerController
                                            .value!
                                            .value
                                            .aspectRatio,
                                        child: VideoPlayer(videoController
                                            .videoPlayerController.value!),
                                      ),
                                    ),
                                  ),
                                  // Play/Pause overlay
                                  Positioned.fill(
                                    child: GestureDetector(
                                      onTap: () {
                                        final controller = videoController
                                            .videoPlayerController.value!;
                                        controller.value.isPlaying
                                            ? controller.pause()
                                            : controller.play();
                                        setState(() {});
                                      },
                                      child: Center(
                                        child: Icon(
                                          videoController.videoPlayerController
                                                  .value!.value.isPlaying
                                              ? Icons.pause
                                              : Icons.play_arrow,
                                          size: 50,
                                          color: Colors.white.withOpacity(0.7),
                                        ),
                                      ),
                                    ),
                                  ),
                                  // Close (X) Button
                                  Positioned(
                                    top: 8,
                                    right: 8,
                                    child: InkWell(
                                      onTap: () {
                                        videoController.clearSelection();
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.black54,
                                          shape: BoxShape.circle,
                                        ),
                                        padding: const EdgeInsets.all(4),
                                        child: const Icon(Icons.close,
                                            color: Colors.white, size: 20),
                                      ),
                                    ),
                                  ),

                                  Positioned(
                                    bottom: 0,
                                    left: 0,
                                    right: 0,
                                    child: VideoProgressIndicator(
                                      videoController
                                          .videoPlayerController.value!,
                                      allowScrubbing: true,
                                      colors: const VideoProgressColors(
                                        playedColor: Colors.red,
                                        bufferedColor: Colors.grey,
                                        backgroundColor: Colors.black26,
                                      ),
                                    ),
                                  ),

                                  Positioned(
                                    bottom: 8,
                                    right: 12,
                                    child: Obx(() {
                                      final controller = videoController
                                          .videoPlayerController.value!;
                                      final position =
                                          controller.value.position;
                                      final duration =
                                          controller.value.duration;
                                      String format(Duration d) =>
                                          '${d.inMinutes}:${(d.inSeconds % 60).toString().padLeft(2, '0')}';

                                      return Text(
                                        '${format(position)} / ${format(duration)}',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      );
                                    }),
                                  ),
                                ],
                              ),
                            )
                          : Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Upload video",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                                Divider(
                                  color: Colors.black,
                                  thickness: 1,
                                ),
                                SizedBox(height: 24),
                                Image.asset(
                                  "assets/images/uploadIcon.png", // Your custom image
                                  width: 82,
                                  height: 82,
                                ),
                                SizedBox(height: 8),
                                Text(
                                  "upload video here",
                                  style: TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ),
                  if (showVideoError)
                    const Padding(
                      padding: EdgeInsets.only(top: 8),
                      child: Text(
                        'Please select a video',
                        style: TextStyle(color: Colors.red, fontSize: 12),
                      ),
                    ),
                ],
              );
            }),

            const SizedBox(height: 30),

            _buildTextField(
              nameController,
              "Kaistable",
              "Restaurant name",
              showNameError,
              prefixIcon: Icons.search,
            ),

            // No SizedBox here (Image shows no gap)
            SizedBox(
              height: 20,
            ),
            _buildTextField(
                streetController, "Street no", "Address", showStreetError),
            _buildTextField(cityController, "City", "", showCityError),
            _buildTextField(stateController, "State", "", showStateError),
            _buildTextField(
                zipCodeController, "Zip code", "", showZipcodeError),

            SizedBox(height: 30), // Equal spacing between address and dropdowns

            _buildDropdown("Cuisine", selectCusine, causine, (value) {
              setState(() => selectCusine = value);
            }),
            SizedBox(height: 20),

            _buildDropdown("Atmosphere", selectAtmosphere, atmosphere, (value) {
              setState(() => selectAtmosphere = value);
            }),
            SizedBox(height: 20),

            _buildDropdown("Vibes", selectVibes, vibes, (value) {
              setState(() => selectVibes = value);
            }),
            SizedBox(height: 20),

            _buildDropdown("Experience", selectExperience, experinece, (value) {
              setState(() => selectExperience = value);
            }),
            const SizedBox(height: 30),
            SizedBox(
              width: 604,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: SizedBox(
                      width: 136,
                      height: 47,
                      child: TextButton(
                        onPressed: () {
                          if (widget.isEdit) {
                            // Edit mode ke liye flag off karein
                            videoController.isEditMode.value = false;
                          } else {
                            // Add mode ke liye flag toggle karein
                            videoController.toggleUploadMode();
                          }
                          // Dono case mein controller clear karein
                          videoController.clearSelection();
                        },
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          minimumSize: Size(136, 47),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: const Text(
                          "Cancel",
                          style: TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.w500,
                              fontSize: 18),
                        ),
                      ),
                    ),
                  ),
                  Obx(
                    () => Align(
                      alignment: Alignment.centerRight,
                      child: SizedBox(
                        width: 150,
                        height: 40,
                        child: ElevatedButton(
                          onPressed: videoController.isUploading.value
                              ? null
                              : () async {
                                  setState(() {
                                    showNameError = nameController.text.isEmpty;

                                    showStreetError =
                                        streetController.text.isEmpty;
                                    showStateError =
                                        stateController.text.isEmpty;
                                    showCityError = cityController.text.isEmpty;
                                    showZipcodeError =
                                        zipCodeController.text.isEmpty;

                                    showVideoError = !widget.isEdit &&
                                        videoController.pickedVideo.value ==
                                            null;
                                  });

                                  if (showNameError ||
                                      showStreetError ||
                                      showStateError ||
                                      showCityError ||
                                      showZipcodeError ||
                                      showVideoError) return;

                                  if (widget.isEdit) {
                                    String? newVideoUrl;
                                    String? newFileName;

                                    // ✅ Instantly exit the edit form BEFORE doing any backend work
                                    videoController.isEditMode.value = false;
                                    videoController.isUploadMode.value = false;
                                    // 👇 Check if user selected new video
                                    if (videoController.pickedVideo.value !=
                                        null) {
                                      final result =
                                          await videoController.uploadVideoOnly(
                                        pickedFile:
                                            videoController.pickedVideo.value!,
                                      );
                                      newVideoUrl = result['url'];
                                      newFileName = result['fileName'];
                                    }

                                    // ✅ Update Firestore
                                    await FirebaseFirestore.instance
                                        .collection('videos')
                                        .doc(widget.docId)
                                        .update({
                                      'restaurantName': nameController.text,
                                      'state': stateController.text,
                                      'streetNo': streetController.text,
                                      'city': cityController.text,
                                      'zipCode': zipCodeController.text,
                                      'restaurantType': selectedRestaurant,
                                      'causines': selectCusine,
                                      'vibes': selectVibes,
                                      'atmosphere': selectAtmosphere,
                                      'experience': selectExperience,
                                      'timestamp': Timestamp.now(),
                                      if (newVideoUrl != null)
                                        'url': newVideoUrl,
                                      if (newFileName != null)
                                        'fileName': newFileName,
                                    });

                                    await videoController.fetchVideos();

                                    videoController.clearSelection();

                                    setState(() {
                                      clearFormFields();
                                    });

                                    Get.snackbar(
                                      "Updated",
                                      "Video info updated successfully",
                                      backgroundColor: Colors.green,
                                      colorText: Colors.white,
                                    );
                                  } else {
                                    // ✅ UPLOAD LOGIC
                                    await videoController.uploadVideo(
                                      context: context,
                                      restaurantName: nameController.text,
                                      streetNo: streetController.text,
                                      State: stateController.text,
                                      zipCode: zipCodeController.text,
                                      city: cityController.text,
                                      restaurantType: selectedRestaurant,
                                      atmosphere: selectAtmosphere,
                                      causine: selectCusine,
                                      experience: selectExperience,
                                      vibes: selectVibes,
                                    );

                                    setState(() {
                                      clearFormFields();
                                      videoController.clearSelection();
                                    });
                                  }
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF2FD2AF),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: videoController.isUploading.value
                              ? Text("Uploading...",
                                  style: TextStyle(color: Colors.white))
                              : Text(
                                  widget.isEdit ? "Update" : "Upload",
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ]),
        )));
  }

  Widget _buildTextField(
    TextEditingController controller,
    String hint,
    String label,
    bool showError, {
    IconData? prefixIcon,
  }) {
    return SizedBox(
      width: 604,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style:
                simpleText.copyWith(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: controller,
            decoration: InputDecoration(
              prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
              hintText: hint,
              hintStyle: simpleText.copyWith(
                  fontSize: 14, fontWeight: FontWeight.w500),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
            ),
          ),
          if (showError)
            const Padding(
              padding: EdgeInsets.only(top: 8),
              child: Text(
                'This field is required',
                style: TextStyle(color: Colors.red, fontSize: 12),
              ),
            ),
        ],
      ),
    );
  }
}

//   Widget _buildDropdown(String label, String? selectedValue,
//       List<String> options, ValueChanged<String?> onChanged) {
//     return SizedBox(
//       height: 56,
//       width: 604,
//       child: InputDecorator(
//         decoration: InputDecoration(
//           labelText: label,
//           contentPadding: const EdgeInsets.symmetric(horizontal: 16),
//           border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
//         ),
//         child: DropdownButtonHideUnderline(
//           child: DropdownButton<String>(
//             value: selectedValue,
//             isDense: true,
//             isExpanded: true,
//             hint: Text(label),
//             items: options.map((String value) {
//               return DropdownMenuItem<String>(value: value, child: Text(value));
//             }).toList(),
//             onChanged: onChanged,
//           ),
//         ),
//       ),
//     );
//   }
// }



///old code 
///
///
  //        SizedBox(
                        //             width: 136,
                        //             height: 40,
                        //             child: ElevatedButton(
                        //               onPressed: videoController.isUploading.value
                        //                   ? null
                        //                   : () async {
                        //                       setState(() {
                        //                         showNameError =
                        //                             nameController.text.isEmpty;
                        //                         showLocationError =
                        //                             locationController.text.isEmpty;
                        //                         showVideoError =
                        //                             videoController.pickedVideo.value ==
                        //                                 null;
                        //                       });

                        //                       if (showNameError ||
                        //                           showLocationError ||
                        //                           showVideoError) {
                        //                         return;
                        //                       }

                        //                       await videoController.uploadVideo(
                        //                         context: context,
                        //                         restaurantName: nameController.text,
                        //                         location: locationController.text,
                        //                         restaurantType: selectedRestaurant,
                        //                         atmosphere: selectAtmosphere,
                        //                         causine: selectCusine,
                        //                         experience: selectExperience,
                        //                         vibes: selectExperience,
                        //                       );

                        //                       setState(() {
                        //                         clearFormFields();
                        //                         videoController.clearSelection();
                        //                       });
                        //                     },
                        //               style: ElevatedButton.styleFrom(
                        //                 backgroundColor: const Color(0xFF2FD2AF),
                        //                 shape: RoundedRectangleBorder(
                        //                   borderRadius: BorderRadius.circular(30),
                        //                 ),
                        //               ),
                        //               child: videoController.isUploading.value
                        //                   ? const Row(
                        //                       mainAxisAlignment: MainAxisAlignment.center,
                        //                       children: [
                        //                         SizedBox(
                        //                           width: 20,
                        //                           height: 20,
                        //                           child: CircularProgressIndicator(
                        //                               strokeWidth: 2,
                        //                               color: Colors.white),
                        //                         ),
                        //                         SizedBox(width: 8),
                        //                         Text("Uploading...",
                        //                             style:
                        //                                 TextStyle(color: Colors.white)),
                        //                       ],
                        //                     )
                        //                   : const Text("Upload",
                        //                       style: TextStyle(
                        //                         color: Colors.white,
                        //                         fontWeight: FontWeight.w500,
                        //                       )),
                        //             ),
                        //           )),
                        //     ],
                        //   ),
                        // ),



//-------------------------


 // File name tag
                                  // Positioned(
                                  //   bottom: 8,
                                  //   right: 8,
                                  //   child: Container(
                                  //     padding: const EdgeInsets.symmetric(
                                  //         horizontal: 6, vertical: 2),
                                  //     decoration: BoxDecoration(
                                  //       color: Colors.black54,
                                  //       borderRadius:
                                  //           BorderRadius.circular(4),
                                  //     ),
                                  //     child: Text(
                                  //       videoController.videoName.value,
                                  //       style: const TextStyle(
                                  //           color: Colors.white,
                                  //           fontSize: 12),
                                  //     ),
                                  //   ),
                                  // ),

                                  // Add this below the Close (X) and Filename tag