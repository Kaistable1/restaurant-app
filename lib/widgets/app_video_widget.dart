import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../streams/model/streams_model.dart';
import '../utils/video_cache_manager.dart';

class AppVideoPlayer extends StatefulWidget {
  final VideoModel video;
  final int index;
  final String? thumbnailPath;
  final BoxFit fit;

  const AppVideoPlayer({
    super.key,
    required this.video,
    required this.index,
    this.thumbnailPath,
    this.fit = BoxFit.cover,
  });

  @override
  State<AppVideoPlayer> createState() => AppVideoPlayerState();
}

class AppVideoPlayerState extends State<AppVideoPlayer> {
  VideoPlayerController? _controller;
  bool _initialized = false;
  bool _initializing = false;
  bool _isVisible = false;
  bool _isManuallyPaused = false;

  @override
  void initState() {
    super.initState();
    _initVideo();
  }

  @override
  void dispose() {
    _disposeController();
    super.dispose();
  }

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

      // 1. Check existing cached path in model
      final existingPath = widget.video.cachedPath;
      if (existingPath != null && File(existingPath).existsSync()) {
        filePath = existingPath;
      } else {
        // 2. Resolve via Cache Manager
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
        // 3. Network fallback
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

      if (_isVisible && !_isManuallyPaused) {
        controller.play();
      }
    } catch (_) {
      if (mounted) setState(() => _initializing = false);
    }
  }

  void _onVisibilityChanged(VisibilityInfo info) {
    if (!mounted) return;
    final visible = info.visibleFraction >= 0.9;
    if (visible == _isVisible) return;
    _isVisible = visible;

    if (!_initialized || _controller == null) return;

    if (visible) {
      if (!_isManuallyPaused) _controller!.play();
    } else {
      _controller!.pause();
    }
  }

  void togglePlay() {
    if (!_initialized || _controller == null) return;
    setState(() {
      if (_controller!.value.isPlaying) {
        _controller!.pause();
        _isManuallyPaused = true;
      } else {
        _controller!.play();
        _isManuallyPaused = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: Key('video_player_${widget.index}_${widget.video.videoId}'),
      onVisibilityChanged: _onVisibilityChanged,
      child: Stack(
        fit: StackFit.expand,
        children: [
          _buildContent(),
          if (_initialized && _isManuallyPaused)
            Center(
              child: Icon(
                Icons.pause_circle_filled_rounded,
                color: Colors.white.withValues(alpha: 0.75),
                size: 80,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    if (widget.video.mediaType != 'video') {
      final url = widget.video.url;
      if (url != null && url.isNotEmpty) {
        return Image.network(url, fit: widget.fit);
      }
      return const ColoredBox(color: Colors.black);
    }

    if (_initialized &&
        _controller != null &&
        _controller!.value.isInitialized) {
      return FittedBox(
        fit: widget.fit,
        child: SizedBox(
          width: _controller!.value.size.width,
          height: _controller!.value.size.height,
          child: VideoPlayer(_controller!),
        ),
      );
    }

    final thumbPath = widget.thumbnailPath;
    if (thumbPath != null && File(thumbPath).existsSync()) {
      return Stack(
        fit: StackFit.expand,
        children: [
          Image.file(File(thumbPath), fit: widget.fit),
          const Center(
            child: CircularProgressIndicator(
              color: Colors.white,
              strokeWidth: 2.5,
            ),
          ),
        ],
      );
    }

    return const ColoredBox(
      color: Colors.black,
      child: Center(
        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5),
      ),
    );
  }
}
