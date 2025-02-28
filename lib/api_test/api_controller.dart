// import 'package:get/get.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
//
// import 'api_model.dart';
//
// class PostController extends GetxController {
//   var isLoading = true.obs;
//   var postList = <Post>[].obs;
//
//   @override
//   void onInit() {
//     fetchPosts();
//     super.onInit();
//   }
//
//   void fetchPosts() async {
//     try {
//       isLoading(true);
//       final response = await http.get(Uri.parse("https://jsonplaceholder.typicode.com/posts"));
//       if (response.statusCode == 200) {
//         List jsonData = jsonDecode(response.body);
//         postList.value = jsonData.map((json) => Post.fromJson(json)).toList();
//       }
//     } catch (e) {
//       print("Error fetching posts: $e");
//     } finally {
//       isLoading(false);
//     }
//   }
// }
