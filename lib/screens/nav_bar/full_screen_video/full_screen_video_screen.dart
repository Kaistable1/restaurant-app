import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';

import '../../../main.dart';
import '../../../streams/model/streams_model.dart';

class FullVideoScreen extends StatefulWidget {
  final VideoModel video;

  const FullVideoScreen({super.key, required this.video});

  @override
  State<FullVideoScreen> createState() => _FullVideoScreenState();
}

class _FullVideoScreenState extends State<FullVideoScreen> {
  late VideoPlayerController _controller;
  bool _isPlaying = true;

  // Explanation: Tracks whether the video is bookmarked, updated reactively.
  final RxBool _isBookmarked = false.obs;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.video.url!))
      ..initialize().then((_) {
        _controller.play();
        _controller.setLooping(true);
        setState(() {});
      });

    // Explanation: For authenticated users, listen to Firestore stream; for unauthenticated, check SharedPreferences.
    if (auth.currentUser != null) {
      final userId = auth.currentUser!.uid;
      FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('saved_videos')
          .doc(widget.video.videoId) // Assumes videoId property; adjust if different
          .snapshots()
          .listen(
            (snapshot) async {
          _isBookmarked.value = snapshot.exists;
          final prefs = await SharedPreferences.getInstance();
          final savedVideos = prefs.getStringList('saved_videos') ?? [];
          if(!savedVideos.contains(widget.video.videoId)){
            savedVideos.add(widget.video.videoId!);
            prefs.setStringList('saved_videos', savedVideos) ?? [];
          }

        },
        onError: (e) {
          print('Error streaming bookmark status: $e');
          Get.snackbar('Error', 'Failed to load bookmark status: $e',
              snackPosition: SnackPosition.BOTTOM);
        },
      );
    } else {
      _fetchBookmarkStatus();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // Explanation: Checks if the video ID is in SharedPreferences 'saved_videos' list.
  Future<void> _fetchBookmarkStatus() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedVideos = prefs.getStringList('saved_videos') ?? [];
      _isBookmarked.value = savedVideos.contains(widget.video.videoId);
    } catch (e) {
      print('Error fetching bookmark status: $e');
      Get.snackbar('Error', 'Failed to load bookmark status: $e',
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  // Explanation: Adds or removes the video from favorites in Firestore or SharedPreferences.
  Future<void> _toggleBookmark() async {
    try {
      final videoId = widget.video.videoId; // Assumes videoId property; adjust if different
      if (_isBookmarked.value) {
        // Remove from favorites
        if (auth.currentUser != null) {
          final userId = auth.currentUser!.uid;
          await FirebaseFirestore.instance
              .collection('users')
              .doc(userId)
              .collection('saved_videos')
              .doc(videoId)
              .delete();
          print('Removed video $videoId from Firestore saved_videos');
        }
          final prefs = await SharedPreferences.getInstance();
          final savedVideos = prefs.getStringList('saved_videos') ?? [];
          savedVideos.remove(videoId);
          await prefs.setStringList('saved_videos', savedVideos);
          print('Removed video $videoId from SharedPreferences');
          _isBookmarked.value = false; // Update RxBool for unauthenticated users

      } else {
        // Add to favorites
        if (auth.currentUser != null) {
          final userId = auth.currentUser!.uid;
          await FirebaseFirestore.instance
              .collection('users')
              .doc(userId)
              .collection('saved_videos')
              .doc(videoId)
              .set({'videoID': videoId});
          print('Added video $videoId to Firestore saved_videos');
        }
          final prefs = await SharedPreferences.getInstance();
          final savedVideos = prefs.getStringList('saved_videos') ?? [];
          if (!savedVideos.contains(videoId)) {
            savedVideos.add(videoId!);
            await prefs.setStringList('saved_videos', savedVideos);
            print('Added video $videoId to SharedPreferences');
            _isBookmarked.value = true; // Update RxBool for unauthenticated users
          }

      }
    } catch (e) {
      print('Error toggling bookmark: $e');
      Get.snackbar('Error', 'Failed to update bookmark: $e',
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  void _togglePlayPause() {
    setState(() {
      _isPlaying = !_isPlaying;
      if (_isPlaying) {
        _controller.play();
      } else {
        _controller.pause();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: GestureDetector(
        onTap: _togglePlayPause,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              color: Colors.black,
              child: _controller.value.isInitialized
                  ? FittedBox(
                fit: BoxFit.cover,
                child: SizedBox(
                  width: _controller.value.size.width,
                  height: _controller.value.size.height,
                  child: VideoPlayer(_controller),
                ),
              )
                  : const Center(child: CircularProgressIndicator()),
            ),
            Positioned(
              bottom: 16, // Position above the bottom navigation bar height
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                decoration: BoxDecoration(
                  color: Colors.transparent, // Colors.black.withOpacity(0.7), // Semi-transparent for readability
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        const CircleAvatar(
                          radius: 20,
                          backgroundImage: AssetImage('assets/images/show_logo.png'),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            widget.video.restaurantName ?? 'Kaistable at Drews',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontFamily: 'PlusJakartaSans',
                            ),
                          ),
                        ),
                        Obx(
                              () => GestureDetector(
                            onTap: _toggleBookmark,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Icon(
                                _isBookmarked.value ? Icons.bookmark : Icons.bookmark_border,
                                color: Colors.white,
                                size: 22,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
                      future: FirebaseFirestore.instance
        .collection('restaurants')
        .where('zipCode', isEqualTo: widget.video.zipCode)
        .where('resName', isEqualTo: widget.video.restaurantName)
        .limit(1)
        .get(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return Text(
                            'Loading description...',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              fontFamily: 'PlusJakartaSans',
                            ),
                          );
                        }
                        final restaurant = snapshot.data;
                        return Padding(
                          padding: const EdgeInsets.only(right: 64),
                          child: Text(
                            restaurant != null && restaurant.size != 0
                                ? restaurant.docs.first['about']
                                : 'No description available.',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              fontFamily: 'PlusJakartaSans',
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        // const Icon(Icons.location_pin, color: Colors.white, size: 16),
                        Image.asset('assets/icons/location.png', height: 12, width: 12, color: Colors.white,),
                        const SizedBox(width: 4),
                        Text(
                          (widget.video.streetNo ?? '') + ', ' + (widget.video.city ?? '') + ', ' + (widget.video.state ?? '') + (widget.video.zipCode == null || widget.video.zipCode == '' ? '' : ', ${widget.video.zipCode}'), // 'Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.white,
                            fontFamily: 'PlusJakartaSans',
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}