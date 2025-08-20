import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:kaistable_website/constants/app_colors.dart';
import 'package:kaistable_website/screens/home_screen/home_controller/filter_selection_controller.dart';

import '../../widgets/custom_button.dart';
import '../../widgets/filter_widget.dart';
import 'controller/search_controller.dart';


class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final FilterController controller = Get.put(FilterController());
    final FilterSelectionController filterSelectionController = Get.put(FilterSelectionController());
    final Set<Marker> markers = {
      Marker(
        markerId: MarkerId('default'),
        position: LatLng(34.0522, -118.2437), // Default to Los Angeles
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      ),
    }.obs;

    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: LatLng(34.0522, -118.2437),
              zoom: 10.0,
            ),
            markers: markers,
            onMapCreated: (GoogleMapController controller) {},
          ),
          Positioned(
            top: 10,
            left: 10,
            right: 10,
            child: Container(
              padding: EdgeInsets.all(8),
              color: Colors.white,
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      onTap: () {
                        showFilterBottomSheet();
                      },
                      decoration: InputDecoration(
                        hintText: 'Search for restaurants, events, live music...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        prefixIcon: Icon(Icons.search),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.filter_list),
                    onPressed: () {
                      showFilterBottomSheet();
                    },
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

void showFilterBottomSheet() {
  final FilterController controller = Get.put(FilterController());
  final FilterSelectionController filterSelectionController = Get.put(FilterSelectionController());

  Get.bottomSheet(
    Container(
      height: Get.height * 0.8,
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () => Get.back(),
                  child: const Text("Cancel", style: TextStyle(color: Colors.red, fontSize: 16)),
                ),
                GestureDetector(
                  onTap: controller.clearAll,
                  child: const Text("Clear all", style: TextStyle(color: Colors.red, fontSize: 16)),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              'Filter',
              style: TextStyle(
                fontSize: 16,
                color: AppColors.headingTextColor,
                fontWeight: FontWeight.w700,
                fontFamily: 'Nunito-Sans',
              ),
            ),
            ...controller.filterOptions.keys
                .map((category) => buildCheckboxFilter(category, controller))
                .toList(),
            const SizedBox(height: 20),
            Obx(
                  () => CustomButton(
                laBelText: "Apply (${controller.getTotalSelected()})",
                ontapp: () {
                  filterSelectionController.aggregateSelectedFilters();
                  // Update markers or list based on filters (implement your logic here)
                  Get.back();
                },
                height: 48,
                containerColor: AppColors.primaryColor,
                textColor: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
                radius: BorderRadius.circular(8),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),
            Obx(() {
              List<String> filteredItems = [];
              if (filterSelectionController.aggregatedFilters.isNotEmpty) {
                // Example filtering logic (replace with actual data source)
                filteredItems = ['Item 1', 'Item 2', 'Item 3'] // Mock data
                    .where((item) => filterSelectionController.aggregatedFilters
                    .any((filter) => item.toLowerCase().contains(filter.toLowerCase())))
                    .toList();
              }
              return ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: filteredItems.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(filteredItems[index]),
                    onTap: () {
                      // Handle item selection (e.g., navigate to details or update map)
                    },
                  );
                },
              );
            }),
          ],
        ),
      ),
    ),
    isScrollControlled: true,
  );
}