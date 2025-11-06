import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';

import '../../../main.dart';
import '../../../streams/model/streams_model.dart';

class ScrollableFullVideoScreen extends StatefulWidget {
  final List<VideoModel> videos;
  final int initialIndex;

  const ScrollableFullVideoScreen({
    super.key,
    required this.videos,
    required this.initialIndex,
  });

  @override
  State<ScrollableFullVideoScreen> createState() => _ScrollableFullVideoScreenState();
}

class _ScrollableFullVideoScreenState extends State<ScrollableFullVideoScreen> {
  late PageController _pageController;
  late int _currentIndex;

  // Map to store video controllers for each video
  final Map<int, VideoPlayerController> _controllers = {};
  final Map<int, bool> _initialized = {};
  final Map<int, bool> _isInitializing = {}; // Track videos currently being initialized

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: widget.initialIndex);

    // Aggressively preload videos for better performance
    _preloadVideosAround(_currentIndex);
  }

  @override
  void dispose() {
    // Dispose all video controllers
    for (var controller in _controllers.values) {
      controller.dispose();
    }
    _pageController.dispose();
    super.dispose();
  }

  @override
  void deactivate() {
    // Pause all videos when navigating away
    _pauseAllVideos();
    super.deactivate();
  }

  // Optimized video initialization with better buffering options
  void _initializeVideo(int index) {
    // Skip if already initialized or currently initializing
    if (_initialized[index] == true || _isInitializing[index] == true) return;

    final video = widget.videos[index];
    if (video.mediaType == 'video' && video.url != null) {
      _isInitializing[index] = true;

      final controller = VideoPlayerController.networkUrl(
        Uri.parse(video.url!),
        videoPlayerOptions: VideoPlayerOptions(
          mixWithOthers: true,
          allowBackgroundPlayback: false,
        ),
      );
      _controllers[index] = controller;

      controller.initialize().then((_) {
        if (mounted) {
          setState(() {
            _initialized[index] = true;
            _isInitializing[index] = false;
          });
          // Only play if this is the current video being viewed
          if (_currentIndex == index) {
            controller.play();
            controller.setLooping(true);
          } else {
            // Ensure preloaded videos are paused
            controller.pause();
          }
        }
      }).catchError((error) {
        print('Error initializing video at index $index: $error');
        _isInitializing[index] = false;
      });
    }
  }

  // Preload videos around the current index for smoother experience
  void _preloadVideosAround(int index) {
    // Initialize current video (will auto-play based on _currentIndex check)
    _initializeVideo(index);

    // Preload next 2 videos (will be paused)
    if (index + 1 < widget.videos.length) {
      _initializeVideo(index + 1);
    }
    if (index + 2 < widget.videos.length) {
      _initializeVideo(index + 2);
    }

    // Preload previous video (will be paused)
    if (index - 1 >= 0) {
      _initializeVideo(index - 1);
    }

    // Clean up videos that are far away to save memory (keep only 3 before and 3 after)
    _cleanupDistantVideos(index);
  }

  // Cleanup videos that are too far from current index to save memory
  void _cleanupDistantVideos(int currentIndex) {
    final indicesToRemove = <int>[];
    
    _controllers.forEach((index, controller) {
      // Keep videos within range of 3 indices before and after
      if ((index < currentIndex - 3 || index > currentIndex + 3)) {
        indicesToRemove.add(index);
      }
    });

    for (var index in indicesToRemove) {
      _controllers[index]?.dispose();
      _controllers.remove(index);
      _initialized.remove(index);
      _isInitializing.remove(index);
    }
  }

  void _onPageChanged(int index) {
    // Pause ALL videos first to ensure no background playback
    _pauseAllVideos();

    setState(() {
      _currentIndex = index;
    });

    // Play the current video immediately if already initialized
    if (_controllers[index] != null && _initialized[index] == true) {
      _controllers[index]?.play();
      _controllers[index]?.setLooping(true);
    }

    // Preload videos around the new current index
    _preloadVideosAround(index);
  }

  // Pause all videos to prevent background playback
  void _pauseAllVideos() {
    for (var controller in _controllers.values) {
      if (controller.value.isInitialized && controller.value.isPlaying) {
        controller.pause();
      }
    }
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
      body: PageView.builder(
        controller: _pageController,
        scrollDirection: Axis.vertical,
        itemCount: widget.videos.length,
        onPageChanged: _onPageChanged,
        itemBuilder: (context, index) {
          return _VideoPage(
            video: widget.videos[index],
            controller: _controllers[index],
            isInitialized: _initialized[index] == true,
            isCurrentPage: _currentIndex == index,
          );
        },
      ),
    );
  }
}

class _VideoPage extends StatefulWidget {
  final VideoModel video;
  final VideoPlayerController? controller;
  final bool isInitialized;
  final bool isCurrentPage;

  const _VideoPage({
    required this.video,
    required this.controller,
    required this.isInitialized,
    required this.isCurrentPage,
  });

  @override
  State<_VideoPage> createState() => _VideoPageState();
}

class _VideoPageState extends State<_VideoPage> {
  bool _isPlaying = true;
  final RxBool _isBookmarked = false.obs;

  @override
  void initState() {
    super.initState();

    if (auth.currentUser != null) {
      final userId = auth.currentUser!.uid;
      FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('saved_videos')
          .doc(widget.video.videoId)
          .snapshots()
          .listen(
            (snapshot) async {
          _isBookmarked.value = snapshot.exists;
          final prefs = await SharedPreferences.getInstance();
          final savedVideos = prefs.getStringList('saved_videos') ?? [];
          if (!savedVideos.contains(widget.video.videoId)) {
            savedVideos.add(widget.video.videoId!);
            prefs.setStringList('saved_videos', savedVideos);
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

  Future<void> _toggleBookmark() async {
    try {
      final videoId = widget.video.videoId;
      if (_isBookmarked.value) {
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
        _isBookmarked.value = false;
      } else {
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
          _isBookmarked.value = true;
        }
      }
    } catch (e) {
      print('Error toggling bookmark: $e');
      Get.snackbar('Error', 'Failed to update bookmark: $e',
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  void _togglePlayPause() {
    if (widget.video.mediaType != 'video') return;
    setState(() {
      _isPlaying = !_isPlaying;
      if (_isPlaying) {
        widget.controller?.play();
      } else {
        widget.controller?.pause();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _togglePlayPause,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            color: Colors.black,
            child: widget.video.mediaType == 'video'
                ? (widget.isInitialized
                ? FittedBox(
              fit: BoxFit.cover,
              child: SizedBox(
                width: widget.controller!.value.size.width,
                height: widget.controller!.value.size.height,
                child: VideoPlayer(widget.controller!),
              ),
            )
                : const Center(child: CircularProgressIndicator()))
                : Image.network(
              widget.video.url ?? '',
              fit: BoxFit.cover,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return const Center(child: CircularProgressIndicator());
              },
              errorBuilder: (context, error, stackTrace) => Container(
                color: Colors.grey[300],
                child: const Icon(Icons.broken_image, size: 50, color: Colors.grey),
              ),
            ),
          ),
          Positioned(
            bottom: 16,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              decoration: BoxDecoration(
                color: Colors.transparent,
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
                  Padding(
                    padding: const EdgeInsets.only(right: 64),
                    child: Text(
                      widget.video.description == null || widget.video.description!.isEmpty
                          ? '' : widget.video.description!,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontFamily: 'PlusJakartaSans',
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Image.asset('assets/icons/location.png', height: 12, width: 12, color: Colors.white,),
                      const SizedBox(width: 4),
                      Text(
                        (widget.video.streetNo ?? '') + ', ' + (widget.video.city ?? '') + ', ' + (widget.video.state ?? '') + (widget.video.zipCode == null || widget.video.zipCode == '' ? '' : ', ${widget.video.zipCode}'),
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
    );
  }
}

