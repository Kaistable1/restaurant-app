import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kaistable_website/constants/app_colors.dart';
import 'package:kaistable_website/screens/nav_bar/controller/video_controller.dart';
import 'package:kaistable_website/screens/nav_bar/videos/full_screen_video_player.dart';
import 'package:kaistable_website/screens/nav_bar/videos/trending_video_card.dart';
import 'package:kaistable_website/screens/nav_bar/widgets/homeScreenWidget/home_filter_bottomsheet.dart';

class AllTrendingVideosScreen extends StatelessWidget {
  const AllTrendingVideosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final videoController = Get.find<VideoController>();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        titleSpacing: 16,
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.tableHeadingColor),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Videos',
              style: TextStyle(
                color: AppColors.bottomSheetColor,
                fontFamily: 'NunitoSans-Bold',
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
            GestureDetector(
              onTap: () {
                // TODO: Handle saved click (filter saved videos)
              },
              child: Row(
                children: const [
                  Icon(Icons.bookmark,
                      color: AppColors.primaryColor), // ✅ filled icon
                  SizedBox(width: 4),
                  Text(
                    'Saved',
                    style: TextStyle(
                      color: AppColors.bottomSheetColor,
                      fontFamily: 'NunitoSans-Bold',
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // 🔍 Functional Search Bar
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
            child: Container(
              height: 48,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: AppColors.whiteColor,
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: AppColors.blackColor),
              ),
              child: Row(
                children: [
                  const Icon(Icons.search, color: AppColors.blackColor),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      style: const TextStyle(
                        fontSize: 14,
                        fontFamily: 'NunitoSans-Regular',
                        color: AppColors.tableHeadingColor,
                      ),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: "Search Videos...",
                        hintStyle: TextStyle(
                          color: AppColors.tableHeadingColor,
                          fontSize: 14,
                          fontFamily: 'NunitoSans-Regular',
                        ),
                      ),
                      onChanged: (value) {
                        // TODO: implement search filter logic if needed
                      },
                    ),
                  ),
                  Image(
                    image: AssetImage("assets/images/filtersButton.png"),
                    width: 16,
                    height: 18,
                  )
                ],
              ),
            ),
          ),

          SizedBox(
            height: 20,
          ),
          // 📹 Video List
          Expanded(
            child: Obx(() {
              final videos = videoController.videos;

              if (!videoController.hasInitialized.value) {
                return const Center(
                  child:
                      CircularProgressIndicator(color: AppColors.primaryColor),
                );
              }

              if (videos.isEmpty) {
                return const Center(
                  child: Text(
                    'No videos found',
                    style: TextStyle(
                      fontFamily: 'NunitoSans-Regular',
                      fontSize: 16,
                      color: AppColors.bottomSheetColor,
                    ),
                  ),
                );
              }

              return ListView.separated(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                itemCount: videos.length,
                separatorBuilder: (_, __) => const SizedBox(height: 16),
                itemBuilder: (context, index) {
                  final video = videos[index];
                  return Stack(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => FullScreenVideoPlayerScreen(
                                videos: videos,
                                initialIndex: index,
                              ),
                            ),
                          );
                        },
                        child: TrendingVideoCard(
                          video: video,
                          onFilterTap: () {
                            final allFiltersMap =
                                videoController.getAllFilters(video);
                            final allFiltersList =
                                allFiltersMap.values.expand((e) => e).toList();

                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(20)),
                              ),
                              builder: (_) => HomeFilterBottomsheet(
                                  filters: allFiltersList),
                            );
                          },
                        ),
                      ),
                      Positioned(
                        top: 12,
                        right: 12,
                        child: Obx(() {
                          final isSaved =
                              videoController.savedVideoIds.contains(video.id);
                          return GestureDetector(
                            onTap: () =>
                                videoController.toggleSavedStatus(video.id),
                            child: CircleAvatar(
                              backgroundColor: Colors.black.withOpacity(0.5),
                              radius: 18,
                              child: Icon(
                                isSaved
                                    ? Icons.bookmark
                                    : Icons.bookmark_border,
                                color: AppColors.primaryColor,
                                size: 20,
                              ),
                            ),
                          );
                        }),
                      ),
                    ],
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}
