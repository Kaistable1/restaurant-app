// lib/widgets/home_widgets/filter_widget.dart

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kaistable_website/screens/nav_bar/widgets/bottom_sheet.dart';
import '../../../constants/app_colors.dart';
import '../../../utils/responsive.dart';
import '../../custom_widget/separate_text_field.dart';
import '../../screens/home_screen/happy_hours/happy_hours.dart';
import '../../screens/home_screen/home_controller/filter_selection_controller.dart';
import '../../screens/home_screen/home_controller/home_location_controller.dart';

class FilterWidget extends StatelessWidget {
  final HomeLocationController controller = Get.put(HomeLocationController());
  final FilterSelectionController filterController =
      Get.put(FilterSelectionController());

  final List<String> items = const ['Happy Hours'];
  final List<String> diningItems = const ['Breakfast', 'Lunch', 'Dinner', 'Brunch'];

  final RxBool isTapped = false.obs;
  final RxBool showFilterOptions = false.obs;

  // Local state for dining time so we don’t rely on unknown fields
  final RxString selectedDiningTime = ''.obs;

  FilterWidget({super.key}) {
    // Make sure this is initialized as a String
    controller.selectedTop.value = '';
  }

  @override
  Widget build(BuildContext context) {
    final bool isDesktop = Responsive.isDesktop(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Top row with 2 dropdowns
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Left spacer so layout doesn’t break on web/desktop
            if (isDesktop) const SizedBox(width: 8),

            // Top filter dropdown (uses HomeLocationController.selectedTop)
            Expanded(
              flex: 1,
              child: Obx(
                () {
                  final String selectedTop = controller.selectedTop.value;
                  return _buildDropdown(
                    label: 'Top filter',
                    value: selectedTop.isEmpty ? null : selectedTop,
                    items: items,
                    onChanged: (String? value) {
                      if (value != null) {
                        controller.selectedTop.value = value;
                      }
                    },
                  );
                },
              ),
            ),

            const SizedBox(width: 12),

            // Dining time dropdown (local RxString)
            Expanded(
              flex: 1,
              child: Obx(
                () {
                  final String value = selectedDiningTime.value;
                  return _buildDropdown(
                    label: 'Dining time',
                    value: value.isEmpty ? null : value,
                    items: diningItems,
                    onChanged: (String? v) {
                      if (v != null) {
                        selectedDiningTime.value = v;
                      }
                    },
                  );
                },
              ),
            ),
          ],
        ),

        const SizedBox(height: 12),

        // Toggle for more filters (just a simple example)
        Obx(
          () => Align(
            alignment: Alignment.centerLeft,
            child: TextButton.icon(
              onPressed: () => showFilterOptions.value = !showFilterOptions.value,
              icon: Icon(
                showFilterOptions.value ? Icons.expand_less : Icons.expand_more,
              ),
              label: const Text('More filters'),
            ),
          ),
        ),

        // Expanded filter zone
        Obx(
          () => AnimatedCrossFade(
            duration: const Duration(milliseconds: 200),
            firstChild: const SizedBox.shrink(),
            secondChild: _buildExpandedFilters(context),
            crossFadeState: showFilterOptions.value
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
          ),
        ),
      ],
    );
  }

  /// ---------- REUSABLE WIDGETS BELOW ----------

  /// Strongly-typed dropdown builder (no `dynamic`).
  Widget _buildDropdown({
    required String label,
    required List<String> items,
    required String? value,
    required ValueChanged<String?> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 4),
        DropdownButtonHideUnderline(
          child: DropdownButton2<String>(
            isExpanded: true,
            value: value,
            hint: const Text('Select'),
            items: items
                .map<DropdownMenuItem<String>>(
                  (String item) => DropdownMenuItem<String>(
                    value: item,
                    child: Text(item),
                  ),
                )
                .toList(),
            onChanged: (String? newValue) => onChanged(newValue),
            buttonStyleData: ButtonStyleData(
              height: 44,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.borderColor),
                color: Colors.white,
              ),
            ),
            dropdownStyleData: DropdownStyleData(
              maxHeight: 250,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// Example of an expanded filter area.
  /// (You can customize this later as needed.)
  Widget _buildExpandedFilters(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _simpleChip('Live music'),
            _simpleChip('Outdoor seating'),
            _simpleChip('Rooftop'),
            _simpleChip('Date night'),
          ],
        ),
        const SizedBox(height: 12),
        ElevatedButton(
          onPressed: () {
            // Example use of imported bottom sheet / happy hours
            Get.bottomSheet(const CustomBottomSheet());
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
          ),
          child: const Text('View Happy Hours'),
        ),
      ],
    );
  }

  Widget _simpleChip(String label) {
    return Obx(
      () {
        final bool selected =
            filterController.selectedTags.contains(label); // assuming exists
        return FilterChip(
          label: Text(label),
          selected: selected,
          onSelected: (bool value) {
            if (value) {
              filterController.selectedTags.add(label);
            } else {
              filterController.selectedTags.remove(label);
            }
          },
        );
      },
    );
  }
}
