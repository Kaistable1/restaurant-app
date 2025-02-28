// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'api_controller.dart';
//
// class ApiTest extends StatelessWidget {
//   final PostController postController = Get.put(PostController());
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("GetX API Example")),
//       body: Obx(() {
//         if (postController.isLoading.value) {
//           return Center(child: CircularProgressIndicator());
//         }
//         if (postController.postList.isEmpty) {
//           return Center(child: Text("No data found"));
//         }
//         return ListView.builder(
//           itemCount: postController.postList.length,
//           itemBuilder: (context, index) {
//             final post = postController.postList[index];
//             return ListTile(
//               title: Text(post.title),
//               subtitle: Text(post.body),
//             );
//           },
//         );
//       }),
//     );
//   }
// }
