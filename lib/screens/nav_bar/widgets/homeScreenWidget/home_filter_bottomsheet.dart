import 'package:flutter/material.dart';
import 'package:kaistable_website/constants/app_colors.dart';

class HomeFilterBottomsheet extends StatelessWidget {
  final List<String> filters;
  final String title;
  final VoidCallback? onCancel;

  const HomeFilterBottomsheet({
    Key? key,
    required this.filters,
    this.title = 'Filters',
    this.onCancel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      height: MediaQuery.of(context).size.height * 0.8,
      child: Column(
        children: [
          // Header with title and cancel
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: AppColors.primaryColor,
                  fontFamily: 'NunitoSans-Bold',
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  if (onCancel != null) onCancel!();
                },
                child: const Text(
                  'Cancel',
                  style: TextStyle(
                    color: Colors.red,
                    fontFamily: 'NunitoSans-Bold',
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Main dynamic list
          Expanded(
            child: ListView.builder(
              itemCount: filters.length,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    ListTile(
                      title: Text(
                        filters[index],
                        style: const TextStyle(
                          fontSize: 16,
                          fontFamily: 'Nunito-regular',
                          color: AppColors.bottomSheetColor,
                        ),
                      ),
                    ),
                    const Divider(height: 1, color: AppColors.primaryColor),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
