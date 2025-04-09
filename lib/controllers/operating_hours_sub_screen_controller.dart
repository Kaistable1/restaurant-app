import 'package:flutter/material.dart';
import 'package:get/get.dart';

// class OperatingHoursSubScreenController extends GetxController {
//
//   Map<String, ValueNotifier<bool>> daySwitchControllers = {};
//
//   @override
//   void onInit() {
//     super.onInit();
//     daySwitches.forEach((day, isEnabled) {
//       daySwitchControllers[day] = ValueNotifier<bool>(isEnabled)
//         ..addListener(() {
//           toggleDaySwitch(day); // Sync with daySwitches
//         });
//     });
//   }
//
//   // Map to store the switch state for each day (true = enabled, false = disabled)
//   RxMap<String, bool> daySwitches = {
//     'Monday': true,
//     'Tuesday': true,
//     'Wednesday': true,
//     'Thursday': true,
//     'Friday': true,
//     'Saturday': false,
//     'Sunday': false,
//   }.obs;
//
//   // Map to store the "On/Off" state for each slot (true = On, false = Off)
//   RxMap<String, Map<String, bool>> slotStates = {
//     'Monday': {
//       'Breakfast': true,
//       'Brunch': false,
//       'Lunch': true,
//       'Dinner': true,
//     },
//     'Tuesday': {
//       'Breakfast': false,
//       'Brunch': false,
//       'Lunch': true,
//       'Dinner': true,
//     },
//     'Wednesday': {
//       'Breakfast': false,
//       'Brunch': false,
//       'Lunch': true,
//       'Dinner': true,
//     },
//     'Thursday': {
//       'Breakfast': false,
//       'Brunch': false,
//       'Lunch': true,
//       'Dinner': true,
//     },
//     'Friday': {
//       'Breakfast': true,
//       'Brunch': false,
//       'Lunch': true,
//       'Dinner': true,
//     },
//     'Saturday': {
//       'Breakfast': false,
//       'Brunch': false,
//       'Lunch': false,
//       'Dinner': false,
//     },
//     'Sunday': {
//       'Breakfast': false,
//       'Brunch': false,
//       'Lunch': false,
//       'Dinner': false,
//     },
//   }.obs;
//
//   // Map to store the time for each slot (default times as per the image)
//   RxMap<String, Map<String, String>> slotTimes = {
//     'Monday': {
//       'Breakfast': '',
//       'Brunch': '',
//       'Lunch': '',
//       'Dinner': '09:00 am - 11:00 am',
//     },
//     'Tuesday': {
//       'Breakfast': '',
//       'Brunch': '',
//       'Lunch': '',
//       'Dinner': '09:00 am - 11:00 am',
//     },
//     'Wednesday': {
//       'Breakfast': '',
//       'Brunch': '',
//       'Lunch': '',
//       'Dinner': '09:00 am - 11:00 am',
//     },
//     'Thursday': {
//       'Breakfast': '',
//       'Brunch': '',
//       'Lunch': '',
//       'Dinner': '09:00 am - 11:00 am',
//     },
//     'Friday': {
//       'Breakfast': '',
//       'Brunch': '',
//       'Lunch': '',
//       'Dinner': '09:00 am - 11:00 am',
//     },
//     'Saturday': {
//       'Breakfast': '',
//       'Brunch': '',
//       'Lunch': '',
//       'Dinner': '',
//     },
//     'Sunday': {
//       'Breakfast': '',
//       'Brunch': '',
//       'Lunch': '',
//       'Dinner': '',
//     },
//   }.obs;
//
// // Toggle the switch for a day
//   void toggleDaySwitch(String day) {
//     daySwitches[day] = !daySwitches[day]!;
//     if (!daySwitches[day]!) {
//       // If day is disabled, set all slots to "Off" and clear times
//       slotStates[day]!.updateAll((key, value) => false);
//       slotTimes[day]!.updateAll((key, value) => '');
//     }
//     daySwitches.refresh(); // Ensure UI updates
//   }
//
// // Toggle the "On/Off" state for a slot
//   void toggleSlotState(String day, String slot) {
//     slotStates[day]![slot] = !slotStates[day]![slot]!;
//     if (!slotStates[day]![slot]!) {
//       // If slot is turned "Off", clear the time
//       slotTimes[day]![slot] = '';
//     }
//     slotStates.refresh(); // Ensure UI updates
//     slotTimes.refresh(); // Ensure time updates
//   }
//
// // Set time for a slot using TimePicker
//   Future<void> setTime(BuildContext context, String day, String slot) async {
//     final TimeOfDay? startTime = await showTimePicker(
//       context: context,
//       initialTime: TimeOfDay.now(),
//     );
//     if (startTime != null) {
//       final TimeOfDay? endTime = await showTimePicker(
//         context: context,
//         initialTime: TimeOfDay.now(),
//       );
//       if (endTime != null) {
//         final start = startTime.format(context);
//         final end = endTime.format(context);
//         slotTimes[day]![slot] = '$start - $end';
//         slotStates[day]![slot] = true; // Ensure slot is "On" when time is set
//         slotTimes.refresh(); // Update UI
//         slotStates.refresh(); // Update UI
//       }
//     }
//   }
// }


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
      daySwitchControllers[day] ??= ValueNotifier<bool>(daySwitches[day] ?? false)
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
    daySwitches[day] = !(daySwitches[day] ?? false);
    if (!daySwitches[day]!) {
      slotStates[day]!.updateAll((key, value) => false);
      slotTimes[day]!.updateAll((key, value) => '');
    }
    daySwitches.refresh();
    slotStates.refresh();
    slotTimes.refresh();
  }

  void toggleSlotState(String day, String slot) {
    slotStates[day]![slot] = !(slotStates[day]![slot] ?? false);
    if (!slotStates[day]![slot]!) {
      slotTimes[day]![slot] = '';
    }
    slotStates.refresh();
    slotTimes.refresh();
  }

  Future<void> setTime(BuildContext context, String day, String slot) async {
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
        slotStates[day]![slot] = true;
        slotTimes.refresh();
        slotStates.refresh();
      }
    }
  }
}