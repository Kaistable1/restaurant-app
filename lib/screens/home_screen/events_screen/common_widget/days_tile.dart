import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kaistable_website/constants/app_colors.dart';

class BookmarksController extends GetxController {
  var bookmarkedItems =
      <String, bool>{}.obs; // Stores bookmarked state for each event

  void toggleBookmark(String eventTitle) {
    if (bookmarkedItems.containsKey(eventTitle)) {
      bookmarkedItems[eventTitle] = !bookmarkedItems[eventTitle]!;
    } else {
      bookmarkedItems[eventTitle] = true;
    }
  }

  bool isBookmarked(String eventTitle) {
    return bookmarkedItems[eventTitle] ?? false;
  }
}
// Import the controller

class DaysTile extends StatelessWidget {
  final String? image;
  final String? title;
  final String? location;
  final String? type;
  final VoidCallback onTap;
  final BookmarksController bookmarkController = Get.put(BookmarksController());

  DaysTile(
      {super.key,
      this.image,
      this.title,
      this.location,
      required this.onTap,
      this.type});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: Get.height * 0.13,
        width: Get.width,
        color: Colors.transparent,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  image ?? 'https://picsum.photos/150',
                  height: 75,
                  width: 85,
                  fit: BoxFit.fill,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title ?? '',
                  style: TextStyle(
                    color: AppColors.headingTextColor,
                    fontFamily: 'Nunito-Bold',
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(2),
                      child: Image.network(
                        image ?? 'https://picsum.photos/150',
                        width: 16,
                        height: 16,
                        fit: BoxFit.fill,
                      ),
                    ),
                    const SizedBox(width: 6),
                    SizedBox(
                      width: Get.width * 0.4,
                      child: Text(
                        location ?? 'Abc location',
                        style: const TextStyle(
                          color: Color(0xFF4F5A57),
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Nunito-Regular',
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 4,
                  children: [
                    _buildCategoryChip(type ?? ''),
                  ],
                ),
              ],
            ),
            const Spacer(),
            // Padding(
            //   padding: const EdgeInsets.symmetric(vertical: 8.0),
            //   child: Obx(() {
            //     bool isBookmarked =
            //         bookmarkController.isBookmarked(title ?? '');
            //     return GestureDetector(
            //       onTap: () => bookmarkController.toggleBookmark(title ?? ''),
            //       child: Image.asset(
            //         isBookmarked
            //             ? 'assets/images/fill_bookmark.png' // Filled Bookmark
            //             : 'assets/images/empty_bookmark.png', // Unfilled Bookmark
            //         height: 20,
            //         width: 20,
            //       ),
            //     );
            //   }),
            // ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryChip(String category) {
    return Container(
      height: 19,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Center(
        child: Text(
          category,
          style: TextStyle(
            color: AppColors.headingTextColor,
            fontFamily: 'Nunito-Bold',
            fontWeight: FontWeight.w400,
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}
