import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kaistable_website/constants/app_colors.dart';
import '../../../custom_widget/separate_text_field.dart';
import 'common_widget/tab_widget.dart';
import 'common_widget/tabs_widget.dart';
import 'controller/events_controller.dart';
import 'events_list.dart';

class EventScreen extends StatelessWidget {
  final controller = Get.put(EventsController());
  final categoryController = Get.put(CategoryController());
  EventScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: AppBar(
        backgroundColor: AppColors.whiteColor,
        iconTheme: IconThemeData(color: AppColors.primaryColor),
        centerTitle: true,
        leading: Padding(
          padding: const EdgeInsets.all(12.0),
          child: GestureDetector(
            onTap: () => Get.back(),
            child:
                Icon(Icons.arrow_back, size: 18, color: AppColors.primaryColor),
          ),
        ),
        title: Text(
          'Events',
          style: const TextStyle(
            fontSize: 17,
            color: AppColors.bottomSheetColor,
            fontWeight: FontWeight.w700,
            fontFamily: 'Nunito-Bold',
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Search bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: SizedBox(
              height: 38,
              child: CustomSeparateTextField(
                controller: controller.searchController,
                hintText: 'Try searching for restaurant name',
                hintStyle: TextStyle(
                  color: AppColors.hintText,
                  fontFamily: "Nunito-Regular",
                  fontWeight: FontWeight.w400,
                  fontSize: 12,
                ),
                isPrefixIcon: true,
                maxLines: 1,
                isShadow: true,
                prefixIcon: Padding(
                  padding: const EdgeInsets.only(
                      left: 4, top: 8, bottom: 8, right: 0),
                  child: Image.asset(
                    'assets/images/search_icon.png',
                    fit: BoxFit.contain,
                    height: 20,
                    width: 20,
                  ),
                ),
                isSuffixIcon: true,
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),

          /// horizontal tabs
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: HorizontalCategorySelector(),
          ),
          Obx(
            () => categoryController.selectedCat.value == 'Distance'
                ? Column(
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: HorizontalMiles(),
                      ),
                    ],
                  )
                : SizedBox(),
          ),

          SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              'Top Events for today',
              style: TextStyle(
                  color: AppColors.bottomSheetColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Nunito-Bold'),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              'Get ready to make the most of your day with exciting events happening around you. From a cozy outdoor movie night under the stars to a sizzling chef’s tasting menu at your favorite restaurant, there’s something for everyone.',
              style: TextStyle(
                  color: AppColors.textColor,
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  fontFamily: 'Nunito-Regular'),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Expanded(
            child: Column(
              children: [
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Obx(
                        () => GestureDetector(
                          onTap: () {
                            controller.upcomingAppointmentsCheck.value = 0;
                          },
                          child: datSelectionWidget(
                            text: "Today",
                            index: 0,
                            selectIndex:
                                controller.upcomingAppointmentsCheck.value,
                          ),
                        ),
                      ),
                      const Expanded(flex: 1, child: SizedBox()),
                      Obx(
                        () => GestureDetector(
                          onTap: () {
                            controller.upcomingAppointmentsCheck.value = 1;
                          },
                          child: datSelectionWidget(
                            text: "This week",
                            index: 1,
                            selectIndex:
                                controller.upcomingAppointmentsCheck.value,
                          ),
                        ),
                      ),
                      const Expanded(flex: 1, child: SizedBox()),
                      Obx(
                        () => GestureDetector(
                          onTap: () {
                            controller.upcomingAppointmentsCheck.value = 2;
                          },
                          child: datSelectionWidget(
                            text: "This month",
                            index: 2,
                            selectIndex:
                                controller.upcomingAppointmentsCheck.value,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                //divider
                const SizedBox(),
                const Divider(
                  color: AppColors.primaryColor,
                  thickness: 0.2,
                  height: 1,
                ),
                Expanded(
                  child:
                      Obx(() => controller.upcomingAppointmentsCheck.value == 0
                          ? EventsList(
                              eventsOnly: 'Today',
                            )
                          : controller.upcomingAppointmentsCheck.value == 1
                              ? EventsList(
                                  eventsOnly: 'This week',
                                )
                              : EventsList(
                                  eventsOnly: 'This month',
                                )),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
