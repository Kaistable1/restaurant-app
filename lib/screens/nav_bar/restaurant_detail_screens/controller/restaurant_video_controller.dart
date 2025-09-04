import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_player/video_player.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

import '../../../../streams/model/streams_model.dart';

class RestaurantVideoController extends GetxController{
  var videos = <VideoModel>[].obs;
  var isPlaying = <RxBool>[];
  var isStartedOnce = <RxBool>[];
  var playingIndex = (-1).obs;
  var thumbnailPaths = <int, String>{}.obs;
  VideoPlayerController? playerController;
  // bool _isGeneratingThumbnail = false;

  @override
  void onInit() {
    super.onInit();
  }

  Future<void> fetchVideos(String restaurantName, String zipCode, List<String> imagesList) async {
    try {
      var snapshot = await FirebaseFirestore.instance
          .collection('videos').where('restaurantName', isEqualTo: restaurantName).where('zipCode', isEqualTo: zipCode)
          .orderBy('timestamp', descending: true)
          .get();

      var firestoreMedias = snapshot.docs
          .map((doc) => VideoModel.fromMap(doc.data(), doc.id))
          .toList();

      // Create VideoModel for each restaurant image
      var imageMedias = imagesList.map((url) => VideoModel(url: url, mediaType: 'image')).toList();

      // Combine lists (images first, then Firestore medias)
      videos.value = [...imageMedias, ...firestoreMedias];

      for(int i=0; i<videos.length; i++) {
        // rigger thumbnail only for videos
        if (videos[i].mediaType == 'video' &&  // check for 'video' (skip images)
            thumbnailPaths[i] == null &&
            videos[i].url != null &&
            videos[i].url!.isNotEmpty) {
          generateThumbnail(i, videos[i].url!);
        }

        isPlaying.add(false.obs);
        isStartedOnce.add(false.obs);
      }

    } catch (e) {
      print("Error fetching videos: $e");
      Get.snackbar('Error', 'Failed to load videos: $e',
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  Future<void> generateThumbnail(int index, String videoUrl) async {
    if (/*_isGeneratingThumbnail ||*/ thumbnailPaths[index] != null) return;
    // _isGeneratingThumbnail = true;

    try {
      final thumbnailPath = await VideoThumbnail.thumbnailFile(
        video: videoUrl,
        thumbnailPath: (await getTemporaryDirectory()).path,
        imageFormat: ImageFormat.JPEG,
        maxHeight: 140,
        maxWidth: 110,
        timeMs: 0,
        quality: 50,
      );
      if (thumbnailPath != null) {
        thumbnailPaths[index] = thumbnailPath;
      }
    } catch (e) {
      print("Error generating thumbnail for $videoUrl: $e");
    }
    // finally {
    //   _isGeneratingThumbnail = false;
    // }
  }

  // Future<bool> playVideo(int index) async {
  //   if (playingIndex.value == index) {
  //     if(playerController!.value.isPlaying){
  //       await playerController?.pause();
  //       return false;
  //     }else{
  //       await playerController?.play();
  //     }
  //     return true;
  //   }
  //
  //   // Dispose of the previous controller safely
  //   if (playerController != null) {
  //     final oldController = playerController;
  //     playerController = null;
  //     await oldController?.pause(); // Pause before disposing
  //     await oldController?.dispose();
  //   }
  //
  //   final videoUrl = videos[index].url;
  //   if (videoUrl == null || videoUrl.isEmpty) {
  //     Get.snackbar('Error', 'Invalid video URL',
  //         snackPosition: SnackPosition.BOTTOM);
  //     return false;
  //   }
  //
  //   try {
  //     VideoPlayerController controller;
  //     if (videoUrl.startsWith('http')) {
  //       controller = VideoPlayerController.network(videoUrl);
  //     } else {
  //       controller = VideoPlayerController.asset(videoUrl);
  //     }
  //     playerController = controller;
  //     await playerController!.initialize();
  //     if (playerController != null && playerController!.value.isInitialized) {
  //       playingIndex.value = index;
  //       await playerController?.play();
  //       return true;
  //     }
  //     return false;
  //   } catch (e) {
  //     playingIndex.value = -1;
  //     print("Error playing video: $e");
  //     Get.snackbar('Error', 'Failed to load video: $e',
  //         snackPosition: SnackPosition.BOTTOM);
  //     return false;
  //   }
  // }

  @override
  void onClose() {
    if (playerController != null) {
      final oldController = playerController;
      playerController = null;
      oldController?.pause();
      oldController?.dispose();
    }
    // Clean up thumbnails
    for (var path in thumbnailPaths.values) {
      File(path).delete().catchError((e) => print("Error deleting thumbnail: $e"));
    }
    thumbnailPaths.clear();
    isPlaying.clear();
    isStartedOnce.clear();
    super.onClose();
  }
}