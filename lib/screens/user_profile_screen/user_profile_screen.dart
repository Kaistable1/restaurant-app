import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kaistable_website/constants/app_colors.dart';
import 'package:kaistable_website/services/moderation_service.dart';
import 'package:kaistable_website/screens/trending_screen/widgets/report_dialog.dart';

/// Screen for viewing another user's profile with block/report options
class UserProfileScreen extends StatefulWidget {
  final String userID;
  final String userName;
  final String? userImage;
  final String? userEmail;

  const UserProfileScreen({
    Key? key,
    required this.userID,
    required this.userName,
    this.userImage,
    this.userEmail,
  }) : super(key: key);

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  final ModerationService _moderationService = ModerationService();
  bool _isBlocked = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _checkBlockStatus();
  }

  Future<void> _checkBlockStatus() async {
    final blocked = await _moderationService.isUserBlocked(widget.userID);
    setState(() {
      _isBlocked = blocked;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: AppBar(
        backgroundColor: AppColors.whiteColor,
        title: Text(
          'User Profile',
          style: TextStyle(
            fontSize: 17,
            color: AppColors.bottomSheetColor,
            fontWeight: FontWeight.w700,
            fontFamily: 'Nunito-Bold',
          ),
        ),
        actions: [
          PopupMenuButton<String>(
            icon: Icon(Icons.more_vert, color: AppColors.bottomSheetColor),
            onSelected: (value) {
              if (value == 'report') {
                _showReportDialog();
              } else if (value == 'block') {
                _toggleBlock();
              }
            },
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem(
                  value: 'report',
                  child: Row(
                    children: [
                      Icon(Icons.flag, color: Colors.red, size: 20),
                      SizedBox(width: 8),
                      Text('Report User'),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: 'block',
                  child: Row(
                    children: [
                      Icon(
                        _isBlocked ? Icons.check_circle : Icons.block,
                        color: _isBlocked ? Colors.green : Colors.red,
                        size: 20,
                      ),
                      SizedBox(width: 8),
                      Text(_isBlocked ? 'Unblock User' : 'Block User'),
                    ],
                  ),
                ),
              ];
            },
          ),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 24),
                  // User Avatar
                  CircleAvatar(
                    radius: 50,
                    backgroundImage:
                        widget.userImage != null && widget.userImage!.isNotEmpty
                            ? NetworkImage(widget.userImage!)
                            : null,
                    child: widget.userImage == null || widget.userImage!.isEmpty
                        ? Icon(Icons.person, size: 50)
                        : null,
                  ),
                  SizedBox(height: 16),
                  // User Name
                  Text(
                    widget.userName,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Nunito-Bold',
                    ),
                  ),
                  SizedBox(height: 8),
                  // User Email
                  if (widget.userEmail != null)
                    Text(
                      widget.userEmail!,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                        fontFamily: 'Nunito-Regular',
                      ),
                    ),
                  SizedBox(height: 24),
                  // Blocked Status
                  if (_isBlocked)
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 20),
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.red[50],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.red[200]!),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.block, color: Colors.red),
                          SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'You have blocked this user. You won\'t see their posts or interact with them.',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.red[900],
                                fontFamily: 'Nunito-Regular',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  SizedBox(height: 24),
                  // User Stats/Info could go here
                  _buildInfoSection(),
                ],
              ),
            ),
    );
  }

  Widget _buildInfoSection() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'About',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              fontFamily: 'Nunito-Bold',
            ),
          ),
          SizedBox(height: 12),
          Text(
            'This is a user profile screen where you can view user information and take moderation actions.',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[700],
              fontFamily: 'Nunito-Regular',
            ),
          ),
        ],
      ),
    );
  }

  void _showReportDialog() {
    showDialog(
      context: context,
      builder: (context) => ReportDialog(
        contentID: widget.userID,
        contentType: 'profile',
        reportedUserID: widget.userID,
        reportedUserName: widget.userName,
      ),
    );
  }

  Future<void> _toggleBlock() async {
    if (_isBlocked) {
      // Unblock
      final success = await _moderationService.unblockUser(widget.userID);
      if (success) {
        setState(() {
          _isBlocked = false;
        });
        Get.snackbar(
          'Success',
          'User unblocked',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      }
    } else {
      // Block
      final blockID = await _moderationService.blockUser(
        widget.userID,
        widget.userName,
        reason: 'Blocked from profile',
      );
      if (blockID != null) {
        setState(() {
          _isBlocked = true;
        });
        Get.snackbar(
          'Success',
          'User blocked successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      }
    }
  }
}
