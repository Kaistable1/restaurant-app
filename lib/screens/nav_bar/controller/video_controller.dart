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

void toggleSavedStatus(String videoId) {
  if (savedVideoIds.contains(videoId)) {
    savedVideoIds.remove(videoId);
  } else {
    savedVideoIds.add(videoId);
  }
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
      hasInitialized.value = true;
    } catch (e) {
      print('Error fetching videos: $e');
    }
  }


  Map<String, List<String>> getAllFilters(VideoModel video) {
  return {
    'cuisines': video.cuisines.isNotEmpty ? [video.cuisines] : [],
    'atmosphere': video.atmosphere.isNotEmpty ? [video.atmosphere] : [],
    'experience': video.experience.isNotEmpty ? [video.experience] : [],
    'vibes': video.vibes.isNotEmpty ? [video.vibes] : [],
  };
}

}
