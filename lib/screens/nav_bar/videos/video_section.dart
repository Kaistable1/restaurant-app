import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kaistable_website/constants/app_colors.dart';
import 'package:kaistable_website/screens/nav_bar/controller/video_controller.dart';
import 'package:kaistable_website/screens/nav_bar/videos/all_videos_screen.dart';
import 'package:kaistable_website/screens/nav_bar/videos/trending_video_card.dart';
import 'package:kaistable_website/screens/nav_bar/widgets/homeScreenWidget/home_filter_bottomsheet.dart';

Widget buildTrendingVideosSection() {
  final videoController = Get.find<VideoController>();

  return Obx(() {
    final videos = videoController.videos;

    if (!videoController.hasInitialized.value) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Videos',
              style: TextStyle(
                color: AppColors.bottomSheetColor,
                fontFamily: 'NunitoSans-Bold',
                fontSize: 16,
                fontWeight: FontWeight.w700,
                decoration: TextDecoration.underline,
              ),
            ),
            SizedBox(height: 16),
            Center(
              child: CircularProgressIndicator(color: AppColors.primaryColor),
            ),
          ],
        ),
      );
    }

    if (videos.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Videos',
              style: TextStyle(
                color: AppColors.bottomSheetColor,
                fontFamily: 'NunitoSans-Bold',
                fontSize: 16,
                fontWeight: FontWeight.w700,
                decoration: TextDecoration.underline,
              ),
            ),
            SizedBox(height: 16),
            Center(
              child: Text(
                'No videos found',
                style: TextStyle(
                  color: AppColors.bottomSheetColor,
                  fontFamily: 'NunitoSans-Regular',
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ],
        ),
      );
    }

    final featuredVideo = videos.first;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Videos',
                style: TextStyle(
                  color: AppColors.bottomSheetColor,
                  fontFamily: 'NunitoSans-Bold',
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  decoration: TextDecoration.underline,
                ),
              ),
              GestureDetector(
                onTap: () {
                  Get.to(() => const AllTrendingVideosScreen());
                },
                child: Text(
                  'See more',
                  style: TextStyle(
                    color: AppColors.primaryColor,
                    fontFamily: 'NunitoSans-Regular',
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          TrendingVideoCard(
            video: featuredVideo,
            onFilterTap: () {
              final allFiltersMap =
                  videoController.getAllFilters(featuredVideo);

              // Flatten all values into a single list
              final allFiltersList =
                  allFiltersMap.values.expand((e) => e).toList();

              showModalBottomSheet(
                context: Get.context!,
                isScrollControlled: true,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                builder: (_) => HomeFilterBottomsheet(filters: allFiltersList),
              );
            },
          ),
        ],
      ),
    );
  });
}
