import 'package:flutter/cupertino.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:get/get_utils/src/get_utils/get_utils.dart';

class ContactUsController extends GetxController {
  // Dropdown value
  final contactingUs = Rx<String?>(null); // Changed to null

  var emailController = TextEditingController();
  var messagreController = TextEditingController();

  // Reactive variables for error handling
  var emailError = "".obs;
  var messageError = "".obs;
  var dropdownError = "".obs;
  final hasError = RxBool(false);

  // Validation logic for fields
  void validateFields(BuildContext context) {
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

    // Check if there are any errors
    hasError.value = dropdownError.value.isNotEmpty ||
        emailError.value.isNotEmpty ||
        messageError.value.isNotEmpty;

    // If no errors, pop the screen
    if (!hasError.value) {
      Navigator.pop(context); // Navigate back
    }
  }
}
