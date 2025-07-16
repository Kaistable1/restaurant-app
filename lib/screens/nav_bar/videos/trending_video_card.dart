import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:kaistable_website/constants/app_colors.dart';
import 'package:kaistable_website/models/video_model.dart';
import 'package:video_player/video_player.dart';
import 'package:url_launcher/url_launcher.dart';

class TrendingVideoCard extends StatefulWidget {
  final VideoModel video;
  final VoidCallback onFilterTap;

  const TrendingVideoCard({
    required this.video,
    required this.onFilterTap,
  });

  @override
  State<TrendingVideoCard> createState() => _TrendingVideoCardState();
}

class _TrendingVideoCardState extends State<TrendingVideoCard> {
  late VideoPlayerController _controller;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.video.url)
      ..initialize().then((_) {
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
      if (_controller.value.isPlaying) {
        _controller.pause();
        _isPlaying = false;
      } else {
        _controller.play();
        _isPlaying = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Background Video
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: SizedBox(
            height: 290,
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: _controller.value.isInitialized
                  ? VideoPlayer(_controller)
                  : const Center(child: CircularProgressIndicator()),
            ),
          ),
        ),

        // Center Play/Pause Button
        Positioned.fill(
          child: Center(
            child: GestureDetector(
              onTap: _togglePlayPause,
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.6),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  _isPlaying ? Icons.pause : Icons.play_arrow,
                  color: Colors.white,
                  size: 30,
                ),
              ),
            ),
          ),
        ),

        // Blurred Info Panel
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: ClipRRect(
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(12),
              bottomRight: Radius.circular(12),
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(12),
                    bottomRight: Radius.circular(12),
                  ),
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      AppColors.primaryColor.withOpacity(0.5),
                      AppColors.primaryColor.withOpacity(0.5),
                    ],
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.video.restaurantName,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        fontFamily: 'NunitoSans-Bold',
                      ),
                    ),
                    Text(
                      '${widget.video.streetNo}, ${widget.video.city}, ${widget.video.state} - ${widget.video.zipCode}',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        fontFamily: 'NunitoSans-Regular',
                      ),
                    ),
                    if (widget.video.caption.isNotEmpty)
                      Text(
                        widget.video.caption,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.white70,
                          fontFamily: 'NunitoSans-Regular',
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),

        // Filter & Direction Buttons
        Positioned(
          bottom: 16,
          right: 16,
          child: Column(
            children: [
              GestureDetector(
                onTap: widget.onFilterTap,
                child: const Image(
                  image: AssetImage("assets/images/filter.png"),
                  width: 20,
                  height: 20,
                ),
              ),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: () async {
                  final address = Uri.encodeComponent(
                      '${widget.video.streetNo}, ${widget.video.city}, ${widget.video.state}');
                  final mapsUrl =
                      'https://www.google.com/maps/search/?api=1&query=$address';

                  if (await canLaunch(mapsUrl)) {
                    await launch(mapsUrl);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Could not launch Google Maps'),
                      ),
                    );
                  }
                },
                child: const Image(
                  image: AssetImage("assets/images/direction.png"),
                  width: 20,
                  height: 20,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
