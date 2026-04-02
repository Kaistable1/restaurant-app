import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../main.dart';
import '../streams/model/streams_model.dart';
import '../utils/video_cache_manager.dart';

class TikTokVideoWidget extends StatefulWidget {
  final VideoModel video;
  final int index;
  final String? thumbnailPath;

  const TikTokVideoWidget({
    super.key,
    required this.video,
    required this.index,
    this.thumbnailPath,
  });

  @override
  State<TikTokVideoWidget> createState() => _TikTokVideoWidgetState();
}

class _TikTokVideoWidgetState extends State<TikTokVideoWidget> {
  VideoPlayerController? _controller;
  bool _initialized = false;
  bool _initializing = false;
  bool _isPlaying = true;
  bool _isVisible = false;
  StreamSubscription<dynamic>? _bookmarkSub;
  final RxBool _isBookmarked = false.obs;

  @override
  void initState() {
    super.initState();
    _initVideo();
    _initBookmark();
  }

  @override
  void dispose() {
    _bookmarkSub?.cancel();
    _disposeController();
    super.dispose();
  }

  // ── Controller lifecycle ──────────────────────────────────────────────────

  void _disposeController() {
    final c = _controller;
    _controller = null;
    _initialized = false;
    _initializing = false;
    try {
      c?.pause();
      c?.dispose();
    } catch (_) {}
  }

  Future<void> _initVideo() async {
    if (_initializing) return;
    final url = widget.video.url;
    if (url == null || url.isEmpty) return;
    if (widget.video.mediaType != 'video') return;

    _initializing = true;

    try {
      String? filePath;
      final existingPath = widget.video.cachedPath;
      if (existingPath != null && File(existingPath).existsSync()) {
        filePath = existingPath;
      } else {
        filePath = await VideoCacheManager.cacheAndGetPath(url);
        if (filePath != null) {
          widget.video.cachedPath = filePath;
        }
      }

      if (!mounted) return;

      VideoPlayerController controller;
      if (filePath != null && File(filePath).existsSync()) {
        controller = VideoPlayerController.file(
          File(filePath),
          videoPlayerOptions: VideoPlayerOptions(mixWithOthers: false),
        );
      } else {
        controller = VideoPlayerController.networkUrl(
          Uri.parse(url),
          videoPlayerOptions: VideoPlayerOptions(mixWithOthers: false),
        );
      }

      _controller = controller;
      await controller.initialize();

      if (!mounted) {
        controller.dispose();
        _controller = null;
        return;
      }

      controller.setLooping(true);

      setState(() {
        _initialized = true;
        _initializing = false;
      });

      if (_isVisible) {
        controller.play();
      }
    } catch (_) {
      if (mounted) setState(() => _initializing = false);
    }
  }

  // ── Visibility ─────────────────────────────────────────────────────────

  void _onVisibilityChanged(VisibilityInfo info) {
    final visible = info.visibleFraction >= 0.85;
    if (visible == _isVisible) return;
    _isVisible = visible;

    if (!_initialized || _controller == null) return;

    if (visible) {
      if (_isPlaying) _controller!.play();
    } else {
      _controller!.pause();
    }
  }

  // ── Play / pause on tap ───────────────────────────────────────────────────

  void _togglePlayPause() {
    if (!_initialized || _controller == null) return;
    setState(() {
      _isPlaying = !_isPlaying;
      if (_isPlaying && _isVisible) {
        _controller!.play();
      } else {
        _controller!.pause();
      }
    });
  }

  // ── Bookmark ──────────────────────────────────────────────────────────────

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
    _isBookmarked.value = !wasBookmarked; // optimistic

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
      if (mounted) _isBookmarked.value = wasBookmarked; // revert on error
    }
  }

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: Key('tiktok_video_${widget.index}_${widget.video.videoId}'),
      onVisibilityChanged: _onVisibilityChanged,
      child: GestureDetector(
        onTap: _togglePlayPause,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // ── Video / placeholder ──────────────────────────────────────
            Container(color: Colors.black, child: _buildVideoContent()),

            // ── Gradient for readable text ───────────────────────────────
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

            // ── Pause icon ───────────────────────────────────────────────
            if (!_isPlaying)
              Center(
                child: Icon(
                  Icons.pause_circle_filled_rounded,
                  color: Colors.white.withValues(alpha: 0.75),
                  size: 80,
                ),
              ),

            // ── Info overlay ─────────────────────────────────────────────
            Positioned(
              bottom: 20,
              left: 0,
              right: 0,
              child: _buildInfoOverlay(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVideoContent() {
    final url = widget.video.url;

    // Non-video media type → just show network image
    if (widget.video.mediaType != 'video') {
      if (url != null && url.isNotEmpty) {
        return Image.network(url, fit: BoxFit.cover);
      }
      return const ColoredBox(color: Colors.black);
    }

    // Video is ready → render it full-screen
    if (_initialized &&
        _controller != null &&
        _controller!.value.isInitialized) {
      return FittedBox(
        fit: BoxFit.cover,
        child: SizedBox(
          width: _controller!.value.size.width,
          height: _controller!.value.size.height,
          child: VideoPlayer(_controller!),
        ),
      );
    }

    // Video not ready yet → show thumbnail as placeholder (no blank black screen)
    final thumbPath = widget.thumbnailPath;
    if (thumbPath != null && File(thumbPath).existsSync()) {
      return Stack(
        fit: StackFit.expand,
        children: [
          Image.file(File(thumbPath), fit: BoxFit.cover),
          const Center(
            child: CircularProgressIndicator(
              color: Colors.white,
              strokeWidth: 2.5,
            ),
          ),
        ],
      );
    }

    // Absolute fallback
    return const ColoredBox(
      color: Colors.black,
      child: Center(
        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5),
      ),
    );
  }

  Widget _buildInfoOverlay() {
    final video = widget.video;

    final addressParts = <String>[
      if (video.streetNo?.isNotEmpty == true) video.streetNo!,
      if (video.city?.isNotEmpty == true) video.city!,
      if (video.state?.isNotEmpty == true) video.state!,
      if (video.zipCode?.isNotEmpty == true) video.zipCode!,
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Name + bookmark
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
    );
  }
}
