import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kaistable_website/models/video_model.dart';

class VideoController extends GetxController {
  RxList<VideoModel> videos = <VideoModel>[].obs;
  RxBool hasInitialized = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchVideos();
  }

  final RxSet<String> savedVideoIds = <String>{}.obs;
  RxList<Map<String, dynamic>> videoDataList = <Map<String, dynamic>>[].obs;
  RxList filteredVideoDataList = <Map<String, dynamic>>[].obs;
  List<Map<String, dynamic>> originalVideoList = [];
  final TextEditingController searchController = TextEditingController();



  List<VideoModel> videosBackup = [];


  

  void toggleSavedStatus(String videoId) {
    if (savedVideoIds.contains(videoId)) {
      savedVideoIds.remove(videoId);
    } else {
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
    refreshVideoList();
  }

  void toggleCuisine(String cuisine) {
    if (selectedCuisine.contains(cuisine)) {
      selectedCuisine.remove(cuisine);
    } else {
      selectedCuisine.add(cuisine);
    }
    refreshVideoList();
  }

  void toggleAtmosphere(String atmosphere) {
    if (selectedAtmosphere.contains(atmosphere)) {
      selectedAtmosphere.remove(atmosphere);
    } else {
      selectedAtmosphere.add(atmosphere);
    }
    refreshVideoList();
  }

  void toggleExperience(String experience) {
    if (selectedExperience.contains(experience)) {
      selectedExperience.remove(experience);
    } else {
      selectedExperience.add(experience);
    }
    refreshVideoList();
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
  final query = searchQuery.toLowerCase();

  final filteredVideos = videosBackup.where((video) {
    final vibe = video.vibes;
    final atmosphere = video.atmosphere;
    final cuisine = video.cuisines;
    final experience = video.experience;
    final restaurantName = video.restaurantName;

    final vibeMatch = selectedVibes != null && selectedVibes.isNotEmpty
        ? selectedVibes.contains(vibe)
        : false;

    final atmosphereMatch = selectedAtmospheres != null && selectedAtmospheres.isNotEmpty
        ? selectedAtmospheres.contains(atmosphere)
        : false;

    final cuisineMatch = selectedCuisine != null && selectedCuisine.isNotEmpty
        ? selectedCuisine.contains(cuisine)
        : false;

    final experienceMatch = selectedExperience != null && selectedExperience.isNotEmpty
        ? selectedExperience.contains(experience)
        : false;

    final nameMatch = restaurantName.toLowerCase().contains(query);

    final filtersActive = selectedVibes!.isNotEmpty ||
        selectedAtmospheres!.isNotEmpty ||
        selectedCuisine!.isNotEmpty ||
        selectedExperience!.isNotEmpty;

    return nameMatch &&
        (!filtersActive ||
            vibeMatch ||
            atmosphereMatch ||
            cuisineMatch ||
            experienceMatch);
  }).toList();

  videos.value = filteredVideos; // ✅ Now UI will update!
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



}
