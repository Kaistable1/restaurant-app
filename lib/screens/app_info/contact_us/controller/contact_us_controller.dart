import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:get/get_utils/src/get_utils/get_utils.dart';

class ContactUsController extends GetxController {
  RxString selectedTop = 'most reviewed'.obs;
  // Dropdown value
  var contactingUs = Rxn<String>(); // Nullable reactive string for dropdown

  // Controllers for email and message text fields
  var emailController = TextEditingController();
  var messagreController = TextEditingController();

  var adminEmailController = TextEditingController();
  var adminPhone = TextEditingController();

  void resetErrors() {
    emailError.value = '';
    messageError.value = '';
    dropdownError.value = '';
  }

  // Reactive variables for error handling
  var dropdownError = "".obs;
  var emailError = "".obs;
  var messageError = "".obs;

  // Reactive variable for dropdown open state
  var isDropdownOpen = false.obs;

  // Reactive boolean to track form errors
  final hasError = false.obs;
  void validateFields() {
    // Dropdown validation
    if (contactingUs.value == null || contactingUs.value!.isEmpty) {
      dropdownError.value = "Please select a reason for contacting us";
    } else {
      dropdownError.value = '';
    }

    // Email validation
    if (emailController.text.isEmpty) {
      emailError.value = "Please enter your email";
    } else if (!GetUtils.isEmail(emailController.text)) {
      emailError.value = "Please enter a valid email";
    } else {
      emailError.value = '';
    }

    // Message validation
    if (messagreController.text.isEmpty) {
      messageError.value = "Please enter a message";
    } else {
      messageError.value = '';
    }
  }

  // Validation logic for fields
  void validatemyFields() {
    // Dropdown validation
    if (contactingUs.value == null) {
      dropdownError.value = "Please select a reason for contacting us";
    } else {
      dropdownError.value = '';
    }

    // Email validation
    if (emailController.text.isEmpty) {
      emailError.value = "Please enter your email";
    } else if (!GetUtils.isEmail(emailController.text)) {
      emailError.value = "Please enter a valid email";
    } else {
      emailError.value = '';
    }

    // Message validation
    if (messagreController.text.isEmpty) {
      messageError.value = "Please enter a message";
    } else {
      messageError.value = '';
    }

    // Check if any validation errors are present
    hasError.value = dropdownError.value.isNotEmpty ||
        emailError.value.isNotEmpty ||
        messageError.value.isNotEmpty;
  }

  // Firestore se email aur phone number fetch karna
  Future<void> loadContactInfo() async {
    try {
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('contact_us')
          .doc('current') // <-- replace with your doc ID if different
          .get();

      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>;
        adminEmailController.text = data['email'] ?? '';
        adminPhone.text = data['phone'] ?? ''; // ya kisi aur field mein message
      }
      print('adminEmail : ${adminEmailController.text}');
      print('adminPhone : ${adminPhone.text}');
    } catch (e) {
      print("Failed to load contact info: $e");
    }
  }

  @override
  void onInit() {
    super.onInit();
    loadContactInfo(); // Load contact info when the controller is initialized
  }
}
