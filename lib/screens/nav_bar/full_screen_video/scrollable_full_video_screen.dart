import 'dart:io';

import 'package:flutter/material.dart';

import '../../../streams/model/streams_model.dart';
import '../../../utils/video_cache_manager.dart';
import '../../../widgets/tiktok_video_widget.dart';

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

  /// Called when the user is near the end, so caller can fetch more.
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
    // Notify caller to load more if near the end
    if (index >= widget.videos.length - 5) {
      widget.onLoadMore?.call();
    }
    _preCacheAdjacent(index);
  }

  // ── Build ─────────────────────────────────────────────────────────────────

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
          return TikTokVideoWidget(
            key: ValueKey('tiktok_${video.videoId ?? index}'),
            video: video,
            index: index,
            thumbnailPath: widget.thumbnailPaths[video.url],
          );
        },
      ),
    );
  }
}
