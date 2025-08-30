import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:path_provider/path_provider.dart';
import '../model/streams_model.dart';
import 'dart:io';


class VideoController extends GetxController {
  final TextEditingController searchController = TextEditingController();

  RxBool isLoading = false.obs;

  var videos = <VideoModel>[].obs;
  var filteredVideos = <VideoModel>[].obs;
  var playingIndex = (-1).obs;
  var thumbnailPaths = <String, String>{}.obs;
  VideoPlayerController? playerController;
  bool _isGeneratingThumbnail = false;

  @override
  void onInit() {
    fetchVideos();
    super.onInit();
  }

  Future<void> fetchVideos() async {
    try {
      isLoading.value = true;

      var snapshot = await FirebaseFirestore.instance
          .collection('videos')
          .orderBy('timestamp', descending: true)
          .get();

      videos.value = snapshot.docs
          .map((doc) => VideoModel.fromMap(doc.data(), doc.id))
          .toList();
      filteredVideos.value = videos; // Initialize filteredVideos with all videos
      for (var video in filteredVideos) {
        if (video.url != null && video.url!.isNotEmpty) {
          generateThumbnail(video.url!);
        }
      }

      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
      print("Error fetching videos: $e");
      Get.snackbar('Error', 'Failed to load videos: $e',
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  void applySearchAndFilters(String searchQuery, RxMap<String, String> filters) {
    try {
      var filtered = videos.toList();

      // Apply search filter (client-side)
      if (searchQuery.isNotEmpty) {
        filtered = filtered.where((video) {
          final restaurantName = video.restaurantName?.toLowerCase() ?? '';
          return restaurantName.contains(searchQuery.toLowerCase());
        }).toList();
      }

      // Apply category filters
      if (filters['Vibes'] != null) {
        filtered = filtered.where((video) => video.vibes == filters['Vibes']).toList();
      }
      if (filters['Experience'] != null) {
        filtered = filtered.where((video) => video.experience == filters['Experience']).toList();
      }
      if (filters['Atmosphere'] != null) {
        filtered = filtered.where((video) => video.atmosphere == filters['Atmosphere']).toList();
      }

      filteredVideos.value = filtered;

      for (var video in filteredVideos) {
        if (video.url != null && video.url!.isNotEmpty) {
          generateThumbnail(video.url!);
        }
      }



    } catch (e) {
      print("Error applying filters: $e");
      Get.snackbar('Error', 'Failed to apply filters: $e',
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  Future<void> generateThumbnail(String videoUrl) async {
    if (_isGeneratingThumbnail || thumbnailPaths[videoUrl] != null) return;
    _isGeneratingThumbnail = true;

    try {
      final thumbnailPath = await VideoThumbnail.thumbnailFile(
        video: videoUrl,
        thumbnailPath: (await getTemporaryDirectory()).path,
        imageFormat: ImageFormat.PNG,
        maxHeight: 200,
        quality: 70,
      );
      if (thumbnailPath != null) {
        thumbnailPaths[videoUrl] = thumbnailPath;
      }
    } catch (e) {
      print("Error generating thumbnail for $videoUrl: $e");
    } finally {
      _isGeneratingThumbnail = false;
    }
  }

  Future<void> playVideo(int index) async {
    if (playingIndex.value == index) {
      await playerController?.pause();
      playingIndex.value = -1;
      return;
    }

    if (playerController != null) {
      final oldController = playerController;
      playerController = null;
      await oldController?.pause();
      await oldController?.dispose();
    }

    final videoUrl = filteredVideos[index].url;
    if (videoUrl == null || videoUrl.isEmpty) {
      Get.snackbar('Error', 'Invalid video URL',
          snackPosition: SnackPosition.BOTTOM);
      return;
    }

    try {
      playerController = VideoPlayerController.networkUrl(Uri.parse(videoUrl));
      await playerController!.initialize().timeout(const Duration(seconds: 10), onTimeout: () {
        throw Exception('Video initialization timed out');
      }).then((_) {
        if (playerController != null && playerController!.value.isInitialized) {
          playingIndex.value = index;
          playerController?.play();
        }
      }).catchError((error) {
        print("Error initializing video: $error");
        Get.snackbar('Error', 'Failed to play video: $error',
            snackPosition: SnackPosition.BOTTOM);
        playingIndex.value = -1;
      });
    } catch (e) {
      print("Error creating video controller: $e");
      Get.snackbar('Error', 'Failed to load video: $e',
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  @override
  void onClose() {
    if (playerController != null) {
      final oldController = playerController;
      playerController = null;
      oldController?.pause();
      oldController?.dispose();
    }
    for (var path in thumbnailPaths.values) {
      File(path).delete().catchError((e) => print("Error deleting thumbnail: $e"));
    }
    thumbnailPaths.clear();
    super.onClose();
  }
}

// class VideoController extends GetxController {
//   var videos = <VideoModel>[].obs;
//   var playingIndex = (-1).obs;
//   var thumbnailPaths = <int, String>{}.obs;
//   VideoPlayerController? playerController;
//   bool _isGeneratingThumbnail = false;
//
//   @override
//   void onInit() {
//     fetchVideos();
//     super.onInit();
//   }
//
//   Future<void> fetchVideos() async {
//     try {
//       var snapshot = await FirebaseFirestore.instance
//           .collection('videos')
//           .orderBy('timestamp', descending: true)
//           .get();
//
//       videos.value = snapshot.docs
//           .map((doc) => VideoModel.fromMap(doc.data()))
//           .toList();
//     } catch (e) {
//       print("Error fetching videos: $e");
//       Get.snackbar('Error', 'Failed to load videos: $e',
//           snackPosition: SnackPosition.BOTTOM);
//     }
//   }
//
//   Future<void> generateThumbnail(int index, String videoUrl) async {
//     if (_isGeneratingThumbnail || thumbnailPaths[index] != null) return;
//     _isGeneratingThumbnail = true;
//
//     try {
//       final thumbnailPath = await VideoThumbnail.thumbnailFile(
//         video: videoUrl,
//         thumbnailPath: (await getTemporaryDirectory()).path,
//         imageFormat: ImageFormat.PNG,
//         maxHeight: 200, // Reduced for performance
//         quality: 50,    // Reduced for performance
//       );
//       if (thumbnailPath != null) {
//         thumbnailPaths[index] = thumbnailPath;
//       }
//     } catch (e) {
//       print("Error generating thumbnail for $videoUrl: $e");
//     } finally {
//       _isGeneratingThumbnail = false;
//     }
//   }
//
//   Future<void> playVideo(int index) async {
//     if (playingIndex.value == index) {
//       await playerController?.pause();
//       playingIndex.value = -1;
//       return;
//     }
//
//     // Dispose of the previous controller safely
//     if (playerController != null) {
//       final oldController = playerController;
//       playerController = null;
//       await oldController?.pause(); // Pause before disposing
//       await oldController?.dispose();
//     }
//
//     final videoUrl = videos[index].url;
//     if (videoUrl == null || videoUrl.isEmpty) {
//       Get.snackbar('Error', 'Invalid video URL',
//           snackPosition: SnackPosition.BOTTOM);
//       return;
//     }
//
//     try {
//       playerController = VideoPlayerController.networkUrl(Uri.parse(videoUrl));
//       await playerController!.initialize().timeout(const Duration(seconds: 10), onTimeout: () {
//         throw Exception('Video initialization timed out');
//       }).then((_) {
//         if (playerController != null && playerController!.value.isInitialized) {
//           playingIndex.value = index;
//           playerController?.play();
//         }
//       }).catchError((error) {
//         print("Error initializing video: $error");
//         Get.snackbar('Error', 'Failed to play video: $error',
//             snackPosition: SnackPosition.BOTTOM);
//         playingIndex.value = -1;
//       });
//     } catch (e) {
//       print("Error creating video controller: $e");
//       Get.snackbar('Error', 'Failed to load video: $e',
//           snackPosition: SnackPosition.BOTTOM);
//     }
//   }
//
//   @override
//   void onClose() {
//     if (playerController != null) {
//       final oldController = playerController;
//       playerController = null;
//       oldController?.pause();
//       oldController?.dispose();
//     }
//     // Clean up thumbnails
//     for (var path in thumbnailPaths.values) {
//       File(path).delete().catchError((e) => print("Error deleting thumbnail: $e"));
//     }
//     thumbnailPaths.clear();
//     super.onClose();
//   }
// }