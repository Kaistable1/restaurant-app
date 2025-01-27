import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';


// class ItemListScreen extends StatelessWidget {
//   final ItemController itemController = Get.put(ItemController());
//   final TextEditingController nameController = TextEditingController();
//   final TextEditingController descriptionController = TextEditingController();
//   final TextEditingController priceController = TextEditingController();
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
//             const SizedBox(height: 10),
//             ElevatedButton.icon(
//               onPressed: () => itemController.pickImages(),
//               icon: const Icon(Icons.add_photo_alternate),
//               label: const Text('Add Images'),
//             ),
//             const SizedBox(height: 20),
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
//             const SizedBox(height: 20),
//             Expanded(
//               child: Obx(
//                     () => ListView.builder(
//                   itemCount: itemController.items.length,
//                   itemBuilder: (context, index) {
//                     final item = itemController.items[index];
//                     return Card(
//                       margin: const EdgeInsets.only(bottom: 10),
//                       child: Padding(
//                         padding: const EdgeInsets.all(10),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text('Name: ${item['name']}',
//                                 style: const TextStyle(
//                                     fontWeight: FontWeight.bold)),
//                             Text('Description: ${item['description']}'),
//                             Text('Price: ${item['price']}'),
//                             const SizedBox(height: 10),
//                             Wrap(
//                               spacing: 8,
//                               children: (item['images'] as List<XFile>)
//                                   .map((image) => Image.network(
//                                 image.path,
//                                 width: 50,
//                                 height: 50,
//                                 fit: BoxFit.cover,
//                               ))
//                                   .toList(),
//                             ),
//                           ],
//                         ),
//                       ),
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

class ItemController extends GetxController {
  var items = <Map<String, dynamic>>[].obs;
  var images = <XFile>[].obs;
  final offerController = TextEditingController();

  void addItem(String name, String description, String price) {
    if (name.isNotEmpty && description.isNotEmpty && price.isNotEmpty) {
      items.add({
        'name': name,
        'description': description,
        'price': price,
        'images': images.toList(), // Add images list
      });
      images.clear(); // Clear images after adding item
    } else {
     print('Please fill all fields');
    }
  }

  Future<void> pickImages() async {
    final ImagePicker picker = ImagePicker();
    final pickedFiles = await picker.pickMultiImage();
    if (pickedFiles != null) {
      images.addAll(pickedFiles);
    }
  }
}
