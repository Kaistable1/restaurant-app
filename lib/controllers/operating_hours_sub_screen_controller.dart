import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:savrly/controllers/add_restaurants_controller.dart';
import 'package:savrly/widgets/global_functions.dart';

class OperatingHoursSubScreenController extends GetxController {
  Map<String, ValueNotifier<bool>> daySwitchControllers = {};

  @override
  void onInit() {
    super.onInit();
    final days = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday'
    ];

    if (daySwitches.isEmpty) {
      daySwitches.value = Map.fromEntries(
        days.map((day) => MapEntry(day, true)),
      );
    }

    for (var day in days) {
      slotStates[day] ??= {
        'Breakfast': false,
        'Brunch': false,
        'Lunch': false,
        'Dinner': false,
      };
      slotTimes[day] ??= {
        'Breakfast': '',
        'Brunch': '',
        'Lunch': '',
        'Dinner': '',
      };
      daySwitchControllers[day] ??=
          ValueNotifier<bool>(daySwitches[day] ?? false)
            ..addListener(() {
              toggleDaySwitch(day);
            });
    }

    // Apply default values (optional)
    slotTimes['Monday']!['Dinner'] = '09:00 am - 11:00 am';
    slotStates['Monday']!['Dinner'] = true;
    slotTimes['Tuesday']!['Dinner'] = '09:00 am - 11:00 am';
    slotStates['Tuesday']!['Dinner'] = true;
    slotTimes['Wednesday']!['Dinner'] = '09:00 am - 11:00 am';
    slotStates['Wednesday']!['Dinner'] = true;
    slotTimes['Thursday']!['Dinner'] = '09:00 am - 11:00 am';
    slotStates['Thursday']!['Dinner'] = true;
    slotTimes['Friday']!['Dinner'] = '09:00 am - 11:00 am';
    slotStates['Friday']!['Dinner'] = true;
  }

  RxMap daySwitches = {}.obs;
  RxMap slotStates = {}.obs;
  RxMap slotTimes = {}.obs;

  void toggleDaySwitch(String day) {
    daySwitches[day] = !daySwitches[day]!;
    daySwitchControllers[day]!.value = daySwitches[day]!; // Sync ValueNotifier

    if (!daySwitches[day]!) {
      // If day is disabled, set all slots to "Off" and clear times
      slotStates[day]!.updateAll((key, value) => false);
      slotTimes[day]!.updateAll((key, value) => '');
    }

    daySwitches.refresh();
    slotStates.refresh();
    slotTimes.refresh();
    update(); // Notify GetX listeners
  }

// Toggle the "On/Off" state for a slot
  void toggleSlotState(String day, String slot) {
    slotStates[day]![slot] = !slotStates[day]![slot]!;
    if (!slotStates[day]![slot]!) {
      // If slot is turned "Off", clear the time
      slotTimes[day]![slot] = '';
    }
    slotStates.refresh(); // Ensure UI updates
    slotTimes.refresh(); // Ensure time updates
  }

// Set time for a slot using TimePicker
  setTime(BuildContext context, String day, String slot) async {
    final TimeOfDay? startTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (startTime != null) {
      final TimeOfDay? endTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );
      if (endTime != null) {
        final start = startTime.format(context);
        final end = endTime.format(context);
        slotTimes[day]![slot] = '$start - $end';
        slotStates[day]![slot] = true; // Ensure slot is "On" when time is set
        slotTimes.refresh(); // Update UI
        slotStates.refresh(); // Update UI
      }
    }
  }

  //backend

  saveAllOperatingHours() async {
    try {
      loadingDialog();
      print("Saving Operating Hours...");

      final addRestaurantTabController = Get.find<AddRestaurantTabController>();

      // Validate restaurant model exists
      if (addRestaurantTabController.restaurantModel == null ||
          addRestaurantTabController.restaurantModel!.docID.isEmpty) {
        Get.back(); // Close loading dialog
        Get.snackbar(
          'Error',
          'Restaurant information not found. Please try again.',
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
        );
        return;
      }

      final restaurantID = addRestaurantTabController.restaurantModel!.docID;

      for (var day in daySwitches.keys) {
        // Create a map to hold meal periods for the current day
        Map<String, dynamic> mealsMap = {};

        // Check if the day is toggled off
        if (daySwitches[day] == false) {
          print("$day is toggled off. Saving all meals as closed...");
          // Mark all meals as closed for this day
          for (var meal in slotTimes[day]!.keys) {
            mealsMap[meal] = {"isClosed": true};
          }
        } else {
          // Iterate over meal periods for the active day
          for (var meal in slotTimes[day]!.keys) {
            // Check if the meal is active
            if (slotStates[day]![meal] == false) {
              mealsMap[meal] = {"isClosed": true}; // Mark meal as closed
              continue;
            }

            // Get the meal's start and end time
            final timeString = slotTimes[day]![meal] ?? '';
            String fromTime = '';
            String toTime = '';

            // Split the time string (e.g., "09:00 am - 11:00 am") into start and end times
            if (timeString.isNotEmpty) {
              final times = timeString.split(' - ');
              if (times.length == 2) {
                fromTime = times[0].trim();
                toTime = times[1].trim();
              }
            }

            // Skip invalid times
            if (fromTime.isEmpty || toTime.isEmpty) {
              print("Skipping $meal on $day: Invalid times.");
              mealsMap[meal] = {"isClosed": true}; // Save as closed
              continue;
            }

            // Add meal period to the day's map
            mealsMap[meal] = {
              "isClosed": false,
              "startTime": fromTime,
              "endTime": toTime,
            };
          }
        }

        // Save the day's meals map to Firestore
        try {
          await FirebaseFirestore.instance
              .collection('restaurants')
              .doc(restaurantID)
              .collection('operatingHours')
              .doc(day) // Day as document
              .set(mealsMap); // Meals as map
          print("$day saved successfully in Firestore.");
        } catch (e) {
          print("Error saving $day: $e");
          Get.back(); // Close loading dialog
          Get.snackbar(
            'Error',
            'Failed to save operating hours for $day: $e',
            backgroundColor: Colors.red,
            colorText: Colors.white,
            snackPosition: SnackPosition.TOP,
          );
          return;
        }
      }

      Get.back(); // Close loading dialog
      print("All operating hours saved successfully.");
    } catch (e) {
      print("Error in saveAllOperatingHours: $e");
      // Ensure dialog is closed even if an unexpected error occurs
      try {
        Get.back();
      } catch (_) {}

      Get.snackbar(
        'Error',
        'Failed to save operating hours: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
    }
  }
}
