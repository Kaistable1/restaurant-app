import 'package:video_player/video_player.dart';

class VideoItem {
  final String id;
  final String url;
  final String caption;
  final String restaurantName;
  final String restaurantAddress;
  VideoPlayerController? controller;

  VideoItem({
    required this.id,
    required this.url,
    required this.caption,
    required this.restaurantName,
    required this.restaurantAddress,
    this.controller,
  });
}
