import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import 'universal_models/discount_model.dart';

// class ItemListScreen extends StatelessWidget {
//   final ItemControllerTwo itemController = Get.put(ItemControllerTwo());
//   final TextEditingController nameController = TextEditingController();
//   final TextEditingController descriptionController = TextEditingController();
//   final TextEditingController priceController = TextEditingController();
//   final TextEditingController categoryController = TextEditingController();
//   final TextEditingController subcategoryController = TextEditingController();
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Add Items with Model'),
//         centerTitle: true,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Input for Item Details
//             TextField(
//               controller: nameController,
//               decoration: const InputDecoration(labelText: 'Name'),
//             ),
//             const SizedBox(height: 10),
//             TextField(
//               controller: descriptionController,
//               decoration: const InputDecoration(labelText: 'Description'),
//             ),
//             const SizedBox(height: 10),
//             TextField(
//               controller: priceController,
//               decoration: const InputDecoration(labelText: 'Price'),
//               keyboardType: TextInputType.number,
//             ),
//             const SizedBox(height: 10),
//
//             // Images
//             Obx(
//                   () => Wrap(
//                 spacing: 8,
//                 children: itemController.images.map((image) {
//                   return Stack(
//                     children: [
//                       Image.network(
//                         image,
//                         width: 80,
//                         height: 80,
//                         fit: BoxFit.cover,
//                       ),
//                       Positioned(
//                         top: 0,
//                         right: 0,
//                         child: IconButton(
//                           icon: const Icon(Icons.close, color: Colors.red),
//                           onPressed: () {
//                             itemController.images.remove(image);
//                           },
//                         ),
//                       ),
//                     ],
//                   );
//                 }).toList(),
//               ),
//             ),
//             ElevatedButton.icon(
//               onPressed: () => itemController.pickImages(),
//               icon: const Icon(Icons.add_photo_alternate),
//               label: const Text('Add Images'),
//             ),
//             const SizedBox(height: 20),
//
//             // Add Single Item
//             ElevatedButton(
//               onPressed: () {
//                 itemController.addItem(
//                   nameController.text,
//                   descriptionController.text,
//                   priceController.text,
//                 );
//                 nameController.clear();
//                 descriptionController.clear();
//                 priceController.clear();
//               },
//               child: const Text('Add Item'),
//             ),
//
//             const SizedBox(height: 20),
//
//             // Input for Category and Subcategory
//             TextField(
//               controller: categoryController,
//               decoration: const InputDecoration(labelText: 'Category'),
//             ),
//             const SizedBox(height: 10),
//             TextField(
//               controller: subcategoryController,
//               decoration: const InputDecoration(labelText: 'Subcategory'),
//             ),
//             const SizedBox(height: 10),
//             ElevatedButton(
//               onPressed: () {
//                 itemController.addCategoryAndSubcategory(
//                   categoryController.text,
//                   subcategoryController.text,
//                   lifeTime: true,
//                   isAllDay: true,
//                 );
//                 categoryController.clear();
//                 subcategoryController.clear();
//               },
//               child: const Text('Add Category & Subcategory'),
//             ),
//
//             const SizedBox(height: 20),
//
//             // Display Categories and Items
//             Expanded(
//               child: Obx(
//                     () => ListView.builder(
//                   itemCount: itemController.categoryItems.length,
//                   itemBuilder: (context, index) {
//                     final category = itemController.categoryItems[index];
//                     return ExpansionTile(
//                       title: Text(
//                         '${category.category} - ${category.subcategory}',
//                         style: const TextStyle(fontWeight: FontWeight.bold),
//                       ),
//                       children: category.items.map((item) {
//                         return ListTile(
//                           title: Text('Name: ${item.name}'),
//                           subtitle: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text('Description: ${item.description}'),
//                               Text('Price: ${item.offer}'),
//                               Wrap(
//                                 spacing: 8,
//                                 children: item.images.map((image) {
//                                   return Image.network(
//                                     image,
//                                     width: 50,
//                                     height: 50,
//                                     fit: BoxFit.cover,
//                                   );
//                                 }).toList(),
//                               ),
//                             ],
//                           ),
//                         );
//                       }).toList(),
//                     );
//                   },
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

class ItemControllerTwo extends GetxController {
  var images = <String>[].obs;
  var items = <ItemModel>[].obs;
  var categoryItems = <CategoryModel>[].obs;

  // void addItem(String name, String description, String price) {
  //   if (name.isNotEmpty && description.isNotEmpty && price.isNotEmpty) {
  //     items.add(ItemModel(
  //       name: name,
  //       description: description,
  //       offer: price,
  //       images: images.toList(),
  //     ));
  //     images.clear();
  //   }
  // }

  // void addCategoryAndSubcategory(String category, String subcategory,
  //     {String? fromDate,
  //     String? toDate,
  //     String? percentageValue,
  //     String? FromTime,
  //     String? ToTime,
  //     String? offerController,
  //     String? discountType,
  //     fromTimeType,
  //     String? toTimeType,
  //     required bool lifeTime,
  //     required bool isAllDay}) {
  //   if (category.isNotEmpty && subcategory.isNotEmpty && items.isNotEmpty) {
  //     categoryItems.add(CategoryModel(
  //       category: category,
  //       fromDate: fromDate ?? '',
  //       toDate: toDate ?? '',
  //       lifeTime: lifeTime,
  //       isAllDay: isAllDay,
  //       percentageValue: percentageValue ?? '',
  //       FromTime: FromTime ?? '',
  //       ToTime: ToTime ?? '',
  //       discountType: discountType ?? '',
  //       toTimeType: toTimeType ?? '',
  //       subcategory: subcategory,
  //       items: items.toList(),
  //     ));
  //     items.clear();
  //   }
  // }



  // Fetch data as a JSON-like structure
  List<Map<String, dynamic>> getAllData() {
    return categoryItems.map((category) => category.toMap()).toList();
  }

  Future<void> saveCategoryToFirestore() async {
    Get.defaultDialog(
      title: 'Saving Data',
      content: const CircularProgressIndicator(),
      barrierDismissible: false,
    );
    try {
      // for (var category in categoryItems) {
      await FirebaseFirestore.instance
          .collection('restaurants')
          .doc("qA4ZwrICw8NWshCaZ52a5dqgDSj2")
          .collection("MealMenu")
          .add({
        'menu': categoryItems.map((category) => category.toMap()).toList(),
        'timestamp': FieldValue.serverTimestamp(),
        'toDate': categoryItems.first.toDate,
        'fromDate': categoryItems.first.fromDate,
        'discountType': categoryItems.first.discountType,
      });
      // }
      print('Data saved to Firestore successfully!');
      categoryItems.clear();
      Get.back();
    } catch (e) {
      print('Error saving data to Firestore: $e');
    }
  }
}



// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:image_picker/image_picker.dart';
//
// class ItemListScreen extends StatelessWidget {
//   final ItemControllerTwo itemController = Get.put(ItemControllerTwo());
//   final TextEditingController nameController = TextEditingController();
//   final TextEditingController descriptionController = TextEditingController();
//   final TextEditingController priceController = TextEditingController();
//   final TextEditingController categoryController = TextEditingController();
//   final TextEditingController subcategoryController = TextEditingController();
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Add Items'),
//         centerTitle: true,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Input for Item Details
//             TextField(
//               controller: nameController,
//               decoration: const InputDecoration(labelText: 'Name'),
//             ),
//             const SizedBox(height: 10),
//             TextField(
//               controller: descriptionController,
//               decoration: const InputDecoration(labelText: 'Description'),
//             ),
//             const SizedBox(height: 10),
//             TextField(
//               controller: priceController,
//               decoration: const InputDecoration(labelText: 'Price'),
//               keyboardType: TextInputType.number,
//             ),
//             const SizedBox(height: 10),
//
//             // Images
//             Obx(
//                   () => Wrap(
//                 spacing: 8,
//                 children: itemController.images.map((image) {
//                   return Stack(
//                     children: [
//                       Image.network(
//                         image.path,
//                         width: 80,
//                         height: 80,
//                         fit: BoxFit.cover,
//                       ),
//                       Positioned(
//                         top: 0,
//                         right: 0,
//                         child: IconButton(
//                           icon: const Icon(Icons.close, color: Colors.red),
//                           onPressed: () {
//                             itemController.images.remove(image);
//                           },
//                         ),
//                       ),
//                     ],
//                   );
//                 }).toList(),
//               ),
//             ),
//             ElevatedButton.icon(
//               onPressed: () => itemController.pickImages(),
//               icon: const Icon(Icons.add_photo_alternate),
//               label: const Text('Add Images'),
//             ),
//             const SizedBox(height: 20),
//
//             // Add Single Item
//             ElevatedButton(
//               onPressed: () {
//                 itemController.addItem(
//                   nameController.text,
//                   descriptionController.text,
//                   priceController.text,
//                 );
//                 nameController.clear();
//                 descriptionController.clear();
//                 priceController.clear();
//               },
//               child: const Text('Add Item'),
//             ),
//
//             const SizedBox(height: 20),
//
//             // Input for Category and Subcategory
//             TextField(
//               controller: categoryController,
//               decoration: const InputDecoration(labelText: 'Category'),
//             ),
//             const SizedBox(height: 10),
//             TextField(
//               controller: subcategoryController,
//               decoration: const InputDecoration(labelText: 'Subcategory'),
//             ),
//             const SizedBox(height: 10),
//             ElevatedButton(
//               onPressed: () {
//                 itemController.addCategoryAndSubcategory(
//                   categoryController.text,
//                   subcategoryController.text,
//                 );
//                 categoryController.clear();
//                 subcategoryController.clear();
//               },
//               child: const Text('Add Category & Subcategory'),
//             ),
//
//             const SizedBox(height: 20),
//
//             // Display Categories and Items
//             Expanded(
//               child: Obx(
//                     () => ListView.builder(
//                   itemCount: itemController.categoryItems.length,
//                   itemBuilder: (context, index) {
//                     final category = itemController.categoryItems[index];
//                     return ExpansionTile(
//                       title: Text(
//                         '${category['category']} - ${category['subcategory']}',
//                         style: const TextStyle(fontWeight: FontWeight.bold),
//                       ),
//                       children: (category['items'] as List<Map<String, dynamic>>)
//                           .map((item) {
//                         return ListTile(
//                           title: Text('Name: ${item['name']}'),
//                           subtitle: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text('Description: ${item['description']}'),
//                               Text('Price: ${item['price']}'),
//                               Wrap(
//                                 spacing: 8,
//                                 children: (item['images'] as List<XFile>)
//                                     .map((image) => Image.network(
//                                   image.path,
//                                   width: 50,
//                                   height: 50,
//                                   fit: BoxFit.cover,
//                                 ))
//                                     .toList(),
//                               ),
//                             ],
//                           ),
//                         );
//                       }).toList(),
//                     );
//                   },
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// class ItemControllerTwo extends GetxController {
//   var items = <Map<String, dynamic>>[].obs; // Temporary list for added items
//   var images = <XFile>[].obs; // Images for the current item
//   var categoryItems = <Map<String, dynamic>>[].obs; // Final list of category with items
//
//   Future<void> pickImages() async {
//     final ImagePicker picker = ImagePicker();
//     final pickedFiles = await picker.pickMultiImage();
//     if (pickedFiles != null) {
//       images.addAll(pickedFiles);
//     }
//   }
//
//   void addItem(String name, String description, String price) {
//     if (name.isNotEmpty && description.isNotEmpty && price.isNotEmpty) {
//       items.add({
//         'name': name,
//         'description': description,
//         'price': price,
//         'images': images.toList(),
//       });
//       images.clear(); // Clear images after adding item
//     }
//   }
//
//   void addCategoryAndSubcategory(String category, String subcategory) {
//     if (category.isNotEmpty && subcategory.isNotEmpty && items.isNotEmpty) {
//       categoryItems.add({
//         'category': category,
//         'subcategory': subcategory,
//         'items': items.toList(), // Add all items to the category
//       });
//       items.clear(); // Clear items after adding to category
//     }
//   }
// }

// Future<void> saveCategoryToFirestore() async {
//   assignDiscountData(); // Assign values before saving
//
//   if (discountModel == null) {
//     print("No discount data to save.");
//     return;
//   }
//   Get.defaultDialog(
//     title: 'Saving Data',
//     content: const CircularProgressIndicator(),
//     barrierDismissible: false,
//   );
//   try {
//     // for (var category in categoryItems) {
//     await FirebaseFirestore.instance
//         .collection('restaurants')
//         .doc(auth.currentUser!.uid)
//         .collection("MealMenu")
//         .add({
//       'menu': categoryItems.map((category) => category.toMap()).toList(),
//       'timestamp': FieldValue.serverTimestamp(),
//       'toDate': categoryItems.first.toDate,
//       'fromDate': categoryItems.first.fromDate,
//       'discountType': categoryItems.first.discountType,
//     });
//
//     print('Data saved to Firestore successfully!');
//     categoryItems.clear();
//     Get.back();
//   } catch (e) {
//     print('Error saving data to Firestore: $e');
//   }
// }