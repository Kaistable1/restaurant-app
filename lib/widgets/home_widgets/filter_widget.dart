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
  final List<String> diningItems = const [
    'Breakfast',
    'Lunch',
    'Dinner',
    'Brunch'
  ];

  final RxBool isTapped = false.obs;
  final RxBool showFilterOptions = false.obs;

  FilterWidget({super.key}) {
    // Ensure this is always initialized to a String
    controller.selectedTop.value = '';
  }

  @override
  Widget build(BuildContext context) {
    final bool isDesktop = Responsive.isDesktop(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Top row of filters
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Example: search field (replace with your SeparateTextField if needed)
            Expanded(
              flex: 3,
              child: SeparateTextField(
                hintText: 'Search by restaurant, cuisine, or vibe',
                onTap: () {},
              ),
            ),
            const SizedBox(width: 16),

            // First dropdown – top filter (e.g. Happy Hours / etc)
            Expanded(
              flex: isDesktop ? 1 : 2,
              child: Obx(
                () => _buildDropdown(
                  label: 'Top filter',
                  value: controller.selectedTop.value.isEmpty
                      ? null
                      : controller.selectedTop.value,
                  items: items,
                  onChanged: (String? value) {
                    if (value != null) {
                      controller.selectedTop.value = value;
                    }
                  },
                ),
              ),
            ),
            const SizedBox(width: 16),

            // Second dropdown – dining time
            Expanded(
              flex: isDesktop ? 1 : 2,
              child: Obx(
                () => _buildDropdown(
                  label: 'Dining time',
                  value: filterController.selectedDiningTime.value.isEmpty
                      ? null
                      : filterController.selectedDiningTime.value,
                  items: diningItems,
                  onChanged: (String? value) {
                    if (value != null) {
                      filterController.selectedDiningTime.value = value;
                    }
                  },
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 12),

        // Optional: extra filter toggle
        Obx(
          () => Align(
            alignment: Alignment.centerLeft,
            child: TextButton.icon(
              onPressed: () =>
                  showFilterOptions.value = !showFilterOptions.value,
              icon: Icon(
                showFilterOptions.value ? Icons.expand_less : Icons.expand_more,
              ),
              label: const Text('More filters'),
            ),
          ),
        ),

        // Expanded filter section
        Obx(
          () => AnimatedCrossFade(
            firstChild: const SizedBox.shrink(),
            secondChild: _buildExpandedFilters(context),
            crossFadeState: showFilterOptions.value
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 200),
          ),
        ),
      ],
    );
  }

  /// Reusable typed dropdown builder – **important** for fixing your CI errors.
  Widget _buildDropdown({
    required String label,
    required List<String> items,
    required String? value,
    required ValueChanged<String?> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
            )),
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
            onChanged: (String? newValue) {
              onChanged(newValue);
            },
            buttonStyleData: ButtonStyleData(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.borderColor),
                color: Colors.white,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12),
              height: 44,
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

  /// Example of an expanded filter section.
  /// You can customize this to match whatever you had before.
  Widget _buildExpandedFilters(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _buildFilterChip('Live music'),
            _buildFilterChip('Outdoor seating'),
            _buildFilterChip('Rooftop'),
            _buildFilterChip('Date night'),
          ],
        ),
        const SizedBox(height: 12),
        ElevatedButton(
          onPressed: () {
            // Example: open a bottom sheet or happy hours page
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

  Widget _buildFilterChip(String label) {
    return Obx(
      () {
        final bool selected = filterController.selectedTags.contains(label);
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
