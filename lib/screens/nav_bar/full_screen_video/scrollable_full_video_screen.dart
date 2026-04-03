import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../main.dart';
import '../../../streams/model/streams_model.dart';
import '../../../utils/video_cache_manager.dart';
import '../../../widgets/app_video_widget.dart';

// ─────────────────────────────────────────────────────────────────────────────
// ScrollableFullVideoScreen
//
// A thin, decoupled shell — it knows nothing about VideoController.
// Caller passes the data list, thumbnail map, and an optional callback to load
// more videos when the user nears the end.
// ─────────────────────────────────────────────────────────────────────────────

class ScrollableFullVideoScreen extends StatefulWidget {
  final List<VideoModel> videos;
  final Map<String, String> thumbnailPaths;
  final int initialIndex;

  final VoidCallback? onLoadMore;

  const ScrollableFullVideoScreen({
    super.key,
    required this.videos,
    required this.thumbnailPaths,
    required this.initialIndex,
    this.onLoadMore,
  });

  @override
  State<ScrollableFullVideoScreen> createState() =>
      _ScrollableFullVideoScreenState();
}

class _ScrollableFullVideoScreenState
    extends State<ScrollableFullVideoScreen> {
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: widget.initialIndex);
    _preCacheAdjacent(widget.initialIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  // ── Background pre-caching ─────────────────────────────────────────────────

  void _preCacheAdjacent(int index) {
    final videos = widget.videos;
    for (int offset = -1; offset <= 3; offset++) {
      if (offset == 0) continue;
      final i = index + offset;
      if (i >= 0 && i < videos.length) {
        final url = videos[i].url;
        if (url != null && url.isNotEmpty && !File(videos[i].cachedPath ?? '').existsSync()) {
          VideoCacheManager.preCacheVideo(url);
        }
      }
    }
  }

  void _onPageChanged(int index) {
    if (index >= widget.videos.length - 5) {
      widget.onLoadMore?.call();
    }
    _preCacheAdjacent(index);
  }

  @override
  Widget build(BuildContext context) {
    final videos = widget.videos;

    if (videos.isEmpty) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(child: CircularProgressIndicator(color: Colors.white)),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: PageView.builder(
        controller: _pageController,
        scrollDirection: Axis.vertical,
        itemCount: videos.length,
        onPageChanged: _onPageChanged,
        itemBuilder: (context, index) {
          if (index >= videos.length) return const SizedBox.shrink();
          final video = videos[index];
          return _VideoPageWithOverlay(
            key: ValueKey('video_page_${video.videoId ?? index}'),
            video: video,
            index: index,
            thumbnailPath: widget.thumbnailPaths[video.url],
          );
        },
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _VideoPageWithOverlay
//
// Wraps the generic AppVideoPlayer and adds full-screen TikTok-style overlays:
//  • Bottom info (name, description, location)
//  • Bookmark toggle
//  • Gradient background for text legibility
// ─────────────────────────────────────────────────────────────────────────────

class _VideoPageWithOverlay extends StatefulWidget {
  final VideoModel video;
  final int index;
  final String? thumbnailPath;

  const _VideoPageWithOverlay({
    super.key,
    required this.video,
    required this.index,
    this.thumbnailPath,
  });

  @override
  State<_VideoPageWithOverlay> createState() => _VideoPageWithOverlayState();
}

class _VideoPageWithOverlayState extends State<_VideoPageWithOverlay> {
  final GlobalKey<AppVideoPlayerState> _playerKey = GlobalKey<AppVideoPlayerState>();
  final RxBool _isBookmarked = false.obs;
  StreamSubscription<dynamic>? _bookmarkSub;

  @override
  void initState() {
    super.initState();
    _initBookmark();
  }

  @override
  void dispose() {
    _bookmarkSub?.cancel();
    super.dispose();
  }

  void _initBookmark() {
    if (auth.currentUser != null) {
      final uid = auth.currentUser!.uid;
      _bookmarkSub = FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('saved_videos')
          .doc(widget.video.videoId)
          .snapshots()
          .listen(
        (snap) async {
          if (!mounted) return;
          _isBookmarked.value = snap.exists;
          final prefs = await SharedPreferences.getInstance();
          final saved = prefs.getStringList('saved_videos') ?? [];
          final id = widget.video.videoId;
          if (snap.exists && id != null && !saved.contains(id)) {
            saved.add(id);
            prefs.setStringList('saved_videos', saved);
          }
        },
        onError: (_) {},
      );
    } else {
      _loadBookmarkOffline();
    }
  }

  Future<void> _loadBookmarkOffline() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final saved = prefs.getStringList('saved_videos') ?? [];
      if (mounted) _isBookmarked.value = saved.contains(widget.video.videoId);
    } catch (_) {}
  }

  Future<void> _toggleBookmark() async {
    final id = widget.video.videoId;
    if (id == null) return;

    final wasBookmarked = _isBookmarked.value;
    _isBookmarked.value = !wasBookmarked;

    try {
      final prefs = await SharedPreferences.getInstance();
      final saved = prefs.getStringList('saved_videos') ?? [];

      if (wasBookmarked) {
        saved.remove(id);
        if (auth.currentUser != null) {
          await FirebaseFirestore.instance
              .collection('users')
              .doc(auth.currentUser!.uid)
              .collection('saved_videos')
              .doc(id)
              .delete();
        }
      } else {
        if (!saved.contains(id)) saved.add(id);
        if (auth.currentUser != null) {
          await FirebaseFirestore.instance
              .collection('users')
              .doc(auth.currentUser!.uid)
              .collection('saved_videos')
              .doc(id)
              .set({'videoID': id});
        }
      }
      await prefs.setStringList('saved_videos', saved);
    } catch (_) {
      if (mounted) _isBookmarked.value = wasBookmarked;
    }
  }

  @override
  Widget build(BuildContext context) {
    final video = widget.video;
    final addressParts = <String>[
      if (video.streetNo?.isNotEmpty == true) video.streetNo!,
      if (video.city?.isNotEmpty == true) video.city!,
      if (video.state?.isNotEmpty == true) video.state!,
      if (video.zipCode?.isNotEmpty == true) video.zipCode!,
    ];

    return Stack(
      fit: StackFit.expand,
      children: [
        // 1. The Headless Video Player
        AppVideoPlayer(
          key: _playerKey,
          video: widget.video,
          index: widget.index,
          thumbnailPath: widget.thumbnailPath,
          fit: BoxFit.cover,
        ),

        GestureDetector(
          onTap: () {
            // Forward tap to player's toggle logic
            final state = _playerKey.currentState;
            if (state != null) {
              state.togglePlay();
            }
          },
        ),

        // 3. Gradient overlay for legible text at the bottom
        const Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.transparent,
                  Color(0x44000000),
                  Color(0xCC000000),
                ],
                stops: [0.0, 0.5, 0.75, 1.0],
              ),
            ),
          ),
        ),

        // 4. Metadata overlay
        Positioned(
          bottom: 20,
          left: 0,
          right: 0,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Restaurant name + bookmark
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const CircleAvatar(
                      radius: 20,
                      backgroundImage: AssetImage('assets/images/show_logo.png'),
                      backgroundColor: Colors.transparent,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        video.restaurantName ?? 'Kaistable',
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontFamily: 'PlusJakartaSans',
                          shadows: [Shadow(blurRadius: 4, color: Colors.black54)],
                        ),
                      ),
                    ),
                    Obx(
                      () => GestureDetector(
                        onTap: _toggleBookmark,
                        child: Icon(
                          _isBookmarked.value
                              ? Icons.bookmark_rounded
                              : Icons.bookmark_border_rounded,
                          color: Colors.white,
                          size: 28,
                        ),
                      ),
                    ),
                  ],
                ),

                // Description
                if (video.description?.isNotEmpty == true) ...[
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.only(right: 48),
                    child: Text(
                      video.description!,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                        fontFamily: 'PlusJakartaSans',
                        shadows: [Shadow(blurRadius: 3, color: Colors.black54)],
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],

                // Address
                if (addressParts.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Image.asset(
                        'assets/icons/location.png',
                        height: 12,
                        width: 12,
                        color: Colors.white,
                      ),
                      const SizedBox(width: 5),
                      Expanded(
                        child: Text(
                          addressParts.join(', '),
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.white,
                            fontFamily: 'PlusJakartaSans',
                            shadows: [Shadow(blurRadius: 3, color: Colors.black54)],
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }
}
