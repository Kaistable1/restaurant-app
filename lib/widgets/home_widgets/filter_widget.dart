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
  final List<String> items = [
    'Happy Hours',
  ];
  final List<String> diningItems = ['Breakfast', 'Lunch', 'Dinner', 'Brunch'];
  final RxBool isTapped = false.obs;
  final RxBool showFilterOptions = false.obs;

  FilterWidget({super.key}) {
    controller.selectedTop.value = '';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding:
              const EdgeInsets.only(top: 10.0, left: 12, right: 10, bottom: 6),
          child: Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 38,
                  child: CustomSeparateTextField(
                    controller: controller.searchController,
                    hintText: 'Try searching for restaurant name',
                    hintStyle: TextStyle(
                      color: App
