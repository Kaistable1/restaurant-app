import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';
import 'dart:io';

import '../controllers/streams_controller.dart';
import '../model/streams_model.dart';

class VideosListView extends StatelessWidget {
  const VideosListView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(VideoController());

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Posts',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true, // ✅ This centers the title on both Android and iOS
        leading: const BackButton(),
      ),

      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Obx(() {
                if (controller.videos.isEmpty) {
                  return const Center(child: Text('No videos available'));
                }

                return ListView.builder(
                  itemCount: controller.videos.length,
                  itemBuilder: (context, index) {
                    final video = controller.videos[index];
                    bool isPlaying = controller.playingIndex.value == index;

                    // Trigger thumbnail generation
                    if (controller.thumbnailPaths[index] == null &&
                        video.url != null &&
                        video.url!.isNotEmpty) {
                      controller.generateThumbnail(index, video.url!);
                    }

                    return Container(
                      margin: const EdgeInsets.only(bottom: 20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: Colors.grey[200],
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          AspectRatio(
                            aspectRatio: 110 / 120,
                            child: isPlaying &&
                                controller.playerController != null &&
                                controller.playerController!.value.isInitialized
                                ? VideoPlayer(controller.playerController!)
                                : Obx(() {
                              return controller.thumbnailPaths[index] != null
                                  ? Image.file(
                                File(controller.thumbnailPaths[index]!),
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) => Image.network(
                                  'https://via.placeholder.com/640x360',
                                  fit: BoxFit.cover,
                                  loadingBuilder: (context, child, loadingProgress) {
                                    if (loadingProgress == null) return child;
                                    return const Center(child: CircularProgressIndicator());
                                  },
                                  errorBuilder: (context, error, stackTrace) => Container(
                                    color: Colors.grey[300],
                                    child: const Icon(Icons.broken_image, size: 50, color: Colors.grey),
                                  ),
                                ),
                              )
                                  : Image.network(
                                'https://via.placeholder.com/640x360',
                                fit: BoxFit.cover,
                                loadingBuilder: (context, child, loadingProgress) {
                                  if (loadingProgress == null) return child;
                                  return const Center(child: CircularProgressIndicator());
                                },
                                errorBuilder: (context, error, stackTrace) => Container(
                                  color: Colors.grey[300],
                                  child: const Icon(Icons.broken_image, size: 50, color: Colors.grey),
                                ),
                              );
                            }),
                          ),
                          Positioned.fill(
                            child: Align(
                              alignment: Alignment.center,
                              child: IconButton(
                                iconSize: 60,
                                color: Colors.white,
                                icon: Icon(
                                  isPlaying ? Icons.pause_circle_filled : Icons.play_circle_fill,
                                ),
                                onPressed: () => controller.playVideo(index),
                              ),
                            ),
                          ),
                          if (isPlaying &&
                              controller.playerController != null &&
                              !controller.playerController!.value.isInitialized)
                            const Positioned.fill(
                              child: Center(child: CircularProgressIndicator()),
                            ),
                          // Bottom Overlay with name & address
                          Positioned(
                            bottom: 0,
                            left: 0,
                            right: 0,
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.teal.withOpacity(0.85),
                                borderRadius: const BorderRadius.only(
                                  bottomLeft: Radius.circular(16),
                                  bottomRight: Radius.circular(16),
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        video.restaurantName ?? 'Unknown Restaurant',
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      Image.asset(
                                        'assets/images/Group (5).png',
                                        width: 20,
                                        height: 20,
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    "${video.streetNo ?? ''} ${video.city ?? ''} ${video.zipCode ?? ''}",
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.white,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}