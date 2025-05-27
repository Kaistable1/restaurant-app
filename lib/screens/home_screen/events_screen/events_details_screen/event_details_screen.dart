import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kaistable_website/models/events.dart';

import '../../../../constants/app_colors.dart';
import '../common_widget/additional_info_widget.dart';
import '../common_widget/details_tab_widget.dart';
import '../controller/events_controller.dart';
import 'event_details_gallary.dart';

class EventDetailsScreen extends StatelessWidget {
  final EventsController controller = Get.put(EventsController());
  EventDetailsScreen({super.key, required this.event});
  Event event;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Container(
                height: 327,
                width: Get.width,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: NetworkImage(event.imageUrls.first),
                        fit: BoxFit.cover)),
              ),
              AppBar(
                backgroundColor: Colors.transparent,
                iconTheme: const IconThemeData(
                  color: AppColors.primaryColor,
                ),
                centerTitle: true,
                automaticallyImplyLeading: true,
                leading: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Container(
                    height: 16,
                    width: 16,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          spreadRadius: 1,
                          blurRadius: 3,
                          offset: const Offset(0, 1),
                        ),
                      ],
                    ),
                    child: GestureDetector(
                      onTap: () {
                        Get.back();
                      },
                      child: Icon(Icons.arrow_back,
                          size: 18, color: AppColors.primaryColor),
                    ),
                  ),
                ),
                title: const Text(
                  'Event details',
                  style: TextStyle(
                    fontSize: 17,
                    color: AppColors.whiteColor,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Nunito-Bold',
                  ),
                ),
              ),
              Positioned(
                bottom: 16,
                left: 120,
                child: ClipRRect(
                  // Prevents blur from overflowing
                  borderRadius: BorderRadius.circular(4), // Same as container
                  child: BackdropFilter(
                    filter:
                        ImageFilter.blur(sigmaX: 8, sigmaY: 8), // Blur effect
                    child: GestureDetector(
                      onTap: () => Get.to(EventDetailsGallery(
                        imageList: event.imageUrls,
                      )),
                      child: Container(
                        height: 32,
                        width: 151,
                        decoration: BoxDecoration(
                          color: AppColors.whiteColor
                              .withOpacity(0.2), // Adjust opacity
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Center(
                          child: Text(
                            "Sell all ${event.imageUrls.length} photos", // Add text if needed
                            style: TextStyle(
                              color: AppColors.primaryColor,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              event.eventName,
              style: TextStyle(
                  color: AppColors.bottomSheetColor,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Nunito-Bold'),
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                Image.asset('assets/images/location_icon2.png',
                    width: 16, height: 16),
                const SizedBox(width: 6),
                Text(
                  event.location,
                  style: const TextStyle(
                    color: Color(0xFF4F5A57),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Nunito-Regular',
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
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
                          child: detailsSelectionWidget(
                            text: "Details",
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
                            controller.upcomingAppointmentsCheck.value = 2;
                          },
                          child: detailsSelectionWidget(
                            text: "Additional information",
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
                SizedBox(
                  height: 10,
                ),
                Expanded(
                  child:
                      Obx(() => controller.upcomingAppointmentsCheck.value == 0
                          ? DetailsTabWidget(
                              location: event.location,
                              lat: event.latitude,
                              long: event.longitude,
                            )
                          : AdditionalInfoWidget(
                              desctiption: event.description,
                              date: event.date,
                              time: event.time,
                              phone: event.phoneNumber,
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

/// Tab widget
detailsSelectionWidget({
  required int index,
  required int selectIndex,
  required String text,
}) {
  return Column(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.center,
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Padding(
        padding:
            EdgeInsets.symmetric(horizontal: index == selectIndex ? 11 : 0),
        child: Align(
          alignment: index != selectIndex && index == 0
              ? Alignment.center
              : index != selectIndex && index == 1
                  ? Alignment.center
                  : Alignment.center,
          child: Text(
            text,
            style: TextStyle(
                color: index == selectIndex
                    ? AppColors.primaryColor
                    : Color(0xFF4F5A57),
                fontWeight: FontWeight.w800,
                fontFamily: 'Quicksand-bold',
                fontSize: 12),
            textAlign: TextAlign.center, // Center the text within the container
          ),
        ),
      ),
      const SizedBox(
        height: 10,
      ),
      if (index == selectIndex) ...{
        Container(
          width: selectIndex == 2
              ? 150
              : 109, // Adjust the width to your desired value
          height: 4,
          decoration: const ShapeDecoration(
            color: AppColors.primaryColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
            ),
          ),
        ),
      }
    ],
  );
}
