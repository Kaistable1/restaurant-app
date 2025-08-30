import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';
import 'dart:io';

import '../../screens/nav_bar/full_screen_video/full_screen_video_screen.dart';
import '../controllers/streams_controller.dart';
import '../model/streams_model.dart';


class VideosListView extends StatelessWidget {
  VideosListView({super.key});


  final RxMap<String, bool> showFilterDropdowns = <String, bool>{}.obs;
  final RxMap<String, String> selectedFilters = <String, String>{}.obs;

  var filterOptions = <String, List<String>>{
    "Vibes": [
      "Lively", "High-Energy", "LaidBack", "Intimate",
      "Loud", "Lowkey", "UpBeat"
    ],
    "Experience": [
      "Live Music", "Dj Night", "Ladies Night",
      "Hookah", "Karaoke",
    ],
    "Atmosphere": [
      "Fast Food", "Casual Dining", "Date Night",
    ],
  }.obs;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(VideoController());

    // Initialize showFilterDropdowns
    filterOptions.forEach((key, _) {
      showFilterDropdowns[key] = false;
    });

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        title: const Text(
          'Streams',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        leading: const BackButton(),
      ),
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Material(
                  elevation: 0,
                  borderRadius: BorderRadius.circular(30),
                  child: Container(
                    height: 48,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.04),
                          blurRadius: 16,
                          spreadRadius: 0,
                          offset: Offset(0, 4),
                        )
                      ],
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.search, size: 24),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextField(
                            controller: controller.searchController,
                            decoration: InputDecoration(
                              hintText: 'Search for restaurants',
                              border: InputBorder.none,
                              hintStyle: TextStyle(color: Colors.grey[600]),
                            ),
                            onSubmitted: (value) {
                              Get.find<VideoController>().applySearchAndFilters(controller.searchController.text, selectedFilters);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 4),
              const SizedBox(height: 36),
              const SizedBox(height: 16),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Obx(() {
                    if (controller.isLoading.value) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (controller.filteredVideos.isEmpty) {
                      return const Center(child: Text('No videos available'));
                    }
                    return ListView.builder(
                      itemCount: controller.filteredVideos.length,
                      itemBuilder: (context, index) {
                        final video = controller.filteredVideos[index];
                        if (controller.thumbnailPaths[video.url] == null &&
                            video.url != null &&
                            video.url!.isNotEmpty) {
                          controller.generateThumbnail(video.url!);
                        }
                        return GestureDetector(
                          onTap: () {
                            Get.to(()=>FullVideoScreen(video: video));

                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(
                            //     builder: (context) => FullVideoScreen(video: video),
                            //   ),
                            // );
                          },
                          child: Container(
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
                                  aspectRatio: 356 / 520,
                                  child: Obx(() {
                                    return controller.thumbnailPaths[video.url] != null
                                        ? Image.file(
                                      File(controller.thumbnailPaths[video.url]!),
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
                                    child: Icon(
                                      Icons.play_circle_fill,
                                      size: 60,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                // Positioned(
                                //   bottom: 0,
                                //   left: 0,
                                //   right: 0,
                                //   child: Container(
                                //     padding: const EdgeInsets.all(10),
                                //     decoration: BoxDecoration(
                                //       color: Colors.teal.withOpacity(0.85),
                                //       borderRadius: const BorderRadius.only(
                                //         bottomLeft: Radius.circular(16),
                                //         bottomRight: Radius.circular(16),
                                //       ),
                                //     ),
                                //     child: Column(
                                //       crossAxisAlignment: CrossAxisAlignment.start,
                                //       children: [
                                //         Row(
                                //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                //           children: [
                                //             Text(
                                //               video.restaurantName ?? 'Unknown Restaurant',
                                //               style: const TextStyle(
                                //                 fontSize: 16,
                                //                 fontWeight: FontWeight.bold,
                                //                 color: Colors.white,
                                //               ),
                                //               maxLines: 1,
                                //               overflow: TextOverflow.ellipsis,
                                //             ),
                                //             Image.asset(
                                //               'assets/images/Group (5).png',
                                //               width: 20,
                                //               height: 20,
                                //             ),
                                //           ],
                                //         ),
                                //         const SizedBox(height: 4),
                                //         Text(
                                //           "${video.streetNo ?? ''} ${video.city ?? ''} ${video.zipCode ?? ''}",
                                //           style: const TextStyle(
                                //             fontSize: 14,
                                //             color: Colors.white,
                                //           ),
                                //           maxLines: 1,
                                //           overflow: TextOverflow.ellipsis,
                                //         ),
                                //       ],
                                //     ),
                                //   ),
                                // ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  }),
                ),
              ),
            ],
          ),
          Positioned(
            top: 48 + 4 + 16,
            left: 0,
            right: 0,
            child: Obx(() => SizedBox(
              height: showFilterDropdowns.values.contains(true) ? 250 : 36,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: filterOptions.keys.map((category) {
                  return Stack(
                    clipBehavior: Clip.none,
                    children: [
                      GestureDetector(
                        onTap: () {
                          showFilterDropdowns[category] = !showFilterDropdowns[category]!;
                          showFilterDropdowns.refresh();
                        },
                        child: Container(
                          height: 36,
                          margin: const EdgeInsets.only(right: 8),
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(30),
                            color: Colors.white,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Obx(() => Text(
                                selectedFilters[category] != null
                                    ? '$category: ${selectedFilters[category]}'
                                    : category,
                                style: const TextStyle(color: Colors.black, fontSize: 18),
                              )),
                              const SizedBox(width: 4),
                              const Icon(Icons.arrow_drop_down, size: 20, color: Colors.black),
                            ],
                          ),
                        ),
                      ),
                      Obx(() {
                        if (showFilterDropdowns[category] ?? false) {
                          final optionCount = filterOptions[category]?.length ?? 0;
                          final dropdownHeight = (optionCount + 1) * 40.0;
                          return Positioned(
                            top: 50,
                            left: 0,
                            child: Material(
                              elevation: 5,
                              borderRadius: BorderRadius.circular(12),
                              child: Container(
                                width: 150,
                                height: dropdownHeight < 190 ? dropdownHeight : 190,
                                padding: const EdgeInsets.fromLTRB(8, 8, 8, 16),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: SingleChildScrollView(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      // Add "Clear" option
                                      InkWell(
                                        onTap: () {
                                          selectedFilters.remove(category);
                                          selectedFilters.refresh();
                                          showFilterDropdowns[category] = false;
                                          showFilterDropdowns.refresh();
                                          controller.applySearchAndFilters(controller.searchController.text, selectedFilters);
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(vertical: 8),
                                          child: Text(
                                            'Clear',
                                            style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.red,
                                            ),
                                          ),
                                        ),
                                      ),
                                      ...?filterOptions[category]?.map((option) => InkWell(
                                        onTap: () {
                                          selectedFilters[category] = option;
                                          selectedFilters.refresh();
                                          showFilterDropdowns[category] = false;
                                          showFilterDropdowns.refresh();
                                          controller.applySearchAndFilters(controller.searchController.text, selectedFilters);
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(vertical: 8),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                option,
                                                style: const TextStyle(fontSize: 16),
                                              ),
                                              if (selectedFilters[category] == option)
                                                const Icon(Icons.check, color: Colors.green, size: 16),
                                            ],
                                          ),
                                        ),
                                      )).toList(),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        }
                        return const SizedBox.shrink();
                      }),
                    ],
                  );
                }).toList(),
              ),
            )),
          ),
        ],
      ),
    );
  }
}

// class VideosListView extends StatelessWidget {
//   VideosListView({super.key});
//
//   final TextEditingController searchController = TextEditingController();
//
//   final RxMap<String, bool> showFilterDropdowns = <String, bool>{}.obs;
//
//   var filterOptions = <String, List<String>>{
//     "Vibes": [
//       "Lively", "High-Energy", "LaidBack", "Intimate",
//       "Loud", "Lowkey", "UpBeat"
//     ],
//     "Experience": [
//       "Live Music", "Dj Night", "Ladies Night",
//       "Hookah", "Karaoke",
//     ],
//     "Atmosphere": [
//       "Fast Food", "Casual Dining", "Date Night",
//     ],
//   }.obs;
//
//   Widget _buildSearchBar() {
//     return Material(
//       elevation: 0,
//       borderRadius: BorderRadius.circular(30),
//       child: Container(
//         height: 48,
//         padding: const EdgeInsets.symmetric(horizontal: 16),
//         alignment: Alignment.center,
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(30),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(0.04),
//               blurRadius: 16,
//               spreadRadius: 0,
//               offset: Offset(0, 4),
//             )
//           ],
//         ),
//         child: Row(
//           children: [
//             const Icon(Icons.search, size: 24),
//             const SizedBox(width: 8),
//             Expanded(
//               child: TextField(
//                 controller: searchController,
//                 decoration: InputDecoration(
//                   hintText: 'Search for restaurants',
//                   border: InputBorder.none,
//                   hintStyle: TextStyle(color: Colors.grey[600]),
//                 ),
//                 onSubmitted: (value) {
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final controller = Get.put(VideoController());
//
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         surfaceTintColor: Colors.white,
//         title: const Text(
//           'Streams',
//           style: TextStyle(
//             fontSize: 20,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         centerTitle: true, // ✅ This centers the title on both Android and iOS
//         leading: const BackButton(),
//       ),
//
//       backgroundColor: Colors.white,
//       body: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: _buildSearchBar(),
//           ),
//           const SizedBox(height: 8),
//           Obx(() => SizedBox(
//               height: showFilterDropdowns.values.contains(true) ? 250 : 36,
//               child: Obx(() {
//                 if (filterOptions.isEmpty) {
//                   return const SizedBox.shrink();
//                 }
//                 return ListView(
//                   scrollDirection: Axis.horizontal,
//                   padding: const EdgeInsets.symmetric(horizontal: 16),
//                   children: filterOptions.keys.map((category) {
//                     return Stack(
//                       clipBehavior: Clip.none,
//                       children: [
//                         GestureDetector(
//                           onTap: () {
//                             showFilterDropdowns[category] = !showFilterDropdowns[category]!;
//                             showFilterDropdowns.forEach((key, value) {
//                               if (key != category) {
//                                 showFilterDropdowns[key] = false;
//                               }
//                             });
//                             showFilterDropdowns.refresh();
//                           },
//                           child: Container(
//                             height: 36,
//                             margin: const EdgeInsets.only(right: 8),
//                             padding: const EdgeInsets.symmetric(horizontal: 16),
//                             decoration: BoxDecoration(
//                               border: Border.all(color: Colors.grey.shade300),
//                               borderRadius: BorderRadius.circular(30),
//                               color: Colors.white,
//                             ),
//                             child: Row(
//                               mainAxisSize: MainAxisSize.min,
//                               children: [
//                                 Obx(() => Text(
//
//                                   // category +
//                                   //     (filterCtrl.selectedFilters[category]?.isNotEmpty ?? false
//                                   //         ? ' (${filterCtrl.selectedFilters[category]?.length ?? 0})'
//                                   //         : ''),
//                                   style: const TextStyle(color: Colors.black, fontSize: 18),
//                                 )),
//                                 const SizedBox(width: 4),
//                                 const Icon(Icons.arrow_drop_down, size: 20, color: Colors.black),
//                               ],
//                             ),
//                           ),
//                         ),
//                         Obx(() {
//                           if (showFilterDropdowns[category] ?? false) {
//                             final optionCount = filterOptions[category]?.length ?? 0;
//                             final dropdownHeight = optionCount * 40.0;
//                             return Positioned(
//                               top: 50,
//                               left: 0,
//                               child: Material(
//                                 elevation: 5,
//                                 borderRadius: BorderRadius.circular(12),
//                                 child: Container(
//                                   width: 150,
//                                   height: dropdownHeight < 190 ? dropdownHeight : 190,
//                                   padding: const EdgeInsets.fromLTRB(8, 8, 8, 16),
//                                   decoration: BoxDecoration(
//                                     color: Colors.white,
//                                     borderRadius: BorderRadius.circular(12),
//                                   ),
//                                   child: SingleChildScrollView(
//                                     child: Column(
//                                       crossAxisAlignment: CrossAxisAlignment.start,
//                                       children: (filterOptions[category] ?? []).map((option) => InkWell(
//                                         onTap: () {
//                                           final selectedList = filterCtrl.selectedFilters[category] ?? <String>[].obs;
//                                           if (selectedList.contains(option)) {
//                                             selectedList.remove(option);
//                                           } else {
//                                             selectedList.add(option);
//                                           }
//                                           filterCtrl.selectedFilters[category] = selectedList;
//                                           filterCtrl.selectedFilters.refresh();
//                                           showFilterDropdowns[category] = false;
//                                           showFilterDropdowns.refresh();
//                                           isLoading.value = true;
//                                           Future.delayed(const Duration(milliseconds: 500), () {
//                                             homeLocationCtrl.applySearchAndFilters();
//                                             isLoading.value = false;
//                                           });
//                                         },
//                                         child: Padding(
//                                           padding: const EdgeInsets.symmetric(vertical: 8),
//                                           child: Row(
//                                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                             children: [
//                                               Text(
//                                                 option,
//                                                 style: const TextStyle(fontSize: 16),
//                                               ),
//                                               if (filterCtrl.selectedFilters[category]?.contains(option) ?? false)
//                                                 const Icon(Icons.check, color: Colors.green, size: 16),
//                                             ],
//                                           ),
//                                         ),
//                                       )).toList(),
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             );
//                           }
//                           return const SizedBox.shrink();
//                         }),
//                       ],
//                     );
//                   }).toList(),
//                 );
//               }),
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 16),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Expanded(
//                   child: Obx(() {
//                     if (controller.videos.isEmpty) {
//                       return const Center(child: Text('No videos available'));
//                     }
//
//                     return ListView.builder(
//                       itemCount: controller.videos.length,
//                       itemBuilder: (context, index) {
//                         final video = controller.videos[index];
//                         // bool isPlaying = controller.playingIndex.value == index;
//
//                         // Trigger thumbnail generation
//                         if (controller.thumbnailPaths[index] == null &&
//                             video.url != null &&
//                             video.url!.isNotEmpty) {
//                           controller.generateThumbnail(index, video.url!);
//                         }
//
//                         return GestureDetector(
//                           onTap: (){
//                             Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                 builder: (context) => FullVideoScreen(video: video),
//                               ),
//                             );
//                           },
//                           child: Container(
//                             margin: const EdgeInsets.only(bottom: 20),
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(16),
//                               color: Colors.grey[200],
//                             ),
//                             clipBehavior: Clip.antiAlias,
//                             child: Stack(
//                               alignment: Alignment.center,
//                               children: [
//                                 AspectRatio(
//                                   aspectRatio: 110 / 120,
//                                   child: Obx(() {
//                                     return controller.thumbnailPaths[index] != null
//                                         ? Image.file(
//                                       File(controller.thumbnailPaths[index]!),
//                                       fit: BoxFit.cover,
//                                       errorBuilder: (context, error, stackTrace) => Image.network(
//                                         'https://via.placeholder.com/640x360',
//                                         fit: BoxFit.cover,
//                                         loadingBuilder: (context, child, loadingProgress) {
//                                           if (loadingProgress == null) return child;
//                                           return const Center(child: CircularProgressIndicator());
//                                         },
//                                         errorBuilder: (context, error, stackTrace) => Container(
//                                           color: Colors.grey[300],
//                                           child: const Icon(Icons.broken_image, size: 50, color: Colors.grey),
//                                         ),
//                                       ),
//                                     )
//                                         : Image.network(
//                                       'https://via.placeholder.com/640x360',
//                                       fit: BoxFit.cover,
//                                       loadingBuilder: (context, child, loadingProgress) {
//                                         if (loadingProgress == null) return child;
//                                         return const Center(child: CircularProgressIndicator());
//                                       },
//                                       errorBuilder: (context, error, stackTrace) => Container(
//                                         color: Colors.grey[300],
//                                         child: const Icon(Icons.broken_image, size: 50, color: Colors.grey),
//                                       ),
//                                     );
//                                   }),
//                                 ),
//                                 Positioned.fill(
//                                   child: Align(
//                                     alignment: Alignment.center,
//                                     child: Icon(
//                                       Icons.play_circle_fill,
//                                       size: 60,
//                                       color: Colors.white,
//                                     ),
//                                   ),
//                                 ),
//                                 // Bottom Overlay with name & address
//                                 Positioned(
//                                   bottom: 0,
//                                   left: 0,
//                                   right: 0,
//                                   child: Container(
//                                     padding: const EdgeInsets.all(10),
//                                     decoration: BoxDecoration(
//                                       color: Colors.teal.withOpacity(0.85),
//                                       borderRadius: const BorderRadius.only(
//                                         bottomLeft: Radius.circular(16),
//                                         bottomRight: Radius.circular(16),
//                                       ),
//                                     ),
//                                     child: Column(
//                                       crossAxisAlignment: CrossAxisAlignment.start,
//                                       children: [
//                                         Row(
//                                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                           children: [
//                                             Text(
//                                               video.restaurantName ?? 'Unknown Restaurant',
//                                               style: const TextStyle(
//                                                 fontSize: 16,
//                                                 fontWeight: FontWeight.bold,
//                                                 color: Colors.white,
//                                               ),
//                                               maxLines: 1,
//                                               overflow: TextOverflow.ellipsis,
//                                             ),
//                                             Image.asset(
//                                               'assets/images/Group (5).png',
//                                               width: 20,
//                                               height: 20,
//                                             ),
//                                           ],
//                                         ),
//                                         const SizedBox(height: 4),
//                                         Text(
//                                           "${video.streetNo ?? ''} ${video.city ?? ''} ${video.zipCode ?? ''}",
//                                           style: const TextStyle(
//                                             fontSize: 14,
//                                             color: Colors.white,
//                                           ),
//                                           maxLines: 1,
//                                           overflow: TextOverflow.ellipsis,
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         );
//                       },
//                     );
//                   }),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }