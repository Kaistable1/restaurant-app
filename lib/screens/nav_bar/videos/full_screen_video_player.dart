import 'package:flutter/material.dart';
import 'package:kaistable_website/models/video_model.dart';
import 'package:video_player/video_player.dart';

class FullScreenVideoPlayerScreen extends StatefulWidget {
  final List<VideoModel> videos;
  final int initialIndex;

  const FullScreenVideoPlayerScreen({
    super.key,
    required this.videos,
    required this.initialIndex,
  });

  @override
  State<FullScreenVideoPlayerScreen> createState() =>
      _FullScreenVideoPlayerScreenState();
}

class _FullScreenVideoPlayerScreenState
    extends State<FullScreenVideoPlayerScreen> {
  late final PageController _pageController;
  final Map<int, VideoPlayerController> _controllers = {};
  int _currentPage = 0;
  final Map<int, VoidCallback> _controllerListeners = {};

  @override
  void initState() {
    super.initState();
    _currentPage = widget.initialIndex;
    _pageController = PageController(initialPage: _currentPage);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _pageController.addListener(_handleScroll);
    });

    _manageControllers();
  }

  void _handleScroll() {
    if (!_pageController.hasClients) return;
    final newPage = _pageController.page?.round() ?? 0;

    if (newPage != _currentPage) {
      setState(() => _currentPage = newPage);
      _manageControllers();
    }
  }

  // void _manageControllers() {
  //   for (int i = _currentPage - 1; i <= _currentPage + 1; i++) {
  //     if (i >= 0 && i < widget.videos.length) {
  //       if (!_controllers.containsKey(i)) {
  //         final controller =
  //             VideoPlayerController.network(widget.videos[i].url);

  //         controller.initialize().then((_) {
  //           controller.setLooping(true);
  //           if (i == _currentPage) controller.play();

  //           // ✅ Add listener to update progress
  //           VoidCallback listener = () => setState(() {});
  //           controller.addListener(listener);
  //           _controllerListeners[i] = listener;

  //           setState(() {});
  //         });

  //         _controllers[i] = controller;
  //       } else {
  //         if (i == _currentPage && !_controllers[i]!.value.isPlaying) {
  //           _controllers[i]!.play();
  //         }
  //       }
  //     }
  //   }

  //   final removeKeys = _controllers.keys
  //       .where((k) => k < _currentPage - 1 || k > _currentPage + 1)
  //       .toList();

  //   for (var i in removeKeys) {
  //     _controllers[i]?.dispose();
  //     _controllers.remove(i);
  //   }
  // }



void _manageControllers() {
  // ✅ Pause all currently playing videos
  for (var controller in _controllers.values) {
    if (controller.value.isPlaying) {
      controller.pause();
    }
  }

  // ✅ Loop: preload previous, current, next
  for (int i = _currentPage - 1; i <= _currentPage + 1; i++) {
    if (i >= 0 && i < widget.videos.length) {
      if (!_controllers.containsKey(i)) {
        final controller =
            VideoPlayerController.network(widget.videos[i].url);

        controller.initialize().then((_) {
          controller.setLooping(true);
          if (i == _currentPage) controller.play();

          VoidCallback listener = () => setState(() {});
          controller.addListener(listener);
          _controllerListeners[i] = listener;

          setState(() {});
        });

        _controllers[i] = controller;
      }
    }
  }

  // ✅ Only play current page’s controller
  if (_controllers[_currentPage] != null &&
      _controllers[_currentPage]!.value.isInitialized) {
    _controllers[_currentPage]!.play();
  }

  // ✅ Dispose unnecessary controllers (outside ±1 range)
  final removeKeys = _controllers.keys
      .where((k) => k < _currentPage - 1 || k > _currentPage + 1)
      .toList();

  for (var i in removeKeys) {
    _controllers[i]?.removeListener(_controllerListeners[i]!);
    _controllers[i]?.dispose();
    _controllers.remove(i);
    _controllerListeners.remove(i);
  }
}

 
  @override
  void dispose() {
    _pageController.dispose();
    for (var i in _controllers.keys) {
      _controllers[i]?.removeListener(_controllerListeners[i]!);
      _controllers[i]?.dispose();
    }
    _controllers.clear();
    _controllerListeners.clear();
    super.dispose();
  }

  String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: PageView.builder(
        controller: _pageController,
        scrollDirection: Axis.vertical,
        itemCount: widget.videos.length,
        itemBuilder: (context, index) {
          final video = widget.videos[index];
          final controller = _controllers[index];

          return controller != null && controller.value.isInitialized
              ? GestureDetector(
                  onTap: () {
                    if (controller.value.isPlaying) {
                      controller.pause();
                    } else {
                      controller.play();
                    }
                    setState(() {});
                  },
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      FittedBox(
                        fit: BoxFit.cover,
                        child: SizedBox(
                          width: controller.value.size.width,
                          height: controller.value.size.height,
                          child: VideoPlayer(controller),
                        ),
                      ),

                      // Play icon if paused
                      if (!controller.value.isPlaying)
                        const Center(
                          child: Icon(Icons.play_arrow,
                              color: Colors.white, size: 80),
                        ),

                      // 🔙 Back Button (top-left)
                      Positioned(
                        top: 40,
                        left: 16,
                        child: GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: const CircleAvatar(
                            backgroundColor: Colors.black54,
                            child: Icon(Icons.arrow_back, color: Colors.white),
                          ),
                        ),
                      ),

                      // 📝 Info bottom left
                      Positioned(
                        bottom: 80,
                        left: 20,
                        right: 20,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              video.restaurantName ?? '',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${video.city ?? ''}, ${video.state ?? ''}',
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // ⏱ Progress Bar and Time
                      Positioned(
                        bottom: 20,
                        left: 16,
                        right: 16,
                        child: Column(
                          children: [
                            SliderTheme(
                              data: SliderThemeData(
                                thumbShape: const RoundSliderThumbShape(
                                    enabledThumbRadius: 5),
                                overlayShape: SliderComponentShape.noOverlay,
                              ),
                              child: Slider(
                                value: controller.value.position.inMilliseconds
                                    .toDouble()
                                    .clamp(
                                      0,
                                      controller.value.duration.inMilliseconds
                                          .toDouble(),
                                    ),
                                min: 0,
                                max: controller.value.duration.inMilliseconds
                                    .toDouble(),
                                activeColor: Colors.white,
                                inactiveColor: Colors.white38,
                                onChanged: (value) {
                                  controller.seekTo(
                                    Duration(milliseconds: value.toInt()),
                                  );
                                },
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  formatDuration(controller.value.position),
                                  style: const TextStyle(
                                      color: Colors.white70, fontSize: 12),
                                ),
                                Text(
                                  formatDuration(controller.value.duration),
                                  style: const TextStyle(
                                      color: Colors.white70, fontSize: 12),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              : const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
