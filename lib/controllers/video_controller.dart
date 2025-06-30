import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:savrly/constants/app_colors.dart';
import 'package:video_player/video_player.dart';

class VideoController extends GetxController {
  RxList<Map<String, dynamic>> videoDataList = <Map<String, dynamic>>[].obs;
  List<VideoPlayerController> controllers = [];

  /// 🔧 Add this to keep unfiltered original data
  List<Map<String, dynamic>> originalVideoList = [];
  RxBool isUploading = false.obs;
  RxDouble uploadProgress = 0.0.obs;
  RxBool isUploadMode = false.obs;
  final Rx<XFile?> pickedVideo = Rx<XFile?>(null);
  final RxString videoName = ''.obs;
  void toggleUploadMode() => isUploadMode.value = !isUploadMode.value;
  final Rx<VideoPlayerController?> videoPlayerController =
      Rx<VideoPlayerController?>(null);

  void toggleViewMode() => isViewMode.value = !isViewMode.value;

  var isViewMode = false.obs;
  var selectedVideoData = <String, dynamic>{}.obs;

  VideoPlayerController? selectedPlayer;
  @override
  void onInit() {
    super.onInit();
    fetchVideos();
  }

  void videoapplyFilters(
      List<String> selectedVibes, List<String> selectedAtmospheres) {
    final filteredVideos = originalVideoList.where((video) {
      final vibe = video['vibes'];
      final atmosphere = video['atmosphere'];

      final vibeMatch =
          selectedVibes.isNotEmpty && selectedVibes.contains(vibe);
      final atmosphereMatch = selectedAtmospheres.isNotEmpty &&
          selectedAtmospheres.contains(atmosphere);

      // Agar user ne dono filter lagaye hain, toh koi ek match kare toh chalega
      if (selectedVibes.isNotEmpty && selectedAtmospheres.isNotEmpty) {
        return vibeMatch || atmosphereMatch;
      }
      // Agar sirf vibe filter lagaya hai
      else if (selectedVibes.isNotEmpty) {
        return vibeMatch;
      }
      // Agar sirf atmosphere filter lagaya hai
      else if (selectedAtmospheres.isNotEmpty) {
        return atmosphereMatch;
      }
      // Agar koi filter nahi lagaya
      else {
        return true;
      }
    }).toList();

    videoDataList.value = filteredVideos;
    update();
  }

  void clearSelection() {
    // Dispose the video controller if exists
    videoPlayerController.value?.dispose();

    // Reset all related variables
    pickedVideo.value = null;
    videoName.value = '';
    videoPlayerController.value = null;
    isUploading.value = false;
    uploadProgress.value = 0.0;
  }

  void showViewMode(
      Map<String, dynamic> data, VideoPlayerController controller) {
    isUploadMode.value = false;
    isViewMode.value = true;
    selectedVideoData.value = data;
    selectedPlayer = controller;
  }

  // Future<void> fetchVideos() async {
  //   final snapshot = await FirebaseFirestore.instance
  //       .collection('videos')
  //       .orderBy('timestamp', descending: true)
  //       .get();

  //   // Dispose old controllers
  //   for (var controller in controllers) {
  //     controller.dispose();
  //   }

  //   videoDataList.value = snapshot.docs
  //       .map((doc) => {'id': doc.id, ...doc.data()})
  //       .cast<Map<String, dynamic>>()
  //       .toList();

  //   controllers.clear();

  //   for (var data in videoDataList) {
  //     final controller = VideoPlayerController.network(data['url']);
  //     await controller.initialize();

  //     // ✅ Stop video when it finishes
  //     controller.addListener(() {
  //       final isFinished =
  //           controller.value.position >= controller.value.duration &&
  //               !controller.value.isPlaying;

  //       if (isFinished) {
  //         controller.pause();
  //         controller.seekTo(Duration.zero); // Optional: rewind to start
  //         update(); // Notify GetBuilder UI
  //       }
  //     });

  //     controller.setLooping(false); // ✅ Disable looping
  //     controllers.add(controller);
  //   }

  //   update(); // notify UI
  // }

  Future<void> fetchVideos() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('videos')
        .orderBy('timestamp', descending: true)
        .get();

    // Dispose old controllers
    for (var controller in controllers) {
      controller.dispose();
    }

    final fetchedList = snapshot.docs
        .map((doc) => {'id': doc.id, ...doc.data()})
        .cast<Map<String, dynamic>>()
        .toList();

    /// 🔧 Save the unfiltered original list
    originalVideoList = fetchedList;

    /// 🔧 Show all videos initially
    videoDataList.value = List<Map<String, dynamic>>.from(originalVideoList);

    controllers.clear();

    for (var data in videoDataList) {
      final controller = VideoPlayerController.network(data['url']);
      await controller.initialize();

      controller.addListener(() {
        final isFinished =
            controller.value.position >= controller.value.duration &&
                !controller.value.isPlaying;

        if (isFinished) {
          controller.pause();
          controller.seekTo(Duration.zero);
          update();
        }
      });

      controller.setLooping(false);
      controllers.add(controller);
    }

    update(); // notify UI
  }

  void pauseOtherVideos(int currentIndex) {
    for (int i = 0; i < controllers.length; i++) {
      if (i != currentIndex && controllers[i].value.isPlaying) {
        controllers[i].pause();
      }
    }
  }

  Future<void> deleteVideo(String docId, int index) async {
    await FirebaseFirestore.instance.collection('videos').doc(docId).delete();
    controllers[index].dispose();
    await fetchVideos();
  }

  Future<void> pickVideo(BuildContext context) async {
    try {
      final picker = ImagePicker();
      final picked = await picker.pickVideo(
        source: ImageSource.gallery,
        maxDuration: const Duration(minutes: 1), // Max 60 seconds
      );

      if (picked != null) {
        final controller = kIsWeb
            // ignore: deprecated_member_use
            ? VideoPlayerController.network(picked.path)
            : VideoPlayerController.file(File(picked.path));

        await controller.initialize();
        final duration = controller.value.duration;

        if (duration < const Duration(seconds: 30)) {
          Get.snackbar(
            "Invalid Video",
            "Please select a video between 30 to 60 seconds.",
            snackPosition: SnackPosition.TOP,
            duration: const Duration(seconds: 3),
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
          return;
        }

        // Clear previous selection
        clearSelection();
        pickedVideo.value = picked;
        videoName.value = picked.name;
        videoPlayerController.value = controller..play();
        videoPlayerController.refresh();

        Get.snackbar(
          "Success",
          "Video selected: ${picked.name}",
          snackPosition: SnackPosition.TOP,
          duration: const Duration(seconds: 2),
          backgroundColor: primaryColor,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        "Failed to pick video: ${e.toString()}",
        snackPosition: SnackPosition.TOP,
        duration: const Duration(seconds: 3),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      clearSelection();
    }
  }

  Future<void> uploadVideo({
    required BuildContext context,
    required String restaurantName,
    required String location,
    String? restaurantType,
    String? causine,
    String? vibes,
    String? experience,
    String? atmosphere,
  }) async {
    if (pickedVideo.value == null) {
      Get.snackbar(
        "Error",
        "Please select a video first",
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    try {
      isUploading.value = true;
      uploadProgress.value = 0.0;

      final fileName =
          'videos/${DateTime.now().millisecondsSinceEpoch}_${pickedVideo.value!.name}';
      final ref = FirebaseStorage.instance.ref().child(fileName);

      final uploadTask = ref.putData(await pickedVideo.value!.readAsBytes());

      uploadTask.snapshotEvents.listen((event) {
        uploadProgress.value =
            (event.bytesTransferred / event.totalBytes).clamp(0.0, 1.0);
      });

      final snapshot = await uploadTask;

      if (snapshot.state == TaskState.success) {
        final downloadUrl = await ref.getDownloadURL();

        await FirebaseFirestore.instance.collection('videos').add({
          'url': downloadUrl,
          'fileName': pickedVideo.value!.name,
          'restaurantName': restaurantName,
          'location': location,
          'restaurantType': restaurantType,
          'vibes': vibes,
          'atmosphere': atmosphere,
          'experience': experience,
          'causines': causine,
          'timestamp': Timestamp.now(),
        });
        isUploadMode.value = false; // switch back to video list
        isUploading.value = false;
        await fetchVideos();
        clearVideoSelection();

        Get.snackbar(
          "Success",
          "Video uploaded successfully!",
          snackPosition: SnackPosition.TOP,
          backgroundColor: primaryColor,
          colorText: Colors.white,
        );

        if (context.mounted) {
          Navigator.pop(context);
        }
      } else {
        throw Exception('Upload failed');
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        "Upload failed: $e",
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isUploading.value = false;
      uploadProgress.value = 0.0;
    }
  }

  void clearVideoSelection() {
    pickedVideo.value = null;
    videoName.value = '';
  }
}
