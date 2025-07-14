import 'package:video_player/video_player.dart';

class VideoItem {
  final String id;
  final String url;
  final String caption;
  final String restaurantName;
  final String sreetNo;
  final String city;
  final String state;
  final String zipCode;

  VideoPlayerController? controller;

  VideoItem({
    required this.id,
    required this.url,
    required this.caption,
    required this.restaurantName,
    required this.sreetNo,
    required this.city,
    required this.state,
    required this.zipCode,
    this.controller,
  });
}
