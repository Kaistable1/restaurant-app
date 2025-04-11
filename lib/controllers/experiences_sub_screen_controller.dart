import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:savrly/controllers/add_restaurants_controller.dart';
import 'package:savrly/widgets/global_functions.dart';

class ExperiencesSubScreenController extends GetxController {
  // Text controllers for each field
  final eventNameController = TextEditingController();
  final hostedByController = TextEditingController();
  final dateController = TextEditingController();
  final timeController = TextEditingController();
  final endTimeController = TextEditingController();
  final experienceSubScreenFormKey = GlobalKey<FormState>();
  RxList<Map<String, dynamic>> events = <Map<String, dynamic>>[].obs;

  // Select date using DatePicker
  Future<void> selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      final formattedDate = DateFormat('dd MMMM yyyy').format(picked);
      dateController.text = formattedDate;
    }
  }

  // Select time using TimePicker
  Future<void> selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      timeController.text = picked.format(context); // e.g., "9:00 AM"
    }
  }

  Future<void> selectEndTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      endTimeController.text = picked.format(context); // e.g., "9:00 AM"
    }
  }

  // Save event and clear fields
  void saveEvent() {
    if (experienceSubScreenFormKey.currentState!.validate()) {
      // Save the event data
      events.add({
        'eventName': eventNameController.text.trim(),
        'eventBy': hostedByController.text.trim(),
        'date': dateController.text.trim(),
        'day': getDayFromDate(dateController.text.trim()),
        'endTime': endTimeController.text.trim(),
        'startTime': timeController.text.trim(),
        'isSelected': false,
      });

      // Show success dialog
      Get.dialog(
        AlertDialog(
          title: const Text('Success'),
          content: const Text('Event added successfully!'),
          actions: [
            TextButton(
              onPressed: () {
                Get.back(); // Close dialog
                clearFields(); // Clear fields after dialog closes
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }
   
  void removeEvent(int index) {
    if (index >= 0 && index < events.length) {
      events.removeAt(index);
      events.refresh(); // Update UI
    }
  }

  String getDayFromDate(String dateString, {String format = 'yyyy-MM-dd'}) {
    try {
      // Parse the date string using the specified format
      DateFormat dateFormat = DateFormat(format);
      DateTime date = dateFormat.parse(dateString);

      // Get the day of the week (1 = Monday, 2 = Tuesday, ..., 7 = Sunday)
      int dayOfWeek = date.weekday;

      // Map the weekday number to the day name
      List<String> daysOfWeek = [
        'Monday', // 1
        'Tuesday', // 2
        'Wednesday', // 3
        'Thursday', // 4
        'Friday', // 5
        'Saturday', // 6
        'Sunday' // 7
      ];

      // Return the corresponding day name
      return daysOfWeek[dayOfWeek - 1];
    } catch (e) {
      // Handle invalid date format
      return "Invalid date format. Please use the specified format (e.g., $format).";
    }
  }

// Validate if all fields are filled
  bool areExperienceFieldsFilled() {
    return eventNameController.text.trim().isNotEmpty &&
        hostedByController.text.trim().isNotEmpty &&
        dateController.text.trim().isNotEmpty &&
        timeController.text.trim().isNotEmpty;
  }

  // Clear all fields for the next event
  void clearFields() {
    eventNameController.clear();
    hostedByController.clear();
    dateController.clear();
    timeController.clear();
  }

  bool hasEvents() {
    return events.isNotEmpty;
  }

  //backend

  addExperience() async {
    try {
      loadingDialog();
      saveEvent();
      final addRestaurantTabController = Get.find<AddRestaurantTabController>();
      final restaurantID = addRestaurantTabController.currentRestaurantID;

      // 👇 Step 2: Prepare the data map
      final restaurantData = {
        'entertainmentScheduleList': events,
      };

      // 👇 Step 3: Update Firestore
      await FirebaseFirestore.instance
          .collection('restaurants')
          .doc(restaurantID)
          .update(restaurantData);

      // 👇 Step 4: UI updates
      Get.back();
      clearFields();
      addRestaurantTabController.selectedIndex.value++;
    } catch (e) {
      Get.back();
      Get.snackbar('Error', 'Failed to add amenities: $e');
      print('❌ Error adding amenities: $e');
    }
  }
}
