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
  // Keep your controllers so other parts of the app can still find them.
  final HomeLocationController homeLocationController =
      Get.put(HomeLocationController());
  final FilterSelectionController filterSelectionController =
      Get.put(FilterSelectionController());

  // Local state just for this widget (strongly typed as String).
  final RxString selectedTop = ''.obs;
  final RxString selectedDiningTime = ''.obs;

  // Example static lists
  final List<String> topItems = const ['Happy Hours'];
  final List<String> diningItems = const [
    'Breakfast',
    'Lunch',
    'Dinner',
    'Brunch'
  ];

  FilterWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isDesktop = Responsive.isDesktop(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Top row: search + two dropdowns
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search field
            Expanded(
              flex: 2,
              child: SeparateTextField(
                hintText: 'Search by restaurant, cuisine, or vibe',
                onTap: () {},
              ),
            ),
            const SizedBox(width: 12),

            // Top filter dropdown (uses local selectedTop)
            Expanded(
              flex: isDesktop ? 1 : 2,
              child: Obx(
                () {
                  final String current = selectedTop.value;
                  return _buildDropdown(
                    label: 'Top filter',
                    items: topItems,
                    value: current.isEmpty ? null : current,
                    onChanged: (String? value) {
                      if (value != null) {
                        selectedTop.value = value;
                      }
                    },
                  );
                },
              ),
            ),
            const SizedBox(width: 12),

            // Dining time dropdown (uses local selectedDiningTime)
            Expanded(
              flex: isDesktop ? 1 : 2,
              child: Obx(
                () {
                  final String current = selectedDiningTime.value;
                  return _buildDropdown(
                    label: 'Dining time',
                    items: diningItems,
                    value: current.isEmpty ? null : current,
                    onChanged: (String? value) {
                      if (value != null) {
                        selectedDiningTime.value = value;
                      }
                    },
                  );
                },
              ),
            ),
          ],
        ),

        const SizedBox(height: 16),

        // Example extra actions / filters
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

        const SizedBox(height: 16),

        ElevatedButton(
          onPressed: () {
            // Keep this since you had a bottom sheet / happy hours flow
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

  /// Strongly-typed dropdown helper (no dynamic anywhere).
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
            onChanged: (String? newValue) {
              onChanged(newValue);
            },
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

  /// Simple FilterChip that doesn’t depend on any external controller.
  Widget _simpleChip(String label) {
    // Local selection state for each chip if needed.
    final RxBool selected = false.obs;

    return Obx(
      () => FilterChip(
        label: Text(label),
        selected: selected.value,
        onSelected: (bool value) {
          selected.value = value;
        },
      ),
    );
  }
}
