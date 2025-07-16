import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kaistable_website/constants/app_colors.dart';
import 'package:kaistable_website/screens/nav_bar/controller/video_controller.dart';
import 'package:kaistable_website/screens/nav_bar/videos/full_screen_video_player.dart';
import 'package:kaistable_website/screens/nav_bar/videos/trending_video_card.dart';
import 'package:kaistable_website/screens/nav_bar/widgets/homeScreenWidget/home_filter_bottomsheet.dart';

class AllTrendingVideosScreen extends StatefulWidget {
  const AllTrendingVideosScreen({super.key});

  @override
  State<AllTrendingVideosScreen> createState() =>
      _AllTrendingVideosScreenState();
}

class _AllTrendingVideosScreenState extends State<AllTrendingVideosScreen> {
  final videoController = Get.find<VideoController>();
  // ✅ Use the controller from GetX
 late TextEditingController searchController;

  final RxMap<String, bool> expandedSections = <String, bool>{
    'Vibes': true,
    'Atmosphere': false,
    'Cuisine': false,
    'Experience': false,
  }.obs;

  @override
  void initState() {
    super.initState();
      searchController = videoController.searchController;
    searchController.addListener(() {
      videoController.applyAllFiltersAndSearch(
        selectedVibes: videoController.selectedVibes,
        selectedAtmospheres: videoController.selectedAtmosphere,
        selectedCuisine: videoController.selectedCuisine,
        selectedExperience: videoController.selectedExperience,
        searchQuery: searchController.text,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
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
                        decoration: InputDecoration(
                          suffixIcon: Theme(
                            data: Theme.of(context).copyWith(
                              popupMenuTheme: PopupMenuThemeData(
                                color: Colors
                                    .white, // 👈 white background for the popup
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                textStyle: TextStyle(
                                    fontFamily: 'Nunito Sans',
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14),
                              ),
                            ),
                            child: PopupMenuButton<String>(
                              surfaceTintColor: AppColors.bgColor,
                              icon: Image(
                                  image: AssetImage(
                                      "assets/images/filtersButton.png")),
                              offset: Offset(0, 40),
                              itemBuilder: (context) => [
                                PopupMenuItem(
                                  enabled: false,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      /// -------- Vibes Section --------
                                      Obx(() => Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              ListTile(
                                                contentPadding: EdgeInsets.zero,
                                                title: Text('Vibes',
                                                    style: TextStyle(
                                                        fontFamily:
                                                            'Nunito Sans',
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontSize: 14)),
                                                trailing: Icon(
                                                  expandedSections['Vibes']!
                                                      ? Icons.keyboard_arrow_up
                                                      : Icons
                                                          .keyboard_arrow_down,
                                                  size: 20,
                                                ),
                                                onTap: () {
                                                  expandedSections['Vibes'] =
                                                      !expandedSections[
                                                          'Vibes']!;
                                                },
                                              ),
                                              if (expandedSections[
                                                  'Vibes']!) ...[
                                                ...[
                                                  "Brunch Party",
                                                  "Bottomless Brunch",
                                                  "Day Party",
                                                  "Pool Party",
                                                  "Happy Hours",
                                                  "Open Bar",
                                                  "Rooftop Vibes"
                                                ].map((vibe) {
                                                  return CheckboxListTile(
                                                    activeColor: AppColors
                                                        .primaryColor, // ✅ Tick color (when selected)
                                                    checkColor:
                                                        AppColors.bgColor,
                                                    title: Text(vibe,
                                                        style: TextStyle(
                                                            fontSize: 12)),
                                                    value: videoController
                                                        .selectedVibes
                                                        .contains(vibe),
                                                    onChanged: (_) =>
                                                        videoController
                                                            .toggleVibe(vibe),
                                                    dense: true,
                                                    controlAffinity:
                                                        ListTileControlAffinity
                                                            .leading,
                                                  );
                                                }).toList(),
                                              ],
                                            ],
                                          )),

                                      Divider(),

                                      /// -------- Atmosphere Section --------
                                      Obx(() => Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              ListTile(
                                                contentPadding: EdgeInsets.zero,
                                                title: Text(
                                                  'Atmosphere',
                                                  style: TextStyle(
                                                      fontFamily: 'Nunito Sans',
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontSize: 14),
                                                ),
                                                trailing: Icon(
                                                  expandedSections[
                                                          'Atmosphere']!
                                                      ? Icons.keyboard_arrow_up
                                                      : Icons
                                                          .keyboard_arrow_down,
                                                  size: 20,
                                                ),
                                                onTap: () {
                                                  expandedSections[
                                                          'Atmosphere'] =
                                                      !expandedSections[
                                                          'Atmosphere']!;
                                                },
                                              ),
                                              if (expandedSections[
                                                  'Atmosphere']!) ...[
                                                ...[
                                                  "Casual Dining",
                                                  "Fine Dining",
                                                  "Fast Food",
                                                  "Date Night",
                                                  "Candlelit",
                                                  "Outdoor",
                                                ].map((item) {
                                                  return CheckboxListTile(
                                                    activeColor: AppColors
                                                        .primaryColor, // ✅ Tick color (when selected)
                                                    checkColor:
                                                        AppColors.bgColor,
                                                    title: Text(
                                                      item,
                                                      style: TextStyle(
                                                          fontFamily:
                                                              'Nunito Sans',
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontSize: 14),
                                                    ),
                                                    value: videoController
                                                        .selectedAtmosphere
                                                        .contains(item),
                                                    onChanged: (_) =>
                                                        videoController
                                                            .toggleAtmosphere(
                                                                item),
                                                    dense: true,
                                                    controlAffinity:
                                                        ListTileControlAffinity
                                                            .leading,
                                                  );
                                                }).toList(),
                                              ],
                                            ],
                                          )),
                                      Divider(),

                                      /// -------- Cuisine Section --------
                                      Obx(() => Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              ListTile(
                                                contentPadding: EdgeInsets.zero,
                                                title: Text(
                                                  'Cuisine',
                                                  style: TextStyle(
                                                      fontFamily: 'Nunito Sans',
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontSize: 14),
                                                ),
                                                trailing: Icon(
                                                  expandedSections['Cuisine']!
                                                      ? Icons.keyboard_arrow_up
                                                      : Icons
                                                          .keyboard_arrow_down,
                                                  size: 20,
                                                ),
                                                onTap: () {
                                                  expandedSections['Cuisine'] =
                                                      !expandedSections[
                                                          'Cuisine']!;
                                                },
                                              ),
                                              if (expandedSections[
                                                  'Cuisine']!) ...[
                                                ...[
                                                  "American",
                                                  "Mexican",
                                                  "Italian",
                                                  "French",
                                                  "Chinese",
                                                  "Japanese",
                                                  "Thai",
                                                  "Indian",
                                                  "Korean",
                                                  "Vietnamese",
                                                  "Mediterranean",
                                                  "Caribbean",
                                                  "African",
                                                  "Middle Eastern",
                                                  "Spanish",
                                                  "Filipino",
                                                  "Brazilian",
                                                  "Peruvian",
                                                  "Russian",
                                                  "German",
                                                ].map((item) {
                                                  return CheckboxListTile(
                                                    activeColor: AppColors
                                                        .primaryColor, // ✅ Tick color (when selected)
                                                    checkColor:
                                                        AppColors.bgColor,
                                                    title: Text(item,
                                                        style: TextStyle(
                                                            fontSize: 12)),
                                                    value: videoController
                                                        .selectedCuisine
                                                        .contains(item),
                                                    onChanged: (_) =>
                                                        videoController
                                                            .toggleCuisine(
                                                                item),
                                                    dense: true,
                                                    controlAffinity:
                                                        ListTileControlAffinity
                                                            .leading,
                                                  );
                                                }).toList(),
                                              ],
                                            ],
                                          )),
                                      Divider(),

                                      /// -------- Experience Section --------
                                      Obx(() => Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              ListTile(
                                                contentPadding: EdgeInsets.zero,
                                                title: Text(
                                                  'Experience',
                                                  style: TextStyle(
                                                      fontFamily: 'Nunito Sans',
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontSize: 14),
                                                ),
                                                trailing: Icon(
                                                  expandedSections[
                                                          'Experience']!
                                                      ? Icons.keyboard_arrow_up
                                                      : Icons
                                                          .keyboard_arrow_down,
                                                  size: 20,
                                                ),
                                                onTap: () {
                                                  expandedSections[
                                                          'Experience'] =
                                                      !expandedSections[
                                                          'Experience']!;
                                                },
                                              ),
                                              if (expandedSections[
                                                  'Experience']!) ...[
                                                ...[
                                                  "Live Music",
                                                  "Dj Night",
                                                  "Silent Party",
                                                  "Karaoke",
                                                  "Trivia Nights",
                                                  "Sports screenings",
                                                  "Hookah",
                                                  "Sip & Paint",
                                                  "Ladies Night",
                                                  "RnB Night"
                                                ].map((item) {
                                                  return CheckboxListTile(
                                                    activeColor: AppColors
                                                        .primaryColor, // ✅ Tick color (when selected)
                                                    checkColor:
                                                        AppColors.bgColor,
                                                    title: Text(item,
                                                        style: TextStyle(
                                                            fontSize: 12)),
                                                    value: videoController
                                                        .selectedExperience
                                                        .contains(item),
                                                    onChanged: (_) =>
                                                        videoController
                                                            .toggleExperience(
                                                                item),
                                                    dense: true,
                                                    controlAffinity:
                                                        ListTileControlAffinity
                                                            .leading,
                                                  );
                                                }).toList(),
                                              ],
                                            ],
                                          )),
                                      Divider(),

                                      /// -------- Buttons --------
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 12.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            // Clear Button
                                            TextButton(
                                              style: TextButton.styleFrom(
                                                foregroundColor:
                                                    AppColors.primaryColor,
                                                textStyle: TextStyle(
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                              onPressed: () {
                                                videoController.clearFilters();
                                                videoController
                                                    .applyAllFiltersAndSearch(
                                                  selectedVibes: [],
                                                  selectedAtmospheres: [],
                                                  selectedCuisine: [],
                                                  selectedExperience: [],
                                                );
                                                Navigator.pop(context);
                                              },
                                              child: Text(
                                                "Clear",
                                                style: TextStyle(
                                                    color: Colors.red),
                                              ),
                                            ),

                                            // Apply Button
                                            ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    AppColors.primaryColor,
                                                foregroundColor:
                                                    AppColors.bgColor,
                                                elevation: 2,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                ),
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 24,
                                                        vertical: 12),
                                                textStyle: const TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              onPressed: () {
                                                videoController
                                                    .applyAllFiltersAndSearch(
                                                  selectedVibes: videoController
                                                      .selectedVibes,
                                                  selectedAtmospheres:
                                                      videoController
                                                          .selectedAtmosphere,
                                                  selectedCuisine:
                                                      videoController
                                                          .selectedCuisine,
                                                  selectedExperience:
                                                      videoController
                                                          .selectedExperience,
                                                  searchQuery:
                                                      searchController.text,
                                                );
                                                Navigator.pop(context);
                                              },
                                              child: Text("Apply"),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                          border: InputBorder.none,
                          hintText: "Search Videos...",
                          hintStyle: TextStyle(
                            color: AppColors.tableHeadingColor,
                            fontSize: 14,
                            fontFamily: 'NunitoSans-Regular',
                          ),
                        ),
                   onChanged: (_) {
  videoController.applyAllFiltersAndSearch(
    selectedVibes: videoController.selectedVibes,
    selectedAtmospheres: videoController.selectedAtmosphere,
    selectedCuisine: videoController.selectedCuisine,
    selectedExperience: videoController.selectedExperience,
    searchQuery: searchController.text,
  );
},


                        // TODO: implement search filter logic if needed

                        ),
                  ),
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
