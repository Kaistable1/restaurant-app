import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

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

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.video.url!))
      ..initialize().then((_) {
        _controller.play();
        _controller.setLooping(true);
        setState(() {});
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
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
            _controller.value.isInitialized
                ? VideoPlayer(_controller)
                : const Center(child: CircularProgressIndicator()),
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
                          backgroundImage: AssetImage('assets/images/Ellipse 19.png'),
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
                        GestureDetector(
                          onTap: () {
                            // restaurantCtrl.toggleBookmark(restaurant.docID);
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Icon(
                              Icons.bookmark, //  : Icons.bookmark_border,
                              color: Colors.white,
                              size: 22,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.only(right: 64),
                      child: Text(
                        'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore.',
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
                        // const Icon(Icons.location_pin, color: Colors.white, size: 16),
                        Image.asset('assets/icons/location.png', height: 12, width: 12, color: Colors.white,),
                        const SizedBox(width: 4),
                        Text(
                          'Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
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