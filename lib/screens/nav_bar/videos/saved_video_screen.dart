import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kaistable_website/constants/app_colors.dart';
import 'package:kaistable_website/screens/nav_bar/controller/video_controller.dart';
import 'package:kaistable_website/screens/nav_bar/videos/full_screen_video_player.dart';
import 'package:kaistable_website/screens/nav_bar/videos/trending_video_card.dart';
import 'package:kaistable_website/screens/nav_bar/widgets/homeScreenWidget/home_filter_bottomsheet.dart';

class SavedVideosScreen extends StatelessWidget {
  final videoController = Get.find<VideoController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: AppBar(
        title: Text(
          "Saved Videos",
          style: TextStyle(
            color: AppColors.bottomSheetColor,
            fontFamily: 'NunitoSans-Bold',
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: AppColors.tableHeadingColor),
        elevation: 0,
      ),
      body: Obx(() {
        final videos = videoController.savedVideos;

        if (videos.isEmpty) {
          return const Center(child: Text("No saved videos found"));
        }

        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: videos.length,
          separatorBuilder: (_, __) => const SizedBox(height: 16),
          itemBuilder: (context, index) {
            final video = videos[index];
            return GestureDetector(
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
                isplay: true,
                showBookmark: true,
                video: video,
                onFilterTap: () {
                  final allFiltersMap = videoController.getAllFilters(video);
                  final allFiltersList =
                      allFiltersMap.values.expand((e) => e).toList();
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    shape: const RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(20)),
                    ),
                    builder: (_) =>
                        HomeFilterBottomsheet(filters: allFiltersList),
                  );
                },
              ),
            );
          },
        );
      }),
    );
  }
}
