import 'package:flutter/material.dart';

import '../../../../constants/app_colors.dart';

class AdditionalInfoWidget extends StatelessWidget {
  const AdditionalInfoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Text('Additional information',
              style: TextStyle(
                  fontFamily: 'Nunito-Sans',
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: AppColors.headingTextColor
              ),
            ),
          ),
          SizedBox(height: 10,),
          InfoTile(
            title: 'Description',
            description: 'Come to The Culinary Haven for an exclusive tasting experience crafted by chef Luca Romano! Savor live tunes and connect with other food enthusiasts on Saturday, ',
            iconPath: 'assets/images/description_icon.png',
          ),
          SizedBox(height: 20,),
          InfoTile(
            title: 'Date',
            description: '12/3/2024',
            iconPath: 'assets/images/date_icon.png',
          ),
          SizedBox(height: 20,),
          InfoTile(
            title: 'Time',
            description: '9:00 AM to 5:00 PM',
            iconPath: 'assets/images/time_icon.png',
          ),
          SizedBox(height: 20,),
          InfoTile(
            title: 'Phone',
            description: '(555) 123-4567. ',
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

