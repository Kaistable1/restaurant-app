import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kaistable_website/constants/app_colors.dart';
import 'package:kaistable_website/models/report_model.dart';
import 'package:kaistable_website/services/moderation_service.dart';
import 'package:intl/intl.dart';

class AdminModerationScreen extends StatefulWidget {
  const AdminModerationScreen({Key? key}) : super(key: key);

  @override
  State<AdminModerationScreen> createState() => _AdminModerationScreenState();
}

class _AdminModerationScreenState extends State<AdminModerationScreen> {
  final ModerationService _moderationService = ModerationService();
  String _selectedFilter = 'pending';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: AppBar(
        backgroundColor: AppColors.whiteColor,
        title: Text(
          'Content Moderation',
          style: TextStyle(
            fontSize: 17,
            color: AppColors.bottomSheetColor,
            fontWeight: FontWeight.w700,
            fontFamily: 'Nunito-Bold',
          ),
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(50),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                _buildFilterChip('Pending', 'pending'),
                SizedBox(width: 8),
                _buildFilterChip('Reviewed', 'reviewed'),
                SizedBox(width: 8),
                _buildFilterChip('All', 'all'),
              ],
            ),
          ),
        ),
      ),
      body: StreamBuilder<List<ReportModel>>(
        stream: _selectedFilter == 'all'
            ? _moderationService.getAllReports()
            : _moderationService.getAllReports(status: _selectedFilter),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return _buildEmptyState();
          }

          return ListView.builder(
            padding: EdgeInsets.all(12),
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              return _buildReportCard(snapshot.data![index]);
            },
          );
        },
      ),
    );
  }

  Widget _buildFilterChip(String label, String value) {
    final isSelected = _selectedFilter == value;
    return InkWell(
      onTap: () {
        setState(() {
          _selectedFilter = value;
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryColor : Colors.grey[200],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black,
            fontFamily: 'Nunito-Bold',
            fontSize: 12,
          ),
        ),
      ),
    );
  }

  Widget _buildReportCard(ReportModel report) {
    return Card(
      margin: EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        report.reason ?? 'No reason',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Nunito-Bold',
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Reported by: ${report.reportedByUserName ?? 'Unknown'}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                          fontFamily: 'Nunito-Regular',
                        ),
                      ),
                    ],
                  ),
                ),
                _buildStatusBadge(report.status ?? 'pending'),
              ],
            ),
            SizedBox(height: 12),
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInfoRow('Content Type', report.contentType ?? 'Unknown'),
                  _buildInfoRow('Reported User', report.reportedUserName ?? 'Unknown'),
                  if (report.description != null && report.description!.isNotEmpty)
                    _buildInfoRow('Description', report.description!),
                  _buildInfoRow('Date', _formatDate(report.createdAt)),
                  if (report.aiModerated == true)
                    Row(
                      children: [
                        Icon(Icons.smart_toy, size: 14, color: AppColors.primaryColor),
                        SizedBox(width: 4),
                        Text(
                          'AI Moderated',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.primaryColor,
                            fontFamily: 'Nunito-Bold',
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
            if (report.status == 'pending') ...[
              SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => _showReviewDialog(report, 'dismissed'),
                    child: Text(
                      'Dismiss',
                      style: TextStyle(
                        color: Colors.grey,
                        fontFamily: 'Nunito-Bold',
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () => _showReviewDialog(report, 'resolved'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryColor,
                    ),
                    child: Text(
                      'Take Action',
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Nunito-Bold',
                      ),
                    ),
                  ),
                ],
              ),
            ],
            if (report.status != 'pending' && report.resolution != null) ...[
              SizedBox(height: 12),
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Resolution:',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Nunito-Bold',
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      report.resolution!,
                      style: TextStyle(
                        fontSize: 12,
                        fontFamily: 'Nunito-Regular',
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    Color color;
    switch (status) {
      case 'pending':
        color = Colors.orange;
        break;
      case 'resolved':
        color = Colors.green;
        break;
      case 'dismissed':
        color = Colors.grey;
        break;
      default:
        color = Colors.blue;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        status.toUpperCase(),
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.bold,
          fontFamily: 'Nunito-Bold',
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                fontFamily: 'Nunito-Bold',
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 12,
                fontFamily: 'Nunito-Regular',
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'Unknown';
    return DateFormat('MMM d, yyyy h:mm a').format(date);
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.check_circle_outline,
            size: 80,
            color: Colors.grey[300],
          ),
          SizedBox(height: 16),
          Text(
            'No reports to review',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
              fontFamily: 'Nunito-Bold',
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showReviewDialog(ReportModel report, String status) async {
    final resolutionController = TextEditingController();

    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          status == 'resolved' ? 'Take Action' : 'Dismiss Report',
          style: TextStyle(fontFamily: 'Nunito-Bold'),
        ),
        content: TextField(
          controller: resolutionController,
          maxLines: 3,
          decoration: InputDecoration(
            hintText: 'Enter resolution notes...',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          style: TextStyle(fontFamily: 'Nunito-Regular'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryColor,
            ),
            child: Text(
              'Submit',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );

    if (result == true) {
      final success = await _moderationService.reviewReport(
        report.reportID!,
        resolutionController.text,
        status,
      );

      if (success) {
        Get.snackbar(
          'Success',
          'Report has been reviewed',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      }
    }
  }
}
