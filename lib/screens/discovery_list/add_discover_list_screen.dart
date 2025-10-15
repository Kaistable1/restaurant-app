// Modified AddDiscoverListScreen.dart

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:savrly/models/resaturant_model.dart';

import '../../constants/app_colors.dart';
import '../../constants/text_styles.dart';
import '../../controllers/drawer_controller.dart';
import '../../widgets/button.dart';
import '../../widgets/custom_textfield.dart';
import '../../widgets/customheader_widget.dart';
import '../../widgets/text_and_field_drop_down.dart';
import 'controller/add_dicover_list_controller.dart';

class AddDiscoverListScreen extends StatelessWidget {
  AddDiscoverListScreen({super.key});

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final drawerController = Get.put(DrawerControllerX());
  final controller = Get.put(AddDiscoverListController());

  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;

    double screenWidth = size.width;
    double screenHeight = size.height;
    bool isLargeScreen = screenWidth > 1600;

    bool isMobile = screenWidth < 600;
    bool isTablet = screenWidth >= 600 && screenWidth <= 900;

    double paddingValue = isMobile ? 16 : (isTablet ? 20 : 24);
    double imageWidth = 216;
    double imageHeight = 162;
    if (screenWidth < 500) {
      imageWidth = 140;
      imageHeight = 100;
    } else if (screenWidth < 900) {
      imageWidth = 180;
      imageHeight = 130;
    }


    if (controller.selectedDiscoverListModel != null) {
      controller.discoverListNameController.text = controller.selectedDiscoverListModel!.name;
      controller.discoverListByController.text = controller.selectedDiscoverListModel!.by;
      controller.discoverListDescController.text = controller.selectedDiscoverListModel!.description;

      controller.imageUrl = controller.selectedDiscoverListModel!.image.obs;
      controller.loadSelectedRestaurants(controller.selectedDiscoverListModel!.restaurantIdsList);
    }

    return Padding(
      padding: EdgeInsets.only(
        right: paddingValue,
        top: paddingValue,
        left: paddingValue,
        bottom: paddingValue,
      ),
      child: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomHeaderWidget(
                  title: 'Add discover list',
                  back: true,
                  onBackTap: () {
                    drawerController.addDiscoveryLists.value = false;
                  },
                ),
                const SizedBox(height: 30),
                Container(
                  width: isTablet
                      ? screenWidth * .9
                      : isMobile
                      ? screenWidth * .9
                      : screenWidth * .6,
                  // height: isLargeScreen ? screenHeight * 2.1 : screenHeight * 3.1,
                  margin: const EdgeInsets.only(left: 2.0),
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: dimWhite,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        spreadRadius: 1,
                        blurRadius: 6,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Image',
                          style: headingText.copyWith(
                              fontSize: isMobile ? 16 : 20),
                        ),
                        const SizedBox(height: 10),
                        Obx(() => SizedBox(
                          height: imageHeight + 20,
                          // Fixed height for scrollable area
                          child: controller.imageBytes.value.isNotEmpty || controller.imageUrl.isNotEmpty ? Stack(
                            children: [
                              Container(
                                width: imageWidth,
                                height: imageHeight,
                                margin: const EdgeInsets.only(
                                    right: 12),
                                decoration: BoxDecoration(
                                  borderRadius:
                                  BorderRadius.circular(8),
                                  image: DecorationImage(
                                    image: controller.imageBytes.value.isNotEmpty
                                        ? MemoryImage(controller.imageBytes.value) :
                                    NetworkImage(controller.imageUrl.value)
                                    as ImageProvider,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 4,
                                right: 4,
                                child: GestureDetector(
                                  onTap: () => controller.removeImage(),
                                  child: const MouseRegion(
                                    cursor: SystemMouseCursors.click,
                                    child: CircleAvatar(
                                      radius: 10,
                                      backgroundColor:
                                      Colors.red,
                                      child: Icon(
                                        Icons.close,
                                        size: 13,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ) :
                          // Upload Image Box
                          MouseRegion(
                            cursor: SystemMouseCursors.click,
                            child: InkWell(
                              onTap: controller.pickImageWeb,
                              child: Container(
                                width: imageWidth,
                                height: imageHeight,
                                decoration: BoxDecoration(
                                  borderRadius:
                                  BorderRadius.circular(8),
                                  border: Border.all(
                                    color: primaryColor
                                        .withOpacity(0.4),
                                    width: 0.6,
                                  ),
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black
                                          .withOpacity(0.1),
                                      spreadRadius: 1,
                                      blurRadius: 6,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  mainAxisAlignment:
                                  MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons
                                          .add_circle_outline_rounded,
                                      color: primaryColor,
                                      size: 40,
                                    ),
                                    const SizedBox(height: 16),
                                    Text(
                                      'Add More Photos',
                                      style: simpleText.copyWith(
                                        fontWeight:
                                        FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),

                        ),
                        ),
                        const SizedBox(height: 10),
                        TextAndFieldsOrDropDown(
                          labelText: 'Name',
                          fieldHintText: 'Top date destinations',
                          fieldController: controller.discoverListNameController,
                          isDropDown: false,
                          fieldValidator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter discover list name.';
                            }
                            return null;
                          },
                        ),
                        TextAndFieldsOrDropDown(
                          labelText: 'Creator',
                          fieldHintText: 'Savrli',
                          fieldController: controller.discoverListByController,
                          isDropDown: false,
                          fieldValidator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter discover list creator.';
                            }
                            return null;
                          },
                        ),
                        TextAndFieldsOrDropDown(
                          labelText: 'Description',
                          fieldHintText: 'About the list',
                          fieldController: controller.discoverListDescController,
                          isDropDown: false,
                          maxLines: 5,
                          fieldValidator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter discover list description.';
                            }
                            return null;
                          },
                        ),
                        Text(
                          'Add Restaurants',
                          style: headingText.copyWith(
                              fontSize: isMobile ? 16 : 20),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Required Filters',
                          style: headingText.copyWith(
                              fontSize: isMobile ? 14 : 16),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(
                              child: DropdownSearch<String>(
                                key: const Key('state_dropdown'),
                                selectedItem: controller.selectedState.value.isNotEmpty
                                    ? controller.selectedState.value
                                    : null,
                                items: (String? filter, _) =>
                                    controller.getFilteredStates(filter),
                                itemAsString: (String? item) => item ?? '',
                                onChanged: controller.isLocationDataLoading.value
                                    ? null
                                    : controller.onStateSelected,
                                validator: (String? value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return 'Please select a state.';
                                  }
                                  return null;
                                },
                                // Clear button (optional; remove if IDE error persists - it's not required)
                                // clearButtonProps: const ClearButtonProps(isVisible: true),
                                popupProps: PopupProps.menu(
                                  menuProps: MenuProps(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  showSearchBox: true,
                                  searchFieldProps: TextFieldProps(
                                    decoration: InputDecoration(
                                      hintText: 'Type to search states...',
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide(color: lightColor),
                                      ),
                                      prefixIcon: const Icon(Icons.search),
                                    ),
                                  ),
                                  showSelectedItems: true,
                                  fit: FlexFit.loose,
                                  constraints: const BoxConstraints(maxHeight: 300),
                                  itemBuilder: (context, item, isSelected, _) {
                                    return Container(
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: isSelected ? primaryColor.withOpacity(0.1) : null,
                                      ),
                                      child: Text(
                                        item,
                                        style: TextStyle(
                                          color: isSelected ? primaryColor : Colors.black87,
                                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                                decoratorProps: DropDownDecoratorProps(
                                  decoration: InputDecoration(
                                    hintText: 'Select or search state',
                                    hintStyle: TextStyle(color: lightColor),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide: BorderSide(color: lightColor),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide: BorderSide(color: lightColor),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide: BorderSide(color: lightColor),
                                    ),
                                    suffixIcon: const Icon(Icons.arrow_drop_down, color: primaryColor),
                                  ),
                                ),
                                enabled: !controller.isLocationDataLoading.value,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: CustomTextField(
                                readOnly: controller.selectedState.value.isEmpty ||
                                    controller.isLocationDataLoading.value,
                                controller: controller.cityController,
                                hintText: controller.selectedState.value.isNotEmpty
                                    ? 'Enter or select city'
                                    : 'Select State First',
                                validator: (value) {
                                  if (controller.selectedState.value.isEmpty) {
                                    return 'Please select a state first.';
                                  }
                                  if (value == null || value.trim().isEmpty) {
                                    return 'Please enter a city.';
                                  }
                                  return null;
                                },
                                suffixIcon: IconButton(
                                  icon: const Icon(Icons.arrow_drop_down, color: primaryColor),
                                  onPressed: () {
                                    controller.selectedState.value
                                        .isNotEmpty &&
                                        !controller.isLocationDataLoading
                                            .value
                                        ? controller.showCityPicker(context)
                                        : null;// Disable if no state selected
                                  },
                                ),
                                onChanged: (value) {
                                  controller.selectedCity.value = value ?? '';
                                  return null; // Sync on change (redundant with listener but ensures)
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'Optional Filters',
                          style: headingText.copyWith(fontSize: isMobile ? 14 : 16),
                        ),
                        const SizedBox(height: 10),
                        _buildMultiSelectDropdown(
                          label: 'Vibes',
                          selectedItems: controller.selectedVibes,
                          items: controller.filterOptions['Vibes']!,
                          onChanged: (List<String> val) => controller.selectedVibes.value = val,
                        ),
                        const SizedBox(height: 10),
                        _buildMultiSelectDropdown(
                          label: 'Experiences',
                          selectedItems: controller.selectedExperiences,
                          items: controller.filterOptions['Experience']!,
                          onChanged: (List<String> val) => controller.selectedExperiences.value = val,
                        ),
                        const SizedBox(height: 10),
                        _buildMultiSelectDropdown(
                          label: 'Entertainment',
                          selectedItems: controller.selectedEntertainment,
                          items: controller.filterOptions['Entertainment']!,
                          onChanged: (List<String> val) => controller.selectedEntertainment.value = val,
                        ),
                        const SizedBox(height: 10),
                        _buildMultiSelectDropdown(
                          label: 'Cuisines',
                          selectedItems: controller.selectedCuisines,
                          items: controller.filterOptions['Cuisines']!,
                          onChanged: (List<String> val) => controller.selectedCuisines.value = val,
                        ),
                        const SizedBox(height: 10),
                        _buildMultiSelectDropdown(
                          label: 'Dietary',
                          selectedItems: controller.selectedDietary,
                          items: controller.filterOptions['Dietary']!,
                          onChanged: (List<String> val) => controller.selectedDietary.value = val,
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'Select Restaurant',
                          style: headingText.copyWith(fontSize: isMobile ? 16 : 20),
                        ),
                        const SizedBox(height: 10),
                        Obx(
                              () {
                            // Debug logging to check enabled conditions
                            print('Restaurant Dropdown - Enabled Check:');
                            print('  selectedState: ${controller.selectedState.value}');
                            print('  cityController.text: ${controller.cityController.text}');
                            print('  selectedCity: ${controller.selectedCity.value}');
                            print('  isRestaurantDataLoading: ${controller.isRestaurantDataLoading.value}');
                            return DropdownSearch<RestaurantModel>(
                              key: const Key('restaurant_dropdown'),
                              enabled: controller.selectedState.value.isNotEmpty &&
                                  controller.selectedCity.value.isNotEmpty &&
                                  !controller.isRestaurantDataLoading.value,
                              items: (String filter, LoadProps? loadOptions) async {
                                return await controller.getFilteredRestaurants(filter);
                              },
                              compareFn: (RestaurantModel? item1, RestaurantModel? item2) {
                                return item1?.docID == item2?.docID;
                              },
                              itemAsString: (RestaurantModel? item) => item?.resName ?? '',
                              onChanged: (RestaurantModel? value) {
                                if (value != null && !controller.selectedRestaurants.any((r) => r.docID == value.docID)) {
                                  controller.selectedRestaurants.add(value);
                                }
                              },
                              popupProps: PopupProps.menu(
                                menuProps: MenuProps(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                showSearchBox: true,
                                searchFieldProps: TextFieldProps(
                                  decoration: InputDecoration(
                                    hintText: 'Type to search restaurants...',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide(color: lightColor),
                                    ),
                                    prefixIcon: const Icon(Icons.search),
                                  ),
                                ),
                                showSelectedItems: true,
                                fit: FlexFit.loose,
                                constraints: const BoxConstraints(maxHeight: 300),
                                itemBuilder: (context, item, isSelected, isDisabled) {
                                  return Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: isSelected ? primaryColor.withOpacity(0.1) : null,
                                    ),
                                    child: Text(
                                      item.resName,
                                      style: TextStyle(
                                        color: isDisabled
                                            ? Colors.grey
                                            : isSelected
                                            ? primaryColor
                                            : Colors.black87,
                                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                                      ),
                                    ),
                                  );
                                },
                              ),
                              decoratorProps: DropDownDecoratorProps(
                                decoration: InputDecoration(
                                  hintText: 'Select or search restaurant',
                                  hintStyle: TextStyle(color: lightColor),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide(color: lightColor),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide(color: lightColor),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide(color: lightColor),
                                  ),
                                  suffixIcon: const Icon(Icons.arrow_drop_down, color: primaryColor),
                                ),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 20),
                        Obx(
                              () => controller.selectedRestaurants.isEmpty
                              ? const SizedBox.shrink()
                              : SizedBox(
                            height: 50,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: controller.selectedRestaurants.length,
                              itemBuilder: (context, index) {
                                final restaurant = controller.selectedRestaurants[index];
                                return Padding(
                                  padding: const EdgeInsets.only(right: 8.0),
                                  child: Chip(
                                    label: Text(restaurant.resName),
                                    onDeleted: () {
                                      controller.selectedRestaurants.removeAt(index);
                                    },
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),
                        Center(
                          child: CustomButton(
                              ontapp: () async {
                                if (formKey.currentState!.validate()) {
                                  if (controller.selectedRestaurants.isEmpty) {
                                    Get.snackbar(
                                      'Restaurants Required',
                                      'Please add at least one restaurant to the list.',
                                      maxWidth: 400,
                                      backgroundColor: primaryColor,
                                      colorText: Colors.white,
                                      snackPosition: SnackPosition.TOP,
                                    );
                                    return;
                                  }
                                  if (controller.isEdit.value) {
                                    await controller.updateDiscoverList(
                                        docID: controller.selectedDiscoverListModel!.docId);
                                    return;
                                  } else {
                                    await controller.addDiscoverList();
                                  }
                                }
                              },
                              width: 169,
                              laBelText:
                              controller.isEdit.value ? 'Update' : 'Save'),
                        )
                      ]),
                ),
                const SizedBox(height: 20),
              ]),
        ),
      ),
    );
  }

  Widget _buildMultiSelectDropdown({
    required String label,
    required RxList<String> selectedItems,
    required List<String> items,
    required Function(List<String>) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: headingText.copyWith(fontSize: 16),
        ),
        const SizedBox(height: 5),
        DropdownSearch<String>.multiSelection(
          items: (String filter, LoadProps? props) => items.where((item) {
            return filter.isEmpty || item.toLowerCase().contains(filter.toLowerCase());
          }).toList(),
          selectedItems: selectedItems,
          onChanged: onChanged,
          popupProps: PopupPropsMultiSelection.menu(
            menuProps: MenuProps(
              borderRadius: BorderRadius.circular(10),
            ),
            showSearchBox: true,
            searchFieldProps: TextFieldProps(
              decoration: InputDecoration(
                hintText: 'Type to search $label...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: lightColor),
                ),
                prefixIcon: const Icon(Icons.search),
              ),
            ),
            showSelectedItems: true,
            fit: FlexFit.loose,
            constraints: const BoxConstraints(maxHeight: 300),
            itemBuilder: (context, item, isSelected, isDisabled) {
              return Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isSelected ? primaryColor.withOpacity(0.1) : null,
                ),
                child: Text(
                  item,
                  style: TextStyle(
                    color: isDisabled
                        ? Colors.grey
                        : isSelected
                        ? primaryColor
                        : Colors.black87,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
              );
            },
          ),
          decoratorProps: DropDownDecoratorProps(
            decoration: InputDecoration(
              hintText: 'Select $label (optional)',
              hintStyle: TextStyle(color: lightColor),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: lightColor),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: lightColor),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: lightColor),
              ),
              suffixIcon: const Icon(Icons.arrow_drop_down, color: primaryColor),
            ),
          ),
        ),
      ],
    );
  }
}