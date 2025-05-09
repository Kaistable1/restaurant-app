import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../constants/app_colors.dart';
import '../../../constants/text_styles.dart';
import '../../../controllers/restaurant_management_controller.dart';

class FeatureDescriptionDialog extends StatefulWidget {
  final VoidCallback? onCancel;
  final String initialDescription;
  final Function(String) onSubmit;

  const FeatureDescriptionDialog({
    super.key,
    this.onCancel,
    required this.initialDescription,
    required this.onSubmit,
  });

  @override
  State<FeatureDescriptionDialog> createState() =>
      _FeatureDescriptionDialogState();
}

class _FeatureDescriptionDialogState extends State<FeatureDescriptionDialog> {
  late final TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    // Initialize a local TextEditingController with the initialDescription
    _descriptionController =
        TextEditingController(text: widget.initialDescription);
  }

  @override
  void dispose() {
    // Dispose of the local TextEditingController to prevent memory leaks
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    bool mobileView = screenWidth < 1000;
    double dialogTextSize = mobileView ? 14 : 20;
    double buttonTextSize = mobileView ? 12 : 16;
    // Define dialog dimensions
    double dialogWidth = mobileView ? screenWidth * 0.8 : screenWidth * 0.4;

    return AlertDialog(
      backgroundColor: Colors.white,
      title: Text(
        'Add Featured Description',
        style: simpleText.copyWith(
          fontSize: dialogTextSize,
          fontWeight: FontWeight.w800,
        ),
      ),
      content: SizedBox(
        width: dialogWidth,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _descriptionController, // Use local controller
              decoration: InputDecoration(
                hintText: 'Enter description',
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: primaryColor),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: primaryColor, width: 1),
                ),
                hintStyle: simpleText.copyWith(
                  color: Colors.grey,
                  fontSize: dialogTextSize - 3,
                ),
              ),
              maxLines: 5,
              style: simpleText.copyWith(fontSize: dialogTextSize - 3),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            widget.onCancel?.call();
            Navigator.of(context).pop();
          },
          child: Text(
            'Cancel',
            style: simpleText.copyWith(
              fontSize: buttonTextSize,
              color: Colors.grey,
            ),
          ),
        ),
        TextButton(
          onPressed: () {
            if (_descriptionController.text.trim().isNotEmpty) {
              widget.onSubmit(_descriptionController.text.trim());
              Navigator.of(context).pop();
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Please enter a description'),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          child: Text(
            'Submit',
            style: simpleText.copyWith(
              fontSize: buttonTextSize,
              color: primaryColor,
            ),
          ),
        ),
      ],
    );
  }
}
