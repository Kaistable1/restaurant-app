import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../constants/app_colors.dart';
import '../../constants/text_styles.dart';
import '../../controllers/banner_controller.dart';
import '../../controllers/drawer_controller.dart';
import '../../widgets/button.dart';
import '../../widgets/custom_textfield.dart';

class BannerManagement extends StatelessWidget {
  final drawerController = Get.put(DrawerControllerX());
  final controller = Get.put(BannerController());
  final ScrollController _scrollController = ScrollController();

  BannerManagement({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    bool mobileView = screenWidth < 1000;

    // Responsive padding logic
    double paddingValue = mobileView ? 16 : 24;
    double tableTextSize = mobileView ? 9 : 14;
    double titleTextSize = mobileView ? 24 : 32;
    double buttonTextSize = mobileView ? 11 : 16;
    double tableHeaderTextSize = mobileView ? 12 : 20;
    double imageSize = mobileView ? 30 : 50;
    double popUpContainerSize = mobileView ? 20 : 36;
    double popUpSize = mobileView ? 12 : 18;
    return Padding(
      padding: EdgeInsets.only(
        right: paddingValue,
        top: paddingValue,
        left: paddingValue,
        bottom: paddingValue,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Banner',
                  style: headingText.copyWith(fontSize: titleTextSize)),
              !mobileView
                  ? SizedBox(
                width: screenWidth * 0.34,
                child: CustomTextField(
                  prefixIcon: Icon(Icons.search, color: primaryColor),
                  hintText: 'Search ',
                  hintTextColor: primaryColor,
                  borderColor: primaryColor,
                  controller: controller.searchController,
                  onChanged: (value) {
                    controller.currentSearchQuery.value = value ?? '';
                    controller.filterBanners(value ?? '');
                    return null;
                  },
                ),
              )
                  : SizedBox(),
              CustomButton(
                laBelText: 'Add New Banner',
                isPrefixIcon: true,
                iconWidget: Icon(Icons.add_circle_outline_sharp, color: white),
                fontSize: buttonTextSize,
                width: mobileView ? 150 : 200,
                shadow: [],
                containerColor: primaryColor,
                ontapp: () {
                  drawerController.addBanner.value = true;
                },
              ),
            ],
          ),
          SizedBox(height: 20),
          mobileView
              ? CustomTextField(
            prefixIcon: Icon(Icons.search, color: primaryColor),
            hintText: 'Search ',
            hintTextColor: primaryColor,
            borderColor: primaryColor,
            controller: controller.searchController,
            onChanged: (value) {
              controller.currentSearchQuery.value = value ?? '';
              controller.filterBanners(value ?? '');
              return null;
            },
          )
              : SizedBox(),
          SizedBox(height: 10),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: dimWhite.withOpacity(0.4),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Column(
                children: [
                  // Header
                  Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 16, horizontal: 12),
                    color: primaryColor,
                    child: Row(
                      children: [
                        // Photo column (fixed width)
                        SizedBox(
                          width: 100, // Match the width used in the list items
                          child: Center(
                            child: Text(
                              "Thumbnail",
                              style: simpleText.copyWith(
                                fontSize: tableHeaderTextSize,
                                fontWeight: FontWeight.w700,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                        // Event name column
                        Expanded(
                          flex: 1,
                          child: Center(
                            child: Text(
                              "Titles",
                              textAlign: TextAlign.center,
                              style: simpleText.copyWith(
                                fontSize: tableHeaderTextSize,
                                fontWeight: FontWeight.w700,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                        // Location column
                        Expanded(
                          flex: 1,
                          child: Center(
                            child: Text(
                              "Start Date",
                              textAlign: TextAlign.center,
                              style: simpleText.copyWith(
                                fontSize: tableHeaderTextSize,
                                fontWeight: FontWeight.w700,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                        // Event type column
                        Expanded(
                          flex: 1, // Adjusted to match the list item flex
                          child: Center(
                            child: Text(
                              "End Date",
                              textAlign: TextAlign.center,
                              style: simpleText.copyWith(
                                fontSize: tableHeaderTextSize,
                                fontWeight: FontWeight.w700,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Center(
                            child: Text(
                              "Status",
                              textAlign: TextAlign.center,
                              style: simpleText.copyWith(
                                fontSize: tableHeaderTextSize,
                                fontWeight: FontWeight.w700,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                        // Action column (for the PopupMenuButton)
                        SizedBox(
                          width: 50, // Match the width used in the list items
                          child: Center(
                            child: Text(
                              "",
                              style: simpleText.copyWith(
                                fontSize: tableHeaderTextSize,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Obx(
                          () {
                        if (controller.isLoading.value &&
                            controller.filteredBannerList.isEmpty) {
                          return Center(
                              child: CircularProgressIndicator(
                                  color: primaryColor));
                        }
                        if (controller.filteredBannerList.isEmpty &&
                            !controller.hasMoreData.value) {
                          return Center(
                            child: Text(
                              controller.currentSearchQuery.value.isNotEmpty
                                  ? 'Banner list not found'
                                  : 'No banners list available',
                              style: simpleText.copyWith(
                                fontSize: tableTextSize,
                                color: secondaryColor,
                              ),
                            ),
                          );
                        }
                        return ListView.builder(
                          padding: EdgeInsets.zero,
                          controller: _scrollController,
                          itemCount: controller.filteredBannerList.length,
                          itemBuilder: (context, index) {
                            if (index == controller.filteredBannerList.length) {
                              if (controller.hasMoreData.value) {
                                return Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Center(
                                    child: controller.isLoading.value
                                        ? CircularProgressIndicator(
                                      color: primaryColor,
                                    )
                                        : Text(
                                      'Loading more banners...',
                                      style: simpleText.copyWith(
                                        fontSize: tableTextSize,
                                        color: primaryColor,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                );
                              } else {
                                return Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Center(
                                    child: Text(
                                      'No more banners to load',
                                      style: simpleText.copyWith(
                                        fontSize: tableTextSize,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ),
                                );
                              }
                            }
                            final user = controller.filteredBannerList[index];
                            final originalIndex =
                            controller.bannerList.indexOf(user);
                            return Container(
                              padding: const EdgeInsets.symmetric(
                                vertical: 14,
                                horizontal: 12,
                              ),
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    color: primaryColor,
                                    width: 0.3,
                                  ),
                                ),
                              ),
                              child: Row(
                                children: [
                                  // Photo column (fixed width)
                                  SizedBox(
                                    width: 100, // Match the header width
                                    child: Center(
                                      child: Container(
                                        height: imageSize,
                                        width: imageSize,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                          BorderRadius.circular(8),
                                          image: DecorationImage(
                                            image:
                                            NetworkImage(user.bannerImage),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  // Event name column
                                  Expanded(
                                    flex: 1,
                                    child: Center(
                                      child: Text(
                                        user.title,
                                        textAlign: TextAlign.center,
                                        style: simpleText.copyWith(
                                          fontSize: tableTextSize,
                                        ),
                                      ),
                                    ),
                                  ),
                                  // Location column
                                  Expanded(
                                    flex: 1,
                                    child: Center(
                                      child: Text(
                                        user.startDate,
                                        textAlign: TextAlign.center,
                                        style: simpleText.copyWith(
                                          fontSize: tableTextSize,
                                        ),
                                      ),
                                    ),
                                  ),
                                  // Event type column
                                  Expanded(
                                    flex: 1,
                                    // Adjusted to match the header flex
                                    child: Center(
                                      child: Text(
                                        user.endDate,
                                        textAlign: TextAlign.center,
                                        style: simpleText.copyWith(
                                          fontSize: tableTextSize,
                                        ),
                                      ),
                                    ),
                                  ),
                                  // Status column
                                  Expanded(
                                    flex: 1,
                                    child: Center(
                                      child: Text(
                                        user.status,
                                        textAlign: TextAlign.center,
                                        style: simpleText.copyWith(
                                          fontSize: tableTextSize,
                                          color: user.status == "Expired"
                                              ? Colors.red
                                              : primaryColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                  // Action column (PopupMenuButton)
                                  SizedBox(
                                    width: 50, // Match the header width
                                    child: Center(
                                      child: Container(
                                        height: popUpContainerSize,
                                        width: popUpContainerSize,
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 4),
                                        decoration: BoxDecoration(
                                          color: primaryColor,
                                          borderRadius: BorderRadius.circular(
                                            mobileView ? 5 : 10,
                                          ),
                                        ),
                                        child: Center(
                                          child: PopupMenuButton<String>(
                                            padding: EdgeInsets.zero,
                                            icon: Icon(
                                              Icons.more_vert,
                                              color: Colors.white,
                                              size: popUpSize,
                                            ),
                                            onSelected: (value) {
                                              if (value == 'Delete') {
                                                controller.deleteBanner(
                                                    originalIndex);
                                              }
                                              if (value == 'View') {
                                                controller.loadBannerForView(
                                                    originalIndex);
                                                drawerController
                                                    .viewBannerDetails
                                                    .value = true;
                                              }
                                              if (value == 'Edit') {
                                                controller.loadBannerForEdit(
                                                    originalIndex);
                                                controller.isFromEdit.value =
                                                true;
                                                drawerController
                                                    .addBanner.value = true;
                                              }
                                            },
                                            itemBuilder: (context) => [
                                              const PopupMenuItem(
                                                value: 'View',
                                                child: Text('View'),
                                              ),
                                              const PopupMenuItem(
                                                value: 'Edit',
                                                child: Text('Edit'),
                                              ),
                                              const PopupMenuItem(
                                                value: 'Delete',
                                                child: Text('Delete'),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
