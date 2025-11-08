import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:kaistable_website/constants/app_colors.dart';
import 'package:kaistable_website/models/report_model.dart';
import 'package:kaistable_website/services/moderation_service.dart';
import 'package:kaistable_website/services/ai_moderation_service.dart';
import 'package:kaistable_website/main.dart';

class ReportDialog extends StatefulWidget {
  final String contentID;
  final String contentType;
  final String reportedUserID;
  final String reportedUserName;

  const ReportDialog({
    Key? key,
    required this.contentID,
    required this.contentType,
    required this.reportedUserID,
    required this.reportedUserName,
  }) : super(key: key);

  @override
  State<ReportDialog> createState() => _ReportDialogState();
}

class _ReportDialogState extends State<ReportDialog> {
  final ModerationService _moderationService = ModerationService();
  final AIModerationService _aiModerationService = AIModerationService();
  final TextEditingController _descriptionController = TextEditingController();
  String _selectedReason = 'Spam';
  bool _isSubmitting = false;

  final List<String> _reportReasons = [
    'Spam',
    'Harassment',
    'Inappropriate Content',
    'Hate Speech',
    'Violence',
    'False Information',
    'Other',
  ];

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'Report Content',
        style: TextStyle(
          fontFamily: 'Nunito-Bold',
          fontSize: 18,
        ),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Why are you reporting this?',
              style: TextStyle(
                fontFamily: 'Nunito-Bold',
                fontSize: 14,
              ),
            ),
            SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: _selectedReason,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
              items: _reportReasons.map((reason) {
                return DropdownMenuItem(
                  value: reason,
                  child: Text(
                    reason,
                    style: TextStyle(fontFamily: 'Nunito-Regular'),
                  ),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedReason = value!;
                });
              },
            ),
            SizedBox(height: 16),
            Text(
              'Additional Details (Optional)',
              style: TextStyle(
                fontFamily: 'Nunito-Bold',
                fontSize: 14,
              ),
            ),
            SizedBox(height: 8),
            TextField(
              controller: _descriptionController,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: 'Provide more context...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding: EdgeInsets.all(12),
              ),
              style: TextStyle(fontFamily: 'Nunito-Regular'),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isSubmitting ? null : () => Navigator.pop(context),
          child: Text(
            'Cancel',
            style: TextStyle(fontFamily: 'Nunito-Regular'),
          ),
        ),
        ElevatedButton(
          onPressed: _isSubmitting ? null : _submitReport,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryColor,
          ),
          child: _isSubmitting
              ? SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              : Text(
                  'Submit',
                  style: TextStyle(
                    fontFamily: 'Nunito-Bold',
                    color: Colors.white,
                  ),
                ),
        ),
      ],
    );
  }

  Future<void> _submitReport() async {
    setState(() {
      _isSubmitting = true;
    });

    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        Get.snackbar(
          'Error',
          'Please login to report content',
          snackPosition: SnackPosition.BOTTOM,
        );
        setState(() {
          _isSubmitting = false;
        });
        return;
      }

      // Run AI moderation on the description
      ModerationResult? aiResult;
      if (_descriptionController.text.isNotEmpty) {
        aiResult = await _aiModerationService.moderateContent(_descriptionController.text);
      }

      final report = ReportModel(
        reportedByUserID: currentUser.uid,
        reportedByUserName: currentUserDataModel?.value.username.text ?? 'Unknown',
        reportedUserID: widget.reportedUserID,
        reportedUserName: widget.reportedUserName,
        contentID: widget.contentID,
        contentType: widget.contentType,
        reason: _selectedReason,
        description: _descriptionController.text,
        aiModerated: aiResult != null,
        aiModerationResult: aiResult?.toJson().toString(),
      );

      final reportID = await _moderationService.submitReport(report);

      if (reportID != null) {
        Navigator.pop(context);
        Get.snackbar(
          'Success',
          'Report submitted successfully. We will review it shortly.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        Get.snackbar(
          'Error',
          'Failed to submit report. Please try again.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'An error occurred: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      setState(() {
        _isSubmitting = false;
      });
    }
  }
}
