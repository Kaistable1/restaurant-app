import 'package:flutter/material.dart';

import '../../../../constants/app_colors.dart';

class AdditionalInfoWidget extends StatelessWidget {
  AdditionalInfoWidget(
      {super.key,
      required this.desctiption,
      required this.date,
      required this.time,
      required this.phone});
  String desctiption;
  String date;
  String time;
  String phone;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Text(
              'Additional information',
              style: TextStyle(
                  fontFamily: 'Nunito-Sans',
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: AppColors.headingTextColor),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          InfoTile(
            title: 'Description',
            description: desctiption,
            iconPath: 'assets/images/description_icon.png',
          ),
          SizedBox(
            height: 20,
          ),
          InfoTile(
            title: 'Date',
            description: date,
            iconPath: 'assets/images/date_icon.png',
          ),
          SizedBox(
            height: 20,
          ),
          InfoTile(
            title: 'Time',
            description: time,
            iconPath: 'assets/images/time_icon.png',
          ),
          SizedBox(
            height: 20,
          ),
          InfoTile(
            title: 'Phone',
            description: phone,
            iconPath: 'assets/images/phone_icon.png',
          ),
        ],
      ),
    );
  }
}

class InfoTile extends StatelessWidget {
  final String title;
  final String description;
  final String iconPath;

  const InfoTile({
    super.key,
    required this.title,
    required this.description,
    required this.iconPath,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 2.0),
            child: Image.asset(
              iconPath,
              height: 16,
              width: 16,
            ),
          ),
          const SizedBox(width: 10),

          /// Wrap text and icon in Expanded to align properly
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: AppColors.headingTextColor,
                    fontFamily: 'Nunito-Sans ',
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4), // Adjust spacing
                Text(
                  description,
                  style: TextStyle(
                    color: AppColors.textNormalColor,
                    fontFamily: 'Nunito-Regular',
                    fontWeight: FontWeight.w400,
                    fontSize: 12,
                  ),
                  softWrap: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
