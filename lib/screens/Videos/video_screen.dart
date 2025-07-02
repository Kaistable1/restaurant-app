// // import 'package:cloud_firestore/cloud_firestore.dart';
// // import 'package:firebase_storage/firebase_storage.dart';
// // import 'package:flutter/foundation.dart'; // for kIsWeb
// // import 'package:flutter/material.dart';
// // import 'package:image_picker/image_picker.dart';

// // import 'video_player_widget.dart'; // 👈 import your custom widget
// // import 'dart:typed_data';

// // class AdminVideoPanel extends StatefulWidget {
// //   const AdminVideoPanel({Key? key}) : super(key: key);

// //   @override
// //   State<AdminVideoPanel> createState() => _AdminVideoPanelState();
// // }

// // class _AdminVideoPanelState extends State<AdminVideoPanel> {
// //   List<Map<String, dynamic>> videoDataList = [];

// //   @override
// //   void initState() {
// //     super.initState();
// //     fetchVideos();
// //   }

// //   Future<void> fetchVideos() async {
// //     final snapshot = await FirebaseFirestore.instance
// //         .collection('videos')
// //         .orderBy('timestamp', descending: true)
// //         .get();

// //     setState(() {
// //       videoDataList = snapshot.docs
// //           .map((doc) => doc.data())
// //           .cast<Map<String, dynamic>>()
// //           .toList();
// //     });
// //   }

// //   Future<void> pickAndUploadVideoForAdmin() async {
// //     final picker = ImagePicker();
// //     final picked = await picker.pickVideo(source: ImageSource.gallery);
// //     if (picked == null) return;

// //     Uint8List bytes = await picked.readAsBytes();
// //     final fileName = 'videos/${DateTime.now().millisecondsSinceEpoch}.mp4';
// //     final ref = FirebaseStorage.instance.ref().child(fileName);

// //     final captionController = TextEditingController();
// //     final nameController = TextEditingController();
// //     final addressController = TextEditingController();

// //     final shouldUpload = await showDialog<bool>(
// //       context: context,
// //       builder: (_) => AlertDialog(
// //         title: const Text('Upload Video'),
// //         content: Column(
// //           mainAxisSize: MainAxisSize.min,
// //           children: [
// //             TextField(
// //               controller: captionController,
// //               decoration: const InputDecoration(labelText: 'Caption'),
// //             ),
// //             TextField(
// //               controller: nameController,
// //               decoration: const InputDecoration(labelText: 'Restaurant Name'),
// //             ),
// //             TextField(
// //               controller: addressController,
// //               decoration: const InputDecoration(labelText: 'Address'),
// //             ),
// //           ],
// //         ),
// //         actions: [
// //           TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
// //           ElevatedButton(
// //             onPressed: () {
// //               if (captionController.text.isNotEmpty &&
// //                   nameController.text.isNotEmpty &&
// //                   addressController.text.isNotEmpty) {
// //                 Navigator.pop(context, true);
// //               }
// //             },
// //             child: const Text('Upload'),
// //           ),
// //         ],
// //       ),
// //     );

// //     if (shouldUpload != true) return;

// //     try {
// //       final uploadTask = ref.putData(bytes);
// //       final snapshot = await uploadTask.whenComplete(() => null);

// //       if (snapshot.state == TaskState.success) {
// //         final downloadUrl = await ref.getDownloadURL();

// //         await FirebaseFirestore.instance.collection('videos').add({
// //           'url': downloadUrl,
// //           'caption': captionController.text,
// //           'restaurantName': nameController.text,
// //           'restaurantAddress': addressController.text,
// //           'timestamp': Timestamp.now(),
// //         });

// //         ScaffoldMessenger.of(context).showSnackBar(
// //           const SnackBar(content: Text('Video uploaded successfully!')),
// //         );

// //         fetchVideos();
// //       } else {
// //         throw Exception('Upload failed');
// //       }
// //     } catch (e) {
// //       ScaffoldMessenger.of(context).showSnackBar(
// //         SnackBar(content: Text('Upload failed: $e')),
// //       );
// //     }
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: const Text('Admin Video Panel'),
// //         actions: [
// //           IconButton(
// //             icon: const Icon(Icons.upload),
// //             onPressed: pickAndUploadVideoForAdmin,
// //           ),
// //         ],
// //       ),
// //       body: videoDataList.isEmpty
// //           ? const Center(child: Text('No videos uploaded yet'))
// //           : GridView.builder(
// //               padding: const EdgeInsets.all(10),
// //               itemCount: videoDataList.length,
// //               gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
// //                 crossAxisCount: 2,
// //                 mainAxisSpacing: 10,
// //                 crossAxisSpacing: 10,
// //                 childAspectRatio: 9 / 16,
// //               ),
// //               itemBuilder: (context, index) {
// //                 final video = videoDataList[index];
// //                 return Stack(
// //                   fit: StackFit.expand,
// //                   children: [
// //                     Container(
// //                       color: Colors.black12,
// //                       child: VideoPlayerWidget(videoUrl: video['url']),
// //                     ),
// //                     Positioned(
// //                       bottom: 8,
// //                       left: 8,
// //                       right: 8,
// //                       child: Container(
// //                         color: Colors.black54,
// //                         padding: const EdgeInsets.all(4),
// //                         child: Column(
// //                           crossAxisAlignment: CrossAxisAlignment.start,
// //                           children: [
// //                             Text(
// //                               video['restaurantName'] ?? '',
// //                               style: const TextStyle(
// //                                   color: Colors.white, fontWeight: FontWeight.bold),
// //                             ),
// //                             Text(
// //                               video['restaurantAddress'] ?? '',
// //                               style: const TextStyle(color: Colors.white, fontSize: 12),
// //                             ),
// //                           ],
// //                         ),
// //                       ),
// //                     ),
// //                   ],
// //                 );
// //               },
// //             ),
// //     );
// //   }
// // }

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/material.dart';
// import 'package:video_player/video_player.dart';
// import 'package:image_picker/image_picker.dart';

// class AdminVideoPanel extends StatefulWidget {
//   const AdminVideoPanel({Key? key}) : super(key: key);

//   @override
//   State<AdminVideoPanel> createState() => _AdminVideoPanelState();
// }

// class _AdminVideoPanelState extends State<AdminVideoPanel> {
//   List<Map<String, dynamic>> videoDataList = [];
//   final List<VideoPlayerController> _controllers = [];

//   @override
//   void initState() {
//     super.initState();
//     fetchVideos();
//   }

//   @override
//   void dispose() {
//     for (var controller in _controllers) {
//       controller.dispose();
//     }
//     super.dispose();
//   }

//   Future<void> fetchVideos() async {
//     final snapshot = await FirebaseFirestore.instance
//         .collection('videos')
//         .orderBy('timestamp', descending: true)
//         .get();

//     videoDataList = snapshot.docs
//         .map((doc) => doc.data())
//         .cast<Map<String, dynamic>>()
//         .toList();

//     _controllers.clear();

//     for (var data in videoDataList) {
//       final controller = VideoPlayerController.network(data['url']);
//       await controller.initialize();
//       controller.setLooping(true);
//       _controllers.add(controller);
//     }

//     setState(() {});
//   }

//   Future<void> pickAndUploadVideoForAdmin() async {
//     final picker = ImagePicker();
//     final picked = await picker.pickVideo(source: ImageSource.gallery);
//     if (picked == null) return;

//     final bytes = await picked.readAsBytes();
//     final fileName = 'videos/${DateTime.now().millisecondsSinceEpoch}.mp4';
//     final ref = FirebaseStorage.instance.ref().child(fileName);

//     final captionController = TextEditingController();
//     final nameController = TextEditingController();
//     final addressController = TextEditingController();

//     final shouldUpload = await showDialog<bool>(
//       context: context,
//       builder: (_) => AlertDialog(
//         title: const Text('Upload Video'),
//         content: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             TextField(controller: captionController, decoration: const InputDecoration(labelText: 'Caption')),
//             TextField(controller: nameController, decoration: const InputDecoration(labelText: 'Restaurant Name')),
//             TextField(controller: addressController, decoration: const InputDecoration(labelText: 'Address')),
//           ],
//         ),
//         actions: [
//           TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
//           ElevatedButton(
//             onPressed: () {
//               if (captionController.text.isNotEmpty &&
//                   nameController.text.isNotEmpty &&
//                   addressController.text.isNotEmpty) {
//                 Navigator.pop(context, true);
//               }
//             },
//             child: const Text('Upload'),
//           ),
//         ],
//       ),
//     );

//     if (shouldUpload != true) return;

//     try {
//       final uploadTask = ref.putData(bytes);
//       final snapshot = await uploadTask.whenComplete(() => null);

//       if (snapshot.state == TaskState.success) {
//         final downloadUrl = await ref.getDownloadURL();

//         await FirebaseFirestore.instance.collection('videos').add({
//           'url': downloadUrl,
//           'caption': captionController.text,
//           'restaurantName': nameController.text,
//           'restaurantAddress': addressController.text,
//           'timestamp': Timestamp.now(),
//         });

//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Video uploaded successfully!')),
//         );

//         fetchVideos();
//       } else {
//         throw Exception('Upload failed');
//       }
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Upload failed: $e')));
//     }
//   }

//   void _pauseOtherVideos(int currentIndex) {
//     for (int i = 0; i < _controllers.length; i++) {
//       if (i != currentIndex && _controllers[i].value.isPlaying) {
//         _controllers[i].pause();
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Admin Video Panel'),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.upload),
//             onPressed: pickAndUploadVideoForAdmin,
//           ),
//         ],
//       ),
//       body: _controllers.isEmpty
//           ? const Center(child: CircularProgressIndicator())
//           : GridView.builder(
//               padding: const EdgeInsets.all(12),
//               itemCount: videoDataList.length,
//               gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                 crossAxisCount: 3, // 3 videos per row
//                 crossAxisSpacing: 10,
//                 mainAxisSpacing: 10,
//                 childAspectRatio: 9 / 16,
//               ),
//               itemBuilder: (context, index) {
//                 final video = videoDataList[index];
//                 final controller = _controllers[index];

//                 return Stack(
//                   fit: StackFit.expand,
//                   children: [
//                     ClipRRect(
//                       borderRadius: BorderRadius.circular(10),
//                       child: AspectRatio(
//                         aspectRatio: controller.value.aspectRatio,
//                         child: VideoPlayer(controller),
//                       ),
//                     ),
//                     Align(
//                       alignment: Alignment.center,
//                       child: IconButton(
//                         iconSize: 40,
//                         icon: Icon(
//                           controller.value.isPlaying ? Icons.pause_circle : Icons.play_circle,
//                           color: Colors.white,
//                         ),
//                         onPressed: () {
//                           setState(() {
//                             _pauseOtherVideos(index);
//                             controller.value.isPlaying ? controller.pause() : controller.play();
//                           });
//                         },
//                       ),
//                     ),
//                     Positioned(
//                       bottom: 0,
//                       left: 0,
//                       right: 0,
//                       child: Container(
//                         padding: const EdgeInsets.all(8),
//                         color: Colors.black54,
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           mainAxisSize: MainAxisSize.min,
//                           children: [
//                             Text(
//                               video['restaurantName'] ?? '',
//                               style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
//                             ),
//                             Text(
//                               video['restaurantAddress'] ?? '',
//                               style: const TextStyle(color: Colors.white, fontSize: 12),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ],
//                 );
//               },
//             ),
//     );
//   }
// }

// ✅ Updated Flutter Admin Video Panel with Image-style Grid (like your design)
// ✅ Final Updated Admin Video Panel with Video Playback + Modern Design

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:video_player/video_player.dart';

// class AdminVideoPanel extends StatefulWidget {
//   const AdminVideoPanel({Key? key}) : super(key: key);

//   @override
//   State<AdminVideoPanel> createState() => _AdminVideoPanelState();
// }

// class _AdminVideoPanelState extends State<AdminVideoPanel> {
//   List<Map<String, dynamic>> videoDataList = [];
//   final List<VideoPlayerController> _controllers = [];

//   @override
//   void initState() {
//     super.initState();
//     fetchVideos();
//   }

//   @override
//   void dispose() {
//     for (var controller in _controllers) {
//       controller.dispose();
//     }
//     super.dispose();
//   }

//   Future<void> fetchVideos() async {
//     final snapshot = await FirebaseFirestore.instance
//         .collection('videos')
//         .orderBy('timestamp', descending: true)
//         .get();

//     videoDataList = snapshot.docs
//         .map((doc) => doc.data())
//         .cast<Map<String, dynamic>>()
//         .toList();

//     _controllers.clear();

//     for (var data in videoDataList) {
//       final controller = VideoPlayerController.network(data['url']);
//       await controller.initialize();
//       controller.setLooping(true);
//       _controllers.add(controller);
//     }

//     setState(() {});
//   }

//   Future<void> pickAndUploadVideoForAdmin() async {
//     final picker = ImagePicker();
//     final picked = await picker.pickVideo(source: ImageSource.gallery);
//     if (picked == null) return;

//     final bytes = await picked.readAsBytes();
//     final fileName = 'videos/${DateTime.now().millisecondsSinceEpoch}.mp4';
//     final ref = FirebaseStorage.instance.ref().child(fileName);

//     final captionController = TextEditingController();
//     final nameController = TextEditingController();
//     final addressController = TextEditingController();

//     final shouldUpload = await showDialog<bool>(
//       context: context,
//       builder: (_) => AlertDialog(
//         title: const Text('Upload Video'),
//         content: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             TextField(
//                 controller: captionController,
//                 decoration: const InputDecoration(labelText: 'Caption')),
//             TextField(
//                 controller: nameController,
//                 decoration:
//                     const InputDecoration(labelText: 'Restaurant Name')),
//             TextField(
//                 controller: addressController,
//                 decoration: const InputDecoration(labelText: 'Address')),
//           ],
//         ),
//         actions: [
//           TextButton(
//               onPressed: () => Navigator.pop(context, false),
//               child: const Text('Cancel')),
//           ElevatedButton(
//             onPressed: () {
//               if (captionController.text.isNotEmpty &&
//                   nameController.text.isNotEmpty &&
//                   addressController.text.isNotEmpty) {
//                 Navigator.pop(context, true);
//               }
//             },
//             child: const Text('Upload'),
//           ),
//         ],
//       ),
//     );

//     if (shouldUpload != true) return;

//     try {
//       final uploadTask = ref.putData(bytes);
//       final snapshot = await uploadTask.whenComplete(() => null);

//       if (snapshot.state == TaskState.success) {
//         final downloadUrl = await ref.getDownloadURL();

//         await FirebaseFirestore.instance.collection('videos').add({
//           'url': downloadUrl,
//           'caption': captionController.text,
//           'restaurantName': nameController.text,
//           'restaurantAddress': addressController.text,
//           'timestamp': Timestamp.now(),
//         });

//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Video uploaded successfully!')),
//         );

//         fetchVideos();
//       } else {
//         throw Exception('Upload failed');
//       }
//     } catch (e) {
//       ScaffoldMessenger.of(context)
//           .showSnackBar(SnackBar(content: Text('Upload failed: $e')));
//     }
//   }

//   void _pauseOtherVideos(int currentIndex) {
//     for (int i = 0; i < _controllers.length; i++) {
//       if (i != currentIndex && _controllers[i].value.isPlaying) {
//         _controllers[i].pause();
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Padding(
//               padding:
//                   const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   const Text(
//                     "Videos",
//                     style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
//                   ),
//                   GestureDetector(
//                     onTap: pickAndUploadVideoForAdmin,
//                     child: Container(
//                       padding: const EdgeInsets.all(6),
//                       decoration: const BoxDecoration(
//                         color: Colors.green,
//                         shape: BoxShape.circle,
//                       ),
//                       child:
//                           const Icon(Icons.add, color: Colors.white, size: 20),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             Expanded(
//               child: _controllers.isEmpty
//                   ? const Center(child: CircularProgressIndicator())
//                   : GridView.builder(
//                       padding: const EdgeInsets.symmetric(horizontal: 16),
//                       itemCount: videoDataList.length,
//                       gridDelegate:
//                           const SliverGridDelegateWithFixedCrossAxisCount(
//                         crossAxisCount: 4,
//                         crossAxisSpacing: 12,
//                         mainAxisSpacing: 12,
//                         childAspectRatio: 1, // Not full vertical height
//                       ),
//                       itemBuilder: (context, index) {
//                         final controller = _controllers[index];
//                         return GestureDetector(
//                           onTap: () {
//                             setState(() {
//                               _pauseOtherVideos(index);
//                               controller.value.isPlaying
//                                   ? controller.pause()
//                                   : controller.play();
//                             });
//                           },
//                           child: ClipRRect(
//                             borderRadius: BorderRadius.circular(12),
//                             child: Container(
//                               color: Colors.black, // fallback background
//                               child: Stack(
//                                 fit: StackFit.expand,
//                                 children: [
//                                   // Center-crop video inside fixed box
//                                   controller.value.isInitialized
//                                       ? FittedBox(
//                                           fit: BoxFit.cover,
//                                           child: SizedBox(
//                                             width: controller.value.size.width,
//                                             height:
//                                                 controller.value.size.height,
//                                             child: VideoPlayer(controller),
//                                           ),
//                                         )
//                                       : const Center(
//                                           child: CircularProgressIndicator()),
//                                   // Dark overlay for visibility
//                                   Container(
//                                       color: Colors.black.withOpacity(0.2)),
//                                   // Reels icon top-right
//                                   Positioned(
//                                     top: 8,
//                                     right: 8,
//                                     child: Container(
//                                       padding: const EdgeInsets.all(4),
//                                       decoration: BoxDecoration(
//                                         color: Colors.white.withOpacity(0.9),
//                                         borderRadius: BorderRadius.circular(20),
//                                       ),
//                                       child: const Icon(
//                                         Icons.video_collection_rounded,
//                                         size: 16,
//                                         color: Colors.black87,
//                                       ),
//                                     ),
//                                   ),
//                                   // Play/Pause icon center
//                                   Align(
//                                     alignment: Alignment.center,
//                                     child: Icon(
//                                       controller.value.isPlaying
//                                           ? Icons.pause_circle_filled
//                                           : Icons.play_circle_fill,
//                                       color: Colors.white,
//                                       size: 40,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                         );
//                       },
//                     ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:get/get_core/src/get_main.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:savrly/controllers/video_controller.dart';
// import 'package:video_player/video_player.dart';

// class AdminVideoPanel extends StatefulWidget {
//   const AdminVideoPanel({Key? key}) : super(key: key);

//   @override
//   State<AdminVideoPanel> createState() => _AdminVideoPanelState();
// }

// class _AdminVideoPanelState extends State<AdminVideoPanel> {
//   List<Map<String, dynamic>> videoDataList = [];
//   final List<VideoPlayerController> _controllers = [];
//   bool _isUploading = false;
//   double _uploadProgress = 0.0;
//   final videoController = Get.put(VideoController());

// @override
// void initState() {
//   super.initState();
//   videoController.fetchVideos();
// }

//   @override
//   void dispose() {
//     for (var controller in _controllers) {
//       controller.dispose();
//     }
//     super.dispose();
//   }

//   Future<void> fetchVideos() async {
//     final snapshot = await FirebaseFirestore.instance
//         .collection('videos')
//         .orderBy('timestamp', descending: true)
//         .get();

//     videoDataList = snapshot.docs
//         .map((doc) => {'id': doc.id, ...doc.data()})
//         .cast<Map<String, dynamic>>()
//         .toList();

//     _controllers.clear();

//     for (var data in videoDataList) {
//       final controller = VideoPlayerController.network(data['url']);
//       await controller.initialize();
//       controller.setLooping(true);
//       _controllers.add(controller);
//     }

//     setState(() {});
//   }

//  Future<void> pickAndUploadVideoForAdmin() async {
//   final picker = ImagePicker();
//   final picked = await picker.pickVideo(source: ImageSource.gallery);
//   if (picked == null) return;

//   final fileName = 'videos/${DateTime.now().millisecondsSinceEpoch}.mp4';
//   final ref = FirebaseStorage.instance.ref().child(fileName);

//   final captionController = TextEditingController();
//   final nameController = TextEditingController();
//   final addressController = TextEditingController();

//   // Show dialog and get inputs
//   final shouldUpload = await showDialog<bool>(
//     context: context,
//     builder: (_) {
//       return StatefulBuilder(
//         builder: (context, setState) => AlertDialog(
//           title: const Text('Upload Video'),
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               TextField(
//                 controller: captionController,
//                 decoration: const InputDecoration(labelText: 'Caption'),
//               ),
//               TextField(
//                 controller: nameController,
//                 decoration: const InputDecoration(labelText: 'Restaurant Name'),
//               ),
//               TextField(
//                 controller: addressController,
//                 decoration: const InputDecoration(labelText: 'Address'),
//               ),
//             ],
//           ),
//           actions: [
//             TextButton(
//                 onPressed: () => Navigator.pop(context, false),
//                 child: const Text('Cancel')),
//             ElevatedButton(
//               onPressed: () {
//                 if (captionController.text.isNotEmpty &&
//                     nameController.text.isNotEmpty &&
//                     addressController.text.isNotEmpty) {
//                   Navigator.pop(context, true); // Close dialog immediately
//                 }
//               },
//               child: const Text('Upload'),
//             ),
//           ],
//         ),
//       );
//     },
//   );

//   // If canceled or incomplete, return
//   if (shouldUpload != true) return;

//   try {
//     setState(() {
//       _isUploading = true;
//       _uploadProgress = 0.0;
//     });

//     final uploadTask = ref.putData(await picked.readAsBytes());

//     uploadTask.snapshotEvents.listen((event) {
//       setState(() {
//         _uploadProgress =
//             (event.bytesTransferred / event.totalBytes).clamp(0.0, 1.0);
//       });
//     });

//     final snapshot = await uploadTask;

//     if (snapshot.state == TaskState.success) {
//       final downloadUrl = await ref.getDownloadURL();

//       await FirebaseFirestore.instance.collection('videos').add({
//         'url': downloadUrl,
//         'caption': captionController.text,
//         'restaurantName': nameController.text,
//         'restaurantAddress': addressController.text,
//         'timestamp': Timestamp.now(),
//       });

//       fetchVideos();

//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: const Text('Video uploaded successfully!'),
//           backgroundColor: Colors.green,
//           behavior: SnackBarBehavior.floating,
//           margin: const EdgeInsets.only(top: 20, left: 16, right: 16),
//         ),
//       );
//     } else {
//       throw Exception('Upload failed');
//     }
//   } catch (e) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text('Upload failed: $e'),
//         backgroundColor: Colors.red,
//       ),
//     );
//   } finally {
//     setState(() {
//       _isUploading = false;
//       _uploadProgress = 0.0;
//     });
//   }
// }

//   void _pauseOtherVideos(int currentIndex) {
//     for (int i = 0; i < _controllers.length; i++) {
//       if (i != currentIndex && _controllers[i].value.isPlaying) {
//         _controllers[i].pause();
//       }
//     }
//   }

//   Future<void> _confirmDelete(String docId, int index) async {
//     final confirm = await showDialog<bool>(
//       context: context,
//       builder: (_) => AlertDialog(
//         title: const Text('Delete Video'),
//         content: const Text('Are you sure you want to delete this video?'),
//         actions: [
//           TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
//           ElevatedButton(onPressed: () => Navigator.pop(context, true), child: const Text('Delete')),
//         ],
//       ),
//     );

//     if (confirm == true) {
//       await FirebaseFirestore.instance.collection('videos').doc(docId).delete();
//       _controllers[index].dispose();
//       fetchVideos();
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       children: [
//         Scaffold(
//           body: SafeArea(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Padding(
//                   padding:
//                       const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       const Text(
//                         "Videos",
//                         style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
//                       ),
//                       GestureDetector(
//                         onTap: pickAndUploadVideoForAdmin,
//                         child: Container(
//                           padding: const EdgeInsets.all(6),
//                           decoration: const BoxDecoration(
//                             color: Colors.green,
//                             shape: BoxShape.circle,
//                           ),
//                           child:
//                               const Icon(Icons.add, color: Colors.white, size: 20),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 Expanded(
//                   child: _controllers.isEmpty
//                       ? const Center(child: CircularProgressIndicator())
//                       : GridView.builder(
//                           padding: const EdgeInsets.symmetric(horizontal: 16),
//                           itemCount: videoDataList.length,
//                           gridDelegate:
//                               const SliverGridDelegateWithFixedCrossAxisCount(
//                             crossAxisCount: 3,
//                             crossAxisSpacing: 12,
//                             mainAxisSpacing: 12,
//                             childAspectRatio: 1,
//                           ),
//                           itemBuilder: (context, index) {
//                             final controller = _controllers[index];
//                             final data = videoDataList[index];

//                             return GestureDetector(
//                               onTap: () {
//                                 setState(() {
//                                   _pauseOtherVideos(index);
//                                   controller.value.isPlaying
//                                       ? controller.pause()
//                                       : controller.play();
//                                 });
//                               },
//                               child: ClipRRect(
//                                 borderRadius: BorderRadius.circular(12),
//                                 child: Container(
//                                   color: Colors.black,
//                                   child: Stack(
//                                     fit: StackFit.expand,
//                                     children: [
//                                       controller.value.isInitialized
//                                           ? FittedBox(
//                                               fit: BoxFit.cover,
//                                               child: SizedBox(
//                                                 width:
//                                                     controller.value.size.width,
//                                                 height:
//                                                     controller.value.size.height,
//                                                 child: VideoPlayer(controller),
//                                               ),
//                                             )
//                                           : const Center(
//                                               child:
//                                                   CircularProgressIndicator()),
//                                       Container(
//                                           color: Colors.black.withOpacity(0.2)),
//                                       Positioned(
//                                         top: 8,
//                                         right: 8,
//                                         child: Container(
//                                           padding: const EdgeInsets.all(4),
//                                           decoration: BoxDecoration(
//                                             color:
//                                                 Colors.white.withOpacity(0.9),
//                                             borderRadius:
//                                                 BorderRadius.circular(20),
//                                           ),
//                                           child: const Icon(
//                                             Icons.video_collection_rounded,
//                                             size: 16,
//                                             color: Colors.black87,
//                                           ),
//                                         ),
//                                       ),
//                                       Positioned(
//                                         top: 8,
//                                         left: 8,
//                                         child: GestureDetector(
//                                           onTap: () => _confirmDelete(
//                                               data['id'], index),
//                                           child: Container(
//                                             padding: const EdgeInsets.all(4),
//                                             decoration: BoxDecoration(
//                                               color:
//                                                   Colors.white.withOpacity(0.9),
//                                               borderRadius:
//                                                   BorderRadius.circular(20),
//                                             ),
//                                             child: const Icon(
//                                               Icons.delete,
//                                               size: 16,
//                                               color: Colors.red,
//                                             ),
//                                           ),
//                                         ),
//                                       ),
//                                       Align(
//                                         alignment: Alignment.center,
//                                         child: Icon(
//                                           controller.value.isPlaying
//                                               ? Icons.pause_circle_filled
//                                               : Icons.play_circle_fill,
//                                           color: Colors.white,
//                                           size: 40,
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                             );
//                           },
//                         ),
//                 )
//               ],
//             ),
//           ),
//         ),
//         if (_isUploading)
//           Container(
//             color: Colors.black.withOpacity(0.7),
//             child: Center(
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   const Text(
//                     "Uploading...",
//                     style: TextStyle(color: Colors.white, fontSize: 18),
//                   ),
//                   const SizedBox(height: 12),
//                   CircularProgressIndicator(value: _uploadProgress),
//                   const SizedBox(height: 8),
//                   Text(
//                     "${(_uploadProgress * 100).toStringAsFixed(0)}%",
//                     style: const TextStyle(color: Colors.white),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//       ],
//     );
//   }
// }

//-----------------

// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:savrly/controllers/video_controller.dart';
// import 'package:video_player/video_player.dart';

// class AdminVideoPanel extends StatelessWidget {
//   AdminVideoPanel({super.key});

//   final videoController = Get.put(VideoController());

//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       children: [
//         Scaffold(
//           body: SafeArea(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.symmetric(
//                       horizontal: 16.0, vertical: 12),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       const Text(
//                         "Videos",
//                         style: TextStyle(
//                             fontSize: 22, fontWeight: FontWeight.bold),
//                       ),
//                       GestureDetector(
//                         onTap: () {
//                           videoController.toggleUploadMode();

//                           //videoController.pickAndUploadVideoForAdmin(context);
//                         },
//                         child: Container(
//                           padding: const EdgeInsets.all(6),
//                           decoration: const BoxDecoration(
//                             color: Colors.green,
//                             shape: BoxShape.circle,
//                           ),
//                           child: const Icon(Icons.add,
//                               color: Colors.white, size: 20),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),

//                 GetBuilder<VideoController>(
//                   builder: (controller) {
//                     final videoDataList = controller.videoDataList;
//                     final controllers = controller.controllers;

//                     if (videoDataList.isEmpty || controllers.isEmpty) {
//                       return const Expanded(
//                         child: Center(child: CircularProgressIndicator()),
//                       );
//                     }

//                     return Expanded(
//                       child: GridView.builder(
//                         padding: const EdgeInsets.symmetric(horizontal: 16),
//                         itemCount: videoDataList.length,
//                         gridDelegate:
//                             const SliverGridDelegateWithFixedCrossAxisCount(
//                           crossAxisCount: 3,
//                           crossAxisSpacing: 12,
//                           mainAxisSpacing: 12,
//                           childAspectRatio: 1,
//                         ),
//                         itemBuilder: (context, index) {
//                           final data = videoDataList[index];
//                           if (index >= controllers.length) {
//                             return const SizedBox(); // safety fallback
//                           }

//                           final controller = controllers[index];

//                           return GestureDetector(
//                             onTap: () {
//                               controller.value.isPlaying
//                                   ? controller.pause()
//                                   : controller.play();
//                               videoController.pauseOtherVideos(index);
//                             },
//                             child: ClipRRect(
//                               borderRadius: BorderRadius.circular(12),
//                               child: Container(
//                                 color: Colors.black,
//                                 child: Stack(
//                                   fit: StackFit.expand,
//                                   children: [
//                                     controller.value.isInitialized
//                                         ? FittedBox(
//                                             fit: BoxFit.cover,
//                                             child: SizedBox(
//                                               width:
//                                                   controller.value.size.width,
//                                               height:
//                                                   controller.value.size.height,
//                                               child: VideoPlayer(controller),
//                                             ),
//                                           )
//                                         : const Center(
//                                             child: CircularProgressIndicator()),
//                                     Container(
//                                         color: Colors.black.withOpacity(0.2)),
//                                     Positioned(
//                                       top: 8,
//                                       right: 8,
//                                       child: Container(
//                                         padding: const EdgeInsets.all(4),
//                                         decoration: BoxDecoration(
//                                           color: Colors.white.withOpacity(0.9),
//                                           borderRadius:
//                                               BorderRadius.circular(20),
//                                         ),
//                                         child: const Icon(
//                                           Icons.video_collection_rounded,
//                                           size: 16,
//                                           color: Colors.black87,
//                                         ),
//                                       ),
//                                     ),
//                                     Positioned(
//                                       top: 8,
//                                       left: 8,
//                                       child: GestureDetector(
//                                         onTap: () async {
//                                           final confirm =
//                                               await showDialog<bool>(
//                                             context: context,
//                                             builder: (context) => AlertDialog(
//                                               title: const Text("Delete Video"),
//                                               content: const Text(
//                                                   "Are you sure you want to delete this video?"),
//                                               actions: [
//                                                 TextButton(
//                                                   onPressed: () =>
//                                                       Navigator.pop(
//                                                           context, false),
//                                                   child: const Text("Cancel"),
//                                                 ),
//                                                 ElevatedButton(
//                                                   onPressed: () =>
//                                                       Navigator.pop(
//                                                           context, true),
//                                                   style:
//                                                       ElevatedButton.styleFrom(
//                                                           backgroundColor:
//                                                               Colors.red),
//                                                   child: const Text("Delete"),
//                                                 ),
//                                               ],
//                                             ),
//                                           );

//                                           if (confirm == true) {
//                                             videoController.deleteVideo(
//                                                 data['id'], index);
//                                           }
//                                         },
//                                         child: Container(
//                                           padding: const EdgeInsets.all(4),
//                                           decoration: BoxDecoration(
//                                             color:
//                                                 Colors.white.withOpacity(0.9),
//                                             borderRadius:
//                                                 BorderRadius.circular(20),
//                                           ),
//                                           child: const Icon(
//                                             Icons.delete,
//                                             size: 16,
//                                             color: Colors.red,
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//                                     Align(
//                                       alignment: Alignment.center,
//                                       child: AnimatedBuilder(
//                                         animation: controller,
//                                         builder: (context, _) {
//                                           return Icon(
//                                             controller.value.isPlaying
//                                                 ? Icons.pause_circle_filled
//                                                 : Icons.play_circle_fill,
//                                             color: Colors.white,
//                                             size: 40,
//                                           );
//                                         },
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                           );
//                         },
//                       ),
//                     );
//                   },
//                 ),
//               ],
//             ),
//           ),
//         ),
//         Obx(() {
//           if (!videoController.isUploading.value) return const SizedBox();
//           return Container(
//             color: Colors.black.withOpacity(0.7),
//             child: Center(
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   const Text(
//                     "Uploading...",
//                     style: TextStyle(color: Colors.white, fontSize: 18),
//                   ),
//                   const SizedBox(height: 12),
//                   CircularProgressIndicator(
//                       value: videoController.uploadProgress.value),
//                   const SizedBox(height: 8),
//                   Text(
//                     "${(videoController.uploadProgress.value * 100).toStringAsFixed(0)}%",
//                     style: const TextStyle(color: Colors.white),
//                   ),
//                 ],
//               ),
//             ),
//           );
//         }),
//       ],
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:savrly/controllers/video_controller.dart';
// import 'package:video_player/video_player.dart';
// import 'upload_video_form.dart'; // Create this widget separately

// class AdminVideoPanel extends StatelessWidget {
//   AdminVideoPanel({super.key});

//   final videoController = Get.put(VideoController());

//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       children: [
//         Scaffold(

//           body: SafeArea(
//             child: Obx(() => videoController.isUploadMode.value
//                 ? UploadVideoForm() // Upload form view
//                 : Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Padding(
//                         padding: const EdgeInsets.symmetric(
//                             horizontal: 16.0, vertical: 12),
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             const Text(
//                               "Videos",
//                               style: TextStyle(
//                                   fontSize: 22, fontWeight: FontWeight.bold),
//                             ),
//                             GestureDetector(
//                               onTap: () {
//                                 videoController.toggleUploadMode();
//                                   videoController.clearSelection();
//                               },
//                               child: Container(
//                                 padding: const EdgeInsets.all(6),
//                                 decoration: const BoxDecoration(
//                                   color: Colors.green,
//                                   shape: BoxShape.circle,
//                                 ),
//                                 child: const Icon(Icons.add,
//                                     color: Colors.white, size: 20),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),

//                       GetBuilder<VideoController>(
//                         builder: (controller) {
//                           final videoDataList = controller.videoDataList;
//                           final controllers = controller.controllers;

//                           if (videoDataList.isEmpty || controllers.isEmpty) {
//                             return const Expanded(
//                               child: Center(child: CircularProgressIndicator()),
//                             );
//                           }

//                           return Expanded(
//                             child: GridView.builder(
//                               padding:
//                                   const EdgeInsets.symmetric(horizontal: 16),
//                               itemCount: videoDataList.length,
//                               gridDelegate:
//                                   const SliverGridDelegateWithFixedCrossAxisCount(
//                                 crossAxisCount: 3,
//                                 crossAxisSpacing: 12,
//                                 mainAxisSpacing: 12,
//                                 childAspectRatio: 1,
//                               ),
//                               itemBuilder:
//                               (context, index) {
//                                 final data = videoDataList[index];
//                                 if (index >= controllers.length) {
//                                   return const SizedBox();
//                                 }

//                                 final controller = controllers[index];

//                                 return GestureDetector(
//                                   onTap: () {
//                                     controller.value.isPlaying
//                                         ? controller.pause()
//                                         : controller.play();
//                                     videoController.pauseOtherVideos(index);
//                                   },
//                                   child: ClipRRect(
//                                     borderRadius: BorderRadius.circular(12),
//                                     child: Container(
//                                       color: Colors.black,
//                                       child: Stack(
//                                         fit: StackFit.expand,
//                                         children: [
//                                           controller.value.isInitialized
//                                               ? FittedBox(
//                                                   fit: BoxFit.cover,
//                                                   child: SizedBox(
//                                                     width: controller
//                                                         .value.size.width,
//                                                     height: controller
//                                                         .value.size.height,
//                                                     child:
//                                                         VideoPlayer(controller),
//                                                   ),
//                                                 )
//                                               : const Center(
//                                                   child:
//                                                       CircularProgressIndicator()),
//                                           Container(
//                                               color: Colors.black
//                                                   .withOpacity(0.2)),

//                                           Positioned(
//                                             top: 8,
//                                             left: 8,
//                                             child: GestureDetector(
//                                               onTap: () async {
//                                                 final confirm =
//                                                     await showDialog<bool>(
//                                                   context: context,
//                                                   builder: (context) =>
//                                                       AlertDialog(
//                                                     title: const Text(
//                                                         "Delete Video"),
//                                                     content: const Text(
//                                                         "Are you sure you want to delete this video?"),
//                                                     actions: [
//                                                       TextButton(
//                                                         onPressed: () =>
//                                                             Navigator.pop(
//                                                                 context,
//                                                                 false),
//                                                         child:
//                                                             const Text("Cancel"),
//                                                       ),
//                                                       ElevatedButton(
//                                                         onPressed: () =>
//                                                             Navigator.pop(
//                                                                 context, true),
//                                                         style: ElevatedButton
//                                                             .styleFrom(
//                                                                 backgroundColor:
//                                                                     Colors.red),
//                                                         child: const Text(
//                                                             "Delete"),
//                                                       ),
//                                                     ],
//                                                   ),
//                                                 );

//                                                 if (confirm == true) {
//                                                   videoController.deleteVideo(
//                                                       data['id'], index);
//                                                 }
//                                               },
//                                               child: Container(
//                                                 padding:
//                                                     const EdgeInsets.all(4),
//                                                 decoration: BoxDecoration(
//                                                   color: Colors.white
//                                                       .withOpacity(0.9),
//                                                   borderRadius:
//                                                       BorderRadius.circular(20),
//                                                 ),
//                                                 child: const Icon(
//                                                   Icons.delete,
//                                                   size: 16,
//                                                   color: Colors.red,
//                                                 ),
//                                               ),
//                                             ),
//                                           ),
//                                           Align(
//                                             alignment: Alignment.center,
//                                             child: AnimatedBuilder(
//                                               animation: controller,
//                                               builder: (context, _) {
//                                                 return Icon(
//                                                   controller.value.isPlaying
//                                                       ? Icons
//                                                           .pause_circle_filled
//                                                       : Icons
//                                                           .play_circle_fill,
//                                                   color: Colors.white,
//                                                   size: 40,
//                                                 );
//                                               },
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                   ),
//                                 );
//                               },
//                             ),
//                           );
//                         },
//                       ),
//                     ],
//                   )),
//           ),
//         ),
//         Obx(() {
//           if (!videoController.isUploading.value) return const SizedBox();
//           return Container(
//             color: Colors.black.withOpacity(0.7),
//             child: Center(
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   const Text(
//                     "Uploading...",
//                     style: TextStyle(color: Colors.white, fontSize: 18),
//                   ),
//                   const SizedBox(height: 12),
//                   CircularProgressIndicator(
//                       value: videoController.uploadProgress.value),
//                   const SizedBox(height: 8),
//                   Text(
//                     "${(videoController.uploadProgress.value * 100).toStringAsFixed(0)}%",
//                     style: const TextStyle(color: Colors.white),
//                   ),
//                 ],
//               ),
//             ),
//           );
//         }),
//       ],
//     );
//   }
// }

//update code------------

// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:savrly/controllers/video_controller.dart';
// import 'package:savrly/screens/Videos/view_Video.dart';
// import 'package:video_player/video_player.dart';
// import 'upload_video_form.dart'; // Create this widget separately

// class AdminVideoPanel extends StatelessWidget {
//   AdminVideoPanel({super.key});

//   final videoController = Get.put(VideoController());

//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       children: [
//         Scaffold(
//           body: SafeArea(
//             child: Obx(() => videoController.isUploadMode.value
//                 ? UploadVideoForm() // Upload form view
//                 : Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Padding(
//                         padding: const EdgeInsets.symmetric(
//                             horizontal: 16.0, vertical: 12),
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             const Text(
//                               "Videos",
//                               style: TextStyle(
//                                   fontSize: 22, fontWeight: FontWeight.bold),
//                             ),
//                             GestureDetector(
//                               onTap: () {
//                                 videoController.toggleUploadMode();
//                                 videoController.clearSelection();
//                               },
//                               child: Container(
//                                 padding: const EdgeInsets.all(6),
//                                 decoration: const BoxDecoration(
//                                   color: Colors.green,
//                                   shape: BoxShape.circle,
//                                 ),
//                                 child: const Icon(Icons.add,
//                                     color: Colors.white, size: 20),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                       GetBuilder<VideoController>(
//                         builder: (controller) {
//                           final videoDataList = controller.videoDataList;
//                           final controllers = controller.controllers;

//                           if (videoDataList.isEmpty || controllers.isEmpty) {
//                             return const Expanded(
//                               child: Center(child: CircularProgressIndicator()),
//                             );
//                           }

//                           return Expanded(
//                             child: GridView.builder(
//                               padding:
//                                   const EdgeInsets.symmetric(horizontal: 16),
//                               itemCount: videoDataList.length,
//                               gridDelegate:
//                                   const SliverGridDelegateWithFixedCrossAxisCount(
//                                 crossAxisCount: 3,
//                                 crossAxisSpacing: 12,
//                                 mainAxisSpacing: 12,
//                                 childAspectRatio:
//                                     0.8, // Adjusted to accommodate text below
//                               ),
//                               itemBuilder: (context, index) {
//                                 final data = videoDataList[index];
//                                 if (index >= controllers.length) {
//                                   return const SizedBox();
//                                 }

//                                 final controller = controllers[index];

//                                 return Column(
//                                   crossAxisAlignment:
//                                       CrossAxisAlignment.stretch,
//                                   children: [
//                                     Expanded(
//                                       child: GestureDetector(
//                                         onTap: () {
//                                           controller.value.isPlaying
//                                               ? controller.pause()
//                                               : controller.play();
//                                           videoController
//                                               .pauseOtherVideos(index);
//                                         },
//                                         child: ClipRRect(
//                                           borderRadius:
//                                               BorderRadius.circular(12),
//                                           child: Container(
//                                             color: Colors.black,
//                                             child: Stack(
//                                               fit: StackFit.expand,
//                                               children: [
//                                                 controller.value.isInitialized
//                                                     ? FittedBox(
//                                                         fit: BoxFit.cover,
//                                                         child: SizedBox(
//                                                           width: controller
//                                                               .value.size.width,
//                                                           height: controller
//                                                               .value
//                                                               .size
//                                                               .height,
//                                                           child: VideoPlayer(
//                                                               controller),
//                                                         ),
//                                                       )
//                                                     : const Center(
//                                                         child:
//                                                             CircularProgressIndicator()),
//                                                 Container(
//                                                     color: Colors.black
//                                                         .withOpacity(0.2)),
//                                                 Align(
//                                                   alignment: Alignment.center,
//                                                   child: AnimatedBuilder(
//                                                     animation: controller,
//                                                     builder: (context, _) {
//                                                       return Icon(
//                                                         controller
//                                                                 .value.isPlaying
//                                                             ? Icons
//                                                                 .pause_circle_filled
//                                                             : Icons
//                                                                 .play_circle_fill,
//                                                         color: Colors.white,
//                                                         size: 40,
//                                                       );
//                                                     },
//                                                   ),
//                                                 ),
//                                               ],
//                                             ),
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//                                     const SizedBox(height: 4),
//                                     Padding(
//                                       padding: const EdgeInsets.symmetric(
//                                           horizontal: 4.0),
//                                       child: Row(
//                                         crossAxisAlignment:
//                                             CrossAxisAlignment.start,
//                                         children: [
//                                           Expanded(
//                                             child: Column(
//                                               crossAxisAlignment:
//                                                   CrossAxisAlignment.start,
//                                               children: [
//                                                 Text(
//                                                   data['restaurantName'] ??
//                                                       'Untitled',
//                                                   style: const TextStyle(
//                                                     fontSize: 12,
//                                                     fontWeight: FontWeight.bold,
//                                                     overflow:
//                                                         TextOverflow.ellipsis,
//                                                   ),
//                                                   maxLines: 1,
//                                                 ),
//                                                 Text(
//                                                   data['location'] ??
//                                                       'Uncategorized',
//                                                   style: TextStyle(
//                                                     fontSize: 10,
//                                                     color: Colors.grey[600],
//                                                     overflow:
//                                                         TextOverflow.ellipsis,
//                                                   ),
//                                                   maxLines: 1,
//                                                 ),
//                                               ],
//                                             ),
//                                           ),
//                                           PopupMenuButton<String>(
//                                             icon: const Icon(Icons.more_vert,
//                                                 size: 16),
//                                             itemBuilder: (context) => [
//                                               PopupMenuItem(
//                                                 value: 'view',
//                                                 child: Text('View'),
//                                               ),
//                                               const PopupMenuItem(
//                                                 value: 'edit',
//                                                 child: Text('Edit'),
//                                               ),
//                                               const PopupMenuItem(
//                                                 value: 'delete',
//                                                 child: Text('Delete',
//                                                     style: TextStyle(
//                                                         color: Colors.red)),
//                                               ),
//                                             ],
//                                             onSelected: (value) async {
//                                               if (value == 'view') {
//                                                 Navigator.push(
//                                                   context,
//                                                   MaterialPageRoute(
//                                                     builder: (_) => ViewVideo(
//                                                       videoData: data,
//                                                       videoController:
//                                                           controller,
//                                                     ),
//                                                   ),
//                                                 );
//                                                 // Handle view action
//                                               } else if (value == 'edit') {
//                                                 // Handle edit action
//                                               } else if (value == 'delete') {
//                                                 final confirm =
//                                                     await showDialog<bool>(
//                                                   context: context,
//                                                   builder: (context) =>
//                                                       AlertDialog(
//                                                     title: const Text(
//                                                         "Delete Video"),
//                                                     content: const Text(
//                                                         "Are you sure you want to delete this video?"),
//                                                     actions: [
//                                                       TextButton(
//                                                         onPressed: () =>
//                                                             Navigator.pop(
//                                                                 context, false),
//                                                         child: const Text(
//                                                             "Cancel"),
//                                                       ),
//                                                       ElevatedButton(
//                                                         onPressed: () =>
//                                                             Navigator.pop(
//                                                                 context, true),
//                                                         style: ElevatedButton
//                                                             .styleFrom(
//                                                                 backgroundColor:
//                                                                     Colors.red),
//                                                         child: const Text(
//                                                             "Delete"),
//                                                       ),
//                                                     ],
//                                                   ),
//                                                 );
//                                                 if (confirm == true) {
//                                                   videoController.deleteVideo(
//                                                       data['id'], index);
//                                                 }
//                                               }
//                                             },
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                   ],
//                                 );
//                               },
//                             ),
//                           );
//                         },
//                       ),
//                     ],
//                   )),
//           ),
//         ),
//         Obx(() {
//           if (!videoController.isUploading.value) return const SizedBox();
//           return Container(
//             color: Colors.black.withOpacity(0.7),
//             child: Center(
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   const Text(
//                     "Uploading...",
//                     style: TextStyle(color: Colors.white, fontSize: 18),
//                   ),
//                   const SizedBox(height: 12),
//                   CircularProgressIndicator(
//                       value: videoController.uploadProgress.value),
//                   const SizedBox(height: 8),
//                   Text(
//                     "${(videoController.uploadProgress.value * 100).toStringAsFixed(0)}%",
//                     style: const TextStyle(color: Colors.white),
//                   ),
//                 ],
//               ),
//             ),
//           );
//         }),
//       ],
//     );
//   }
// }

///
///
///
///

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:savrly/constants/app_colors.dart';
import 'package:savrly/controllers/filter_controller.dart';
import 'package:savrly/controllers/video_controller.dart';
import 'package:savrly/screens/Videos/view_Video.dart';
import 'package:savrly/widgets/custom_textfield.dart';
import 'package:video_player/video_player.dart';
import 'upload_video_form.dart'; // Create this widget separately

class AdminVideoPanel extends StatelessWidget {
  AdminVideoPanel({super.key});

  final videoController = Get.put(VideoController());
  final filterController = Get.put(FilterController());

  final searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          body: SafeArea(
            child: Obx(() {
              if (videoController.isUploadMode.value) {
                return UploadVideoForm();
              } else if (videoController.isViewMode.value &&
                  videoController.selectedPlayer != null) {
                return ViewVideo(
                  videoData: videoController.selectedVideoData,
                  videoController: videoController.selectedPlayer!,
                );
              } else {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Videos",
                            style: TextStyle(
                                fontSize: 22, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          GestureDetector(
                            onTap: () {
                              videoController.toggleUploadMode();
                              videoController.clearSelection();
                            },
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: const BoxDecoration(
                                color: Colors.green,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.add,
                                  color: Colors.white, size: 20),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 10),
                      child: SizedBox(
                        width: 389,
                        child: CustomTextField(
                          controller: searchController,
                          hintText: 'Search',
                          borderColor: primaryColor,
                          hintTextColor: primaryColor,
                          prefixIcon: Icon(Icons.search, color: primaryColor),
                          suffixIcon: PopupMenuButton<String>(
                            icon: //Image(image: AssetImage("assets/images/filter.png"))
                                Icon(Icons.filter_list, color: primaryColor),
                            offset: Offset(0, 40),
                            itemBuilder: (context) => [
                              PopupMenuItem(
                                enabled: false,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Vibes',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold)),
                                    Obx(() {
                                      final vibes = [
                                        'Live Music',
                                        'Romantic',
                                        'Family',
                                        'Casual'
                                      ];
                                      return Column(
                                        children: vibes.map((vibe) {
                                          return CheckboxListTile(
                                            title: Text(vibe,
                                                style: TextStyle(fontSize: 12)),
                                            value: filterController
                                                .selectedVibes
                                                .contains(vibe),
                                            onChanged: (_) => filterController
                                                .toggleVibe(vibe),
                                            dense: true,
                                            controlAffinity:
                                                ListTileControlAffinity.leading,
                                          );
                                        }).toList(),
                                      );
                                    }),
                                    Divider(),
                                    Text('Atmosphere',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold)),
                                    Obx(() {
                                      final atmosphereList = [
                                        'Outdoor',
                                        'Indoor',
                                        'Rooftop'
                                      ];
                                      return Column(
                                        children: atmosphereList.map((atm) {
                                          return CheckboxListTile(
                                            title: Text(atm,
                                                style: TextStyle(fontSize: 12)),
                                            value: filterController
                                                .selectedAtmosphere
                                                .contains(atm),
                                            onChanged: (_) => filterController
                                                .toggleAtmosphere(atm),
                                            dense: true,
                                            controlAffinity:
                                                ListTileControlAffinity.leading,
                                          );
                                        }).toList(),
                                      );
                                    }),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        TextButton(
                                          onPressed: () {
                                            filterController.clearFilters();
                                            videoController.videoapplyFilters(
                                                [], []); // Update to match
                                            Navigator.pop(context);
                                          },
                                          child: Text("Clear"),
                                        ),
                                        ElevatedButton(
                                          onPressed: () {
                                            videoController.videoapplyFilters(
                                              filterController.selectedVibes,
                                              filterController
                                                  .selectedAtmosphere,
                                            );
                                            Navigator.pop(context);
                                          },
                                          child: Text("Apply"),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                          onChanged: (value) {
                            // Trigger search logic when search text changes
                          },
                        ),
                      ),
                    ),
                    GetBuilder<VideoController>(
                      builder: (controller) {
                        final videoDataList = controller.videoDataList;
                        final controllers = controller.controllers;
                        if (controllers.isEmpty) {
                          return const Expanded(
                            child: Center(child: CircularProgressIndicator()),
                          );
                        }

                        if (videoDataList.isEmpty) {
                          return const Expanded(
                            child: Center(
                              child: Text(
                                'No restaurant found',
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                            ),
                          );
                        }

                        return Expanded(
                          child: GridView.builder(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            itemCount: videoDataList.length,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              crossAxisSpacing: 12,
                              mainAxisSpacing: 12,
                              childAspectRatio: 0.8,
                            ),
                            itemBuilder: (context, index) {
                              final data = videoDataList[index];
                              if (index >= controllers.length) {
                                return const SizedBox();
                              }

                              final controller = controllers[index];

                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () {
                                        controller.value.isPlaying
                                            ? controller.pause()
                                            : controller.play();
                                        videoController.pauseOtherVideos(index);
                                      },
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(12),
                                        child: Container(
                                          color: Colors.black,
                                          child: Stack(
                                            fit: StackFit.expand,
                                            children: [
                                              controller.value.isInitialized
                                                  ? FittedBox(
                                                      fit: BoxFit.cover,
                                                      child: SizedBox(
                                                        width: controller
                                                            .value.size.width,
                                                        height: controller
                                                            .value.size.height,
                                                        child: VideoPlayer(
                                                            controller),
                                                      ),
                                                    )
                                                  : const Center(
                                                      child:
                                                          CircularProgressIndicator()),
                                              Container(
                                                  color: Colors.black
                                                      .withOpacity(0.2)),
                                              Align(
                                                alignment: Alignment.center,
                                                child: AnimatedBuilder(
                                                  animation: controller,
                                                  builder: (context, _) {
                                                    return Icon(
                                                      controller.value.isPlaying
                                                          ? Icons
                                                              .pause_circle_filled
                                                          : Icons
                                                              .play_circle_fill,
                                                      color: Colors.white,
                                                      size: 40,
                                                    );
                                                  },
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 4.0),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                data['restaurantName'] ??
                                                    'Untitled',
                                                style: const TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                                maxLines: 1,
                                              ),
                                              Text(
                                                data['location'] ??
                                                    'Uncategorized',
                                                style: TextStyle(
                                                  fontSize: 10,
                                                  color: Colors.grey[600],
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                                maxLines: 1,
                                              ),
                                            ],
                                          ),
                                        ),
                                        PopupMenuButton<String>(
                                          icon: const Icon(Icons.more_vert,
                                              size: 16),
                                          itemBuilder: (context) => [
                                            const PopupMenuItem(
                                              value: 'view',
                                              child: Text('View'),
                                            ),
                                            const PopupMenuItem(
                                              value: 'edit',
                                              child: Text('Edit'),
                                            ),
                                            const PopupMenuItem(
                                              value: 'delete',
                                              child: Text('Delete',
                                                  style: TextStyle(
                                                      color: Colors.red)),
                                            ),
                                          ],
                                          onSelected: (value) async {
                                            if (value == 'view') {
                                              videoController.showViewMode(
                                                  data, controller);
                                            } else if (value == 'edit') {
                                              // Handle edit action
                                            } else if (value == 'delete') {
                                              final confirm =
                                                  await showDialog<bool>(
                                                context: context,
                                                builder: (context) =>
                                                    AlertDialog(
                                                  title: const Text(
                                                      "Delete Video"),
                                                  content: const Text(
                                                      "Are you sure you want to delete this video?"),
                                                  actions: [
                                                    TextButton(
                                                      onPressed: () =>
                                                          Navigator.pop(
                                                              context, false),
                                                      child:
                                                          const Text("Cancel"),
                                                    ),
                                                    ElevatedButton(
                                                      onPressed: () =>
                                                          Navigator.pop(
                                                              context, true),
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                              backgroundColor:
                                                                  Colors.red),
                                                      child:
                                                          const Text("Delete"),
                                                    ),
                                                  ],
                                                ),
                                              );
                                              if (confirm == true) {
                                                videoController.deleteVideo(
                                                    data['id'], index);
                                              }
                                            }
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ],
                );
              }
            }),
          ),
        ),
        Obx(() {
          if (!videoController.isUploading.value) return const SizedBox();
          return Container(
            // ignore: deprecated_member_use
            color: Colors.black.withOpacity(0.7),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "Uploading...",
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  const SizedBox(height: 12),
                  CircularProgressIndicator(
                      value: videoController.uploadProgress.value),
                  const SizedBox(height: 8),
                  Text(
                    "${(videoController.uploadProgress.value * 100).toStringAsFixed(0)}%",
                    style: const TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }
}
