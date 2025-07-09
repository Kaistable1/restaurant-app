import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:savrly/constants/app_colors.dart';
import 'package:savrly/controllers/video_controller.dart';
import 'package:video_player/video_player.dart';

class ViewVideo extends StatefulWidget {
  final Map<String, dynamic> videoData;
  final VideoPlayerController videoController;

  const ViewVideo({
    super.key,
    required this.videoController,
    required this.videoData,
  });

  @override
  State<ViewVideo> createState() => _ViewVideoState();
}

class _ViewVideoState extends State<ViewVideo> {
  @override
  void initState() {
    super.initState();
    widget.videoController.addListener(() {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    widget.videoController.removeListener(() {});
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            final videoController = Get.find<VideoController>();
            videoController.clearSelection();
            videoController.toggleViewMode();
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🔳 Video box centered with fixed height and width
            Center(
              child: Container(
                color: backgroundBlack,
                height: 438,
                width: 763,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(0),
                      child: SizedBox(
                        height: 438,
                        width: 763,
                        child: FittedBox(
                          fit: BoxFit.cover,
                          child: SizedBox(
                            width: widget.videoController.value.size.width,
                            height: widget.videoController.value.size.height,
                            child: VideoPlayer(widget.videoController),
                          ),
                        ),
                      ),
                    ),
                    Positioned.fill(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            if (widget.videoController.value.isPlaying) {
                              widget.videoController.pause();
                            } else {
                              widget.videoController.play();
                            }
                          });
                        },
                        child: Center(
                          child: Icon(
                            widget.videoController.value.isPlaying
                                ? Icons.pause
                                : Icons.play_arrow,
                            color: Colors.white.withOpacity(0.7),
                            size: 50,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: VideoProgressIndicator(
                        widget.videoController,
                        allowScrubbing: true,
                        colors: const VideoProgressColors(
                          playedColor: Colors.red,
                          bufferedColor: Colors.grey,
                          backgroundColor: Colors.white24,
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 10,
                      right: 10,
                      child: Text(
                        _buildTimeText(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // 📄 Information section, left aligned
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  infoRow(
                      'Restaurant name:', widget.videoData['restaurantName']),
                  infoRow('Location:', widget.videoData['location']),
                  infoRow('Posted Date:',
                      formatDate(widget.videoData['timestamp'])),
                  infoRow('Posted Time:',
                      formatTime(widget.videoData['timestamp'])),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _buildTimeText() {
    final position = widget.videoController.value.position;
    final duration = widget.videoController.value.duration;
    String format(Duration d) =>
        '${d.inMinutes}:${(d.inSeconds % 60).toString().padLeft(2, '0')}';
    return '${format(position)} / ${format(duration)}';
  }

  Widget infoRow(String title, String? value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(fontSize: 14, color: Colors.grey[600])),
          Text(value ?? 'Not specified',
              style:
                  const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  String? formatDate(dynamic timestamp) {
    if (timestamp == null) return null;
    try {
      DateTime dt = timestamp.toDate(); // Firebase Timestamp to DateTime
      return DateFormat('dd/MM/yyyy').format(dt); // e.g. 27/06/2025
    } catch (e) {
      return null;
    }
  }

  String? formatTime(dynamic timestamp) {
    if (timestamp == null) return null;
    try {
      DateTime dt = timestamp.toDate();
      return DateFormat('hh:mm a').format(dt); // e.g. 03:25 PM
    } catch (e) {
      return null;
    }
  }

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     appBar: AppBar(
  //       backgroundColor: Colors.white,
  //       elevation: 0,
  //       leading: IconButton(
  //         icon: const Icon(Icons.arrow_back, color: Colors.black),
  //         onPressed: () {
  //           final videoController = Get.find<VideoController>();
  //           videoController.clearSelection();
  //           videoController.toggleViewMode();
  //         },
  //       ),
  //     ),
  //     body: Column(
  //       crossAxisAlignment: CrossAxisAlignment.stretch,
  //       children: [
  //         // Video Player Section
  //         AspectRatio(
  //           aspectRatio: 16 / 9,
  //           child: Stack(
  //             alignment: Alignment.center,
  //             children: [
  //               VideoPlayer(widget.videoController),
  //               Positioned.fill(
  //                 child: GestureDetector(
  //                   onTap: () {
  //                     if (widget.videoController.value.isPlaying) {
  //                       widget.videoController.pause();
  //                     } else {
  //                       widget.videoController.play();
  //                     }
  //                   },
  //                   child: Container(
  //                     color: Colors.transparent,
  //                     child: Center(
  //                       child: Icon(
  //                         widget.videoController.value.isPlaying
  //                             ? Icons.pause
  //                             : Icons.play_arrow,
  //                         color: Colors.white.withOpacity(0.7),
  //                         size: 50,
  //                       ),
  //                     ),
  //                   ),
  //                 ),
  //               ),
  //               Positioned(
  //                 bottom: 0,
  //                 left: 0,
  //                 right: 0,
  //                 child: VideoProgressIndicator(
  //                   widget.videoController,
  //                   allowScrubbing: true,
  //                   colors: const VideoProgressColors(
  //                     playedColor: Colors.red,
  //                     bufferedColor: Colors.grey,
  //                     backgroundColor: Colors.white24,
  //                   ),
  //                 ),
  //               ),
  //               Positioned(
  //                 bottom: 10,
  //                 right: 10,
  //                 child: Text(
  //                   '${widget.videoController.value.position.inMinutes}:${(widget.videoController.value.position.inSeconds % 60).toString().padLeft(2, '0')} / '
  //                   '${widget.videoController.value.duration.inMinutes}:${(widget.videoController.value.duration.inSeconds % 60).toString().padLeft(2, '0')}',
  //                   style: const TextStyle(
  //                     color: Colors.white,
  //                     fontSize: 12,
  //                     fontWeight: FontWeight.bold,
  //                   ),
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ),

  //         // Video Information Section
  //         Padding(
  //           padding: const EdgeInsets.all(16.0),
  //           child: Column(
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: [
  //               const SizedBox(height: 16),
  //               Text(
  //                 'Restaurant name:',
  //                 style: TextStyle(
  //                   fontSize: 14,
  //                   color: Colors.grey[600],
  //                 ),
  //               ),
  //               Text(
  //                 widget.videoData['restaurantName'] ?? 'Not specified',
  //                 style: const TextStyle(
  //                   fontSize: 18,
  //                   fontWeight: FontWeight.bold,
  //                 ),
  //               ),
  //               const SizedBox(height: 12),
  //               Text(
  //                 'Location:',
  //                 style: TextStyle(
  //                   fontSize: 14,
  //                   color: Colors.grey[600],
  //                 ),
  //               ),
  //               Text(
  //                 widget.videoData['location'] ?? 'Not specified',
  //                 style: const TextStyle(
  //                   fontSize: 16,
  //                 ),
  //               ),
  //               const SizedBox(height: 12),
  //               Text(
  //                 'Posted Date:',
  //                 style: TextStyle(
  //                   fontSize: 14,
  //                   color: Colors.grey[600],
  //                 ),
  //               ),
  //               Text(
  //                 widget.videoData['postedDate'] ?? 'Not specified',
  //                 style: const TextStyle(
  //                   fontSize: 16,
  //                 ),
  //               ),
  //               const SizedBox(height: 12),
  //               Text(
  //                 'Posted Time:',
  //                 style: TextStyle(
  //                   fontSize: 14,
  //                   color: Colors.grey[600],
  //                 ),
  //               ),
  //               Text(
  //                 widget.videoData['postedTime'] ?? 'Not specified',
  //                 style: const TextStyle(
  //                   fontSize: 16,
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }
}
