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
  RxBool isEditing = false.obs;
  RxInt editingIndex = (-1).obs;

  @override
  void onClose() {
    eventNameController.dispose();
    hostedByController.dispose();
    dateController.dispose();
    timeController.dispose();
    endTimeController.dispose();
    super.onClose();
  }

  // Select date using DatePicker
  selectDate(BuildContext context) async {
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
  selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      timeController.text = picked.format(context);
    }
  }

  selectEndTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      endTimeController.text = picked.format(context);
    }
  }

  // Save event (add or update)
  void saveEvent() {
    if (experienceSubScreenFormKey.currentState!.validate()) {
      final event = {
        'eventName': eventNameController.text.trim(),
        'eventBy': hostedByController.text.trim(),
        'date': dateController.text.trim(),
        'day': getDayFromDate(dateController.text.trim()),
        'endTime': endTimeController.text.trim(),
        'startTime': timeController.text.trim(),
        'isSelected': false,
      };

      if (isEditing.value) {
        // Update existing event
        events[editingIndex.value] = event;
        Get.dialog(
          AlertDialog(
            title: const Text('Success'),
            content: const Text('Event updated successfully!'),
            actions: [
              TextButton(
                onPressed: () {
                  Get.back();
                  clearFields();
                },
                child: const Text('OK'),
              ),
            ],
          ),
        );
      } else {
        // Add new event
        events.add(event);
        Get.dialog(
          AlertDialog(
            title: const Text('Success'),
            content: const Text('Event added successfully!'),
            actions: [
              TextButton(
                onPressed: () {
                  Get.back();
                  clearFields();
                },
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    }
  }

  // Edit an existing event
  void editEvent(int index) {
    if (index >= 0 && index < events.length) {
      final event = events[index];
      eventNameController.text = event['eventName'] ?? '';
      hostedByController.text = event['eventBy'] ?? '';
      dateController.text = event['date'] ?? '';
      timeController.text = event['startTime'] ?? '';
      endTimeController.text = event['endTime'] ?? '';
      isEditing.value = true;
      editingIndex.value = index;
    }
  }

  // Cancel editing
  void cancelEdit() {
    clearFields();
  }

  // Remove an event
  void removeEvent(int index) {
    if (index >= 0 && index < events.length) {
      events.removeAt(index);
      events.refresh();
      if (isEditing.value && editingIndex.value == index) {
        clearFields();
      }
      Get.snackbar('Success', 'Event deleted successfully',
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  // Get day of the week from date
  String getDayFromDate(String dateString, {String format = 'dd MMMM yyyy'}) {
    try {
      DateFormat dateFormat = DateFormat(format);
      DateTime date = dateFormat.parse(dateString);
      int dayOfWeek = date.weekday;
      List<String> daysOfWeek = [
        'Monday',
        'Tuesday',
        'Wednesday',
        'Thursday',
        'Friday',
        'Saturday',
        'Sunday'
      ];
      return daysOfWeek[dayOfWeek - 1];
    } catch (e) {
      return "Invalid date format. Please use the specified format (e.g., $format).";
    }
  }

  // Validate if all fields are filled
  bool areExperienceFieldsFilled() {
    return eventNameController.text.trim().isNotEmpty &&
        hostedByController.text.trim().isNotEmpty &&
        dateController.text.trim().isNotEmpty &&
        timeController.text.trim().isNotEmpty &&
        endTimeController.text.trim().isNotEmpty;
  }

  // Clear all fields and reset editing state
  void clearFields() {
    eventNameController.clear();
    hostedByController.clear();
    dateController.clear();
    timeController.clear();
    endTimeController.clear();
    isEditing.value = false;
    editingIndex.value = -1;
  }

  // Clear everything including events list (use when completely exiting add/edit flow)
  void clearAll() {
    clearFields();
    events.clear();
  }

  bool hasEvents() {
    return events.isNotEmpty;
  }

  // Save events to Firestore
  addExperience() async {
    try {
      loadingDialog();
      final addRestaurantTabController = Get.find<AddRestaurantTabController>();
      final restaurantID = addRestaurantTabController.restaurantModel!.docID;

      // Prepare the data map
      final restaurantData = {
        'entertainmentScheduleList': events.toList(),
      };

      // Update Firestore
      await FirebaseFirestore.instance
          .collection('restaurants')
          .doc(restaurantID)
          .update(restaurantData);

      // UI updates
      Get.back();
      addRestaurantTabController.selectedIndex.value++;
    } catch (e) {
      Get.back();
      Get.snackbar('Error', 'Failed to save events: $e',
          snackPosition: SnackPosition.BOTTOM);
      print('❌ Error saving events: $e');
    }
  }
}
