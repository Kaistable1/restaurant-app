import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kaistable_website/models/video_model.dart';

class VideoController extends GetxController {
  RxList<VideoModel> videos = <VideoModel>[].obs;
  RxList<VideoModel> savedVideos = <VideoModel>[].obs;

  RxBool hasInitialized = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchVideos();
    fetchSavedVideosForCurrentUser();
  }

  final RxSet<String> savedVideoIds = <String>{}.obs;
  RxList<Map<String, dynamic>> videoDataList = <Map<String, dynamic>>[].obs;
  RxList filteredVideoDataList = <Map<String, dynamic>>[].obs;
  List<Map<String, dynamic>> originalVideoList = [];
  final TextEditingController searchController = TextEditingController();

  List<VideoModel> videosBackup = [];

void toggleSavedStatus(String videoId) async {
  final userId = FirebaseAuth.instance.currentUser?.uid;

  if (userId == null) {
    print('User not logged in!');
    return;
  }

  // Unique ID (optional): userId + videoId
  final docId = '${userId}_$videoId';

  final docRef = FirebaseFirestore.instance
      .collection('saved_videos')
      .doc(docId);

  if (savedVideoIds.contains(videoId)) {
    // Remove from Firestore
    await docRef.delete();
    savedVideoIds.remove(videoId);
  } else {
    // Save to Firestore
    await docRef.set({
      'userId': userId,
      'videoId': videoId,
      'savedAt': FieldValue.serverTimestamp(),
    });
    savedVideoIds.add(videoId);
  }
}

  // Future<void> fetchVideos() async {
  //   try {
  //     final snapshot = await FirebaseFirestore.instance
  //         .collection('videos')
  //         .orderBy('timestamp', descending: true)
  //         .get();

  //     final list = snapshot.docs
  //         .map((doc) => VideoModel.fromFirestore(doc.id, doc.data()))
  //         .toList();

  //     videos.value = list;
  //     hasInitialized.value = true;
  //   } catch (e) {
  //     print('Error fetching videos: $e');
  //   }
  // }

  Map<String, List<String>> getAllFilters(VideoModel video) {
    return {
      'cuisines': video.cuisines.isNotEmpty ? [video.cuisines] : [],
      'atmosphere': video.atmosphere.isNotEmpty ? [video.atmosphere] : [],
      'experience': video.experience.isNotEmpty ? [video.experience] : [],
      'vibes': video.vibes.isNotEmpty ? [video.vibes] : [],
    };
  }

  var selectedVibes = <String>[].obs;
  var selectedAtmosphere = <String>[].obs;

  var selectedCuisine = <String>[].obs;
  var selectedExperience = <String>[].obs;

  void toggleVibe(String vibe) {
    if (selectedVibes.contains(vibe)) {
      selectedVibes.remove(vibe);
    } else {
      selectedVibes.add(vibe);
    }
  }

  void toggleCuisine(String cuisine) {
    if (selectedCuisine.contains(cuisine)) {
      selectedCuisine.remove(cuisine);
    } else {
      selectedCuisine.add(cuisine);
    }
  }

  void toggleAtmosphere(String atmosphere) {
    if (selectedAtmosphere.contains(atmosphere)) {
      selectedAtmosphere.remove(atmosphere);
    } else {
      selectedAtmosphere.add(atmosphere);
    }
  }

  void toggleExperience(String experience) {
    if (selectedExperience.contains(experience)) {
      selectedExperience.remove(experience);
    } else {
      selectedExperience.add(experience);
    }
  }

  void clearFilters() {
    selectedVibes.clear();
    selectedAtmosphere.clear();
    selectedExperience.clear();
    selectedCuisine.clear();
  }

  Future<void> fetchVideos() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('videos')
          .orderBy('timestamp', descending: true)
          .get();

      final list = snapshot.docs
          .map((doc) => VideoModel.fromFirestore(doc.id, doc.data()))
          .toList();

      videos.value = list;
      videosBackup = list; // ✅ keep full list for filtering
      hasInitialized.value = true;

      refreshVideoList(); // ✅ apply filters/search after loading
    } catch (e) {
      print('Error fetching videos: $e');
    }
  }

  void applyAllFiltersAndSearch({
    List<String>? selectedVibes,
    List<String>? selectedAtmospheres,
    List<String>? selectedCuisine,
    List<String>? selectedExperience,
    String searchQuery = '',
  }) {
    if (videosBackup.isEmpty) return; // ← Skip filtering if backup is not ready

    final query = searchQuery.toLowerCase();

    final filteredVideos = videosBackup.where((video) {
      final vibe = video.vibes.toLowerCase();
      final atmosphere = video.atmosphere.toLowerCase();
      final cuisine = video.cuisines.toLowerCase();
      final experience = video.experience.toLowerCase();
      final restaurantName = video.restaurantName.toLowerCase();

      final vibeMatch = selectedVibes == null || selectedVibes.isEmpty
          ? true
          : selectedVibes.any((v) => vibe.contains(v.toLowerCase()));

      final atmosphereMatch =
          selectedAtmospheres == null || selectedAtmospheres.isEmpty
              ? true
              : selectedAtmospheres
                  .any((a) => atmosphere.contains(a.toLowerCase()));

      final cuisineMatch = selectedCuisine == null || selectedCuisine.isEmpty
          ? true
          : selectedCuisine.any((c) => cuisine.contains(c.toLowerCase()));

      final experienceMatch = selectedExperience == null ||
              selectedExperience.isEmpty
          ? true
          : selectedExperience.any((e) => experience.contains(e.toLowerCase()));

      final nameMatch = restaurantName.contains(query);

      return vibeMatch &&
          atmosphereMatch &&
          cuisineMatch &&
          experienceMatch &&
          nameMatch;
    }).toList();

    videos.value = filteredVideos;
  }

  void refreshVideoList() {
    applyAllFiltersAndSearch(
      selectedVibes: selectedVibes,
      selectedAtmospheres: selectedAtmosphere,
      selectedCuisine: selectedCuisine,
      selectedExperience: selectedExperience,
      searchQuery: searchController.text,
    );
  }

//saved video controller

  Future<void> fetchSavedVideosForCurrentUser() async {
  final userId = FirebaseAuth.instance.currentUser?.uid;
  if (userId == null) return;

  // Step 1: Fetch saved video IDs
  final savedSnapshot = await FirebaseFirestore.instance
      .collection('saved_videos')
      .where('userId', isEqualTo: userId)
      .get();

  final savedIds = savedSnapshot.docs.map((doc) => doc['videoId'] as String).toList();

  if (savedIds.isEmpty) {
    savedVideos.value = []; // your observable list
    return;
  }

  // Step 2: Fetch videos from 'videos' collection
  final videoSnapshot = await FirebaseFirestore.instance
      .collection('videos')
      .where(FieldPath.documentId, whereIn: savedIds)
      .get();

  final savedList = videoSnapshot.docs
      .map((doc) => VideoModel.fromFirestore(doc.id, doc.data()))
      .toList();

  savedVideos.value = savedList; // Update the observable list
}

}
