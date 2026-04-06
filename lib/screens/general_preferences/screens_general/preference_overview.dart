import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kaistable_website/constants/app_colors.dart';
import 'package:kaistable_website/screens/general_preferences/screens_general/preference_1.dart';
import 'package:kaistable_website/screens/general_preferences/screens_general/preference_2.dart';
import 'package:kaistable_website/screens/general_preferences/screens_general/preference_3.dart';
import 'package:kaistable_website/screens/general_preferences/screens_general/preference_4.dart';
import 'package:kaistable_website/screens/general_preferences/screens_general/preference_5.dart';
import 'package:kaistable_website/screens/general_preferences/screens_general/preference_6.dart';
import 'package:kaistable_website/screens/general_preferences/screens_general/preference_7.dart';
import 'package:kaistable_website/screens/general_preferences/screens_general/preference_8.dart';
import 'package:kaistable_website/screens/general_preferences/screens_general/preference_9.dart';
import 'package:kaistable_website/screens/general_preferences/screens_general/preference_14.dart';

class PreferenceOverviewScreen extends StatelessWidget {
  const PreferenceOverviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> preferences = [
      {
        'title': 'Favorite Cuisines',
        'question': 'What Are Your Top Three Favorite Cuisines?',
        'screen': () => Preference1(isSequential: false),
      },
      {
        'title': 'Dietary Preferences',
        'question':
            'Do You Follow Any Specific Dietary Preferences Or Restrictions?',
        'screen': () => Preference2(isSequential: false),
      },
      {
        'title': 'Choosing Restaurants',
        'question': 'How do you usually choose where to eat?',
        'screen': () => Preference3(isSequential: false),
      },
      {
        'title': 'Dining Style',
        'question': 'Are you more of a planner or a spontaneous diner?',
        'screen': () => Preference4(isSequential: false),
      },
      {
        'title': 'Importance Factors',
        'question': 'What\'s most important to you when dining out?',
        'screen': () => Preference5(isSequential: false),
      },
      {
        'title': 'Dining Experiences',
        'question': 'What kind of dining experiences do you enjoy the most?',
        'screen': () => Preference6(isSequential: false),
      },
      {
        'title': 'Travel Distance',
        'question':
            'How far are you willing to travel for a dining experience?',
        'screen': () => Preference7(isSequential: false),
      },
      {
        'title': 'Notification Types',
        'question': 'What type of notifications would you like to receive?',
        'screen': () => Preference8(isSequential: false),
      },
      {
        'title': 'Notification Frequency',
        'question': 'How often would you like to be notified?',
        'screen': () => Preference9(isSequential: false),
      },
      // {
      //   'title': 'Social Dining',
      //   'question': 'Do You Enjoy Social Dining Activities?',
      //   'screen': () => Preference10(isSequential: false),
      // },
      // {
      //   'title': 'Happy Hours',
      //   'question': 'Would You Like To Be Notified About Happy Hours?',
      //   'screen': () => Preference11(isSequential: false),
      // },
      // {
      //   'title': 'Live Music',
      //   'question': 'What’s Your Favorite Type Of Live Music?',
      //   'screen': () => Preference12(isSequential: false),
      // },
      // {
      //   'title': 'ZIP Code',
      //   'question': 'What ZIP Code Should We Use To Find Dining Deals?',
      //   'screen': () => Preference13(isSequential: false),
      // },
      {
        'title': 'Location Preference',
        'question': 'Which Location Do You Prefer?',
        'screen': () => Preference14(isSequential: false),
      },
    ];

    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: AppBar(
        backgroundColor: AppColors.bgColor,
        iconTheme: IconThemeData(color: AppColors.primaryColor),
        centerTitle: true,
        leading: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Container(
            height: 16,
            width: 16,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  spreadRadius: 1,
                  blurRadius: 3,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Icon(Icons.arrow_back, size: 18),
            ),
          ),
        ),
        title: Text(
          'Preference Overview',
          style: TextStyle(
            fontSize: 18 * (5 / 4),
            color: AppColors.bottomSheetColor,
            fontWeight: FontWeight.w700,
            fontFamily: GoogleFonts.plusJakartaSans().fontFamily,
          ),
        ),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: preferences.length,
        separatorBuilder: (context, index) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final pref = preferences[index];
          return Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 5,
                  spreadRadius: 0.1,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ListTile(
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              title: Text(
                pref['title'],
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  fontFamily: GoogleFonts.plusJakartaSans().fontFamily,
                  color: Colors.black87,
                ),
              ),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Text(
                  pref['question'],
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                    fontFamily: GoogleFonts.plusJakartaSans().fontFamily,
                  ),
                ),
              ),
              trailing: Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: AppColors.primaryColor,
              ),
              onTap: () => Get.to(pref['screen']),
            ),
          );
        },
      ),
    );
  }
}
