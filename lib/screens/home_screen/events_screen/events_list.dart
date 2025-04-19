import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kaistable_website/constants/app_colors.dart';
import 'package:kaistable_website/screens/home_screen/events_screen/common_widget/tab_widget.dart';
import 'common_widget/days_tile.dart';
import 'controller/events_controller.dart';
import 'events_details_screen/event_details_screen.dart';

class EventsList extends StatelessWidget {
  final EventsController controller = Get.put(EventsController());
  final categoryController = Get.put(CategoryController());
  final String eventsOnly; // "Today", "This week", "This month"

  EventsList({super.key, required this.eventsOnly});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final today = DateTime.now();

      final filteredEvents = controller.events.where((event) {
        try {
          final eventDate = DateTime.parse(event.date);
          if (eventsOnly == 'Today') {
            return eventDate.year == today.year &&
                eventDate.month == today.month &&
                eventDate.day == today.day;
          } else if (eventsOnly == 'This week') {
            // Calculate Monday of current week
            final startOfWeek = today.subtract(Duration(days: today.weekday));
            // Sunday is end of week
            final endOfWeek = startOfWeek.add(Duration(days: 6));
            // Only compare dates, ignore time
            final justDate =
                DateTime(eventDate.year, eventDate.month, eventDate.day);
            return justDate.isAtSameMomentAs(startOfWeek) ||
                (justDate.isAfter(startOfWeek) &&
                    justDate.isBefore(endOfWeek.add(Duration(days: 1))));
          } else if (eventsOnly == 'This month') {
            return eventDate.year == today.year &&
                eventDate.month == today.month;
          }
          return false;
        } catch (e) {
          return false;
        }
      }).toList();

      //filter by category

      String selectedCategory = categoryController.selectedCat.value;
      if (selectedCategory.isNotEmpty && selectedCategory != 'Distance') {
        filteredEvents
            .retainWhere((event) => event.eventType == selectedCategory);
      }
// Apply geofencing filter if 'Distance' is selected and a valid mile value is chosen
      if (selectedCategory == 'Distance' &&
          categoryController.selectedMiles.isNotEmpty) {
       
        double maxDistance = double.parse(categoryController.selectedMiles
            .split(' ')[0]
            .replaceAll('Miles', '')
            .trim()); // Extract number (e.g., "5 Miles" -> 5.0)
        filteredEvents.retainWhere((event) {
          double distance = categoryController.calculateDistance(
            event.latitude,
            event.longitude,
          );
          return distance <= maxDistance;
        });
      }
      if (filteredEvents.isEmpty) {
        return Center(
          child: Text(
            'No events for $eventsOnly',
            style: TextStyle(
              color: AppColors.textColor,
              fontSize: 16,
              fontWeight: FontWeight.w400,
              fontFamily: 'Nunito-Regular',
            ),
          ),
        );
      }

      return ListView.builder(
        shrinkWrap: true,
        physics: ScrollPhysics(),
        itemCount: filteredEvents.length,
        itemBuilder: (context, index) {
          final event = filteredEvents[index];
          return Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: DaysTile(
                  onTap: () => Get.to(() => EventDetailsScreen(
                        event: event,
                      )),
                  image: event.imageUrls.first,
                  title: event.eventName,
                  location: event.location,
                  type: event.eventType,
                ),
              ),
              if (index != filteredEvents.length - 1)
                Divider(
                  thickness: 1,
                  color: AppColors.primaryColor.withOpacity(.2),
                ),
            ],
          );
        },
      );
    });
  }
}
