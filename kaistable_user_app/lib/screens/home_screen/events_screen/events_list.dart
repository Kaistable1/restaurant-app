import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kaistable_website/constants/app_colors.dart';
import 'common_widget/days_tile.dart';
import 'controller/events_controller.dart';
import 'events_details_screen/event_details_screen.dart';

class TodayEvents extends StatelessWidget {
  final EventsController controller = Get.put(EventsController());

  TodayEvents({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => ListView.builder(
      shrinkWrap: true, // Ensures it takes only the necessary space
      physics: ScrollPhysics(), // Prevents scrolling if inside another scrollable view
      itemCount: controller.eventsList.length,
      itemBuilder: (context, index) {
        final event = controller.eventsList[index];
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: DaysTile(
                onTap: ()=>Get.to(EventDetailsScreen()),
                image: event.image,
                title: event.title,
                location: event.location,
              ),
            ),
            if (index != controller.eventsList.length - 1) // Avoid divider after last item
              Divider(
                thickness: 1,
                color: AppColors.primaryColor.withOpacity(.2),
              ),
          ],
        );
      },
    ));
  }
}
