import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ExperiencesSubScreenController extends GetxController {
  // Text controllers for each field
  final eventNameController = TextEditingController();
  final hostedByController = TextEditingController();
  final dateController = TextEditingController();
  final timeController = TextEditingController();

  final experienceSubScreenFormKey = GlobalKey<FormState>();

  // Observable for dropdown and stored events
  RxString selectedDay = ''.obs;
  RxList<Map<String, dynamic>> events = <Map<String, dynamic>>[].obs;

  RxList<String> dayList =
      <String>[
        'Monday',
        'Tuesday',
        'Wednesday',
        'Thursday',
        'Friday',
        'Saturday',
        'Sunday',
      ].obs;

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

  // Save event and clear fields
  void saveEvent() {
    if (experienceSubScreenFormKey.currentState!.validate()) {

      // Save the event data
      events.add({
        'eventName': eventNameController.text.trim(),
        'hostedBy': hostedByController.text.trim(),
        'state': selectedDay.value,
        'date': dateController.text.trim(),
        'time': timeController.text.trim(),
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

  // Clear all fields for the next event
  void clearFields() {
    eventNameController.clear();
    hostedByController.clear();
    selectedDay.value = '';
    dateController.clear();
    timeController.clear();
  }
  bool hasEvents() {
    return events.isNotEmpty;
  }
}
