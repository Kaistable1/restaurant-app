import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kaistable_website/constants/app_colors.dart';
import 'package:kaistable_website/screens/auth_screens/signup/signup_screen.dart';
import 'package:kaistable_website/widgets/custom_button.dart';
import '../../main.dart';

class HighlightsScreen extends StatefulWidget {
  const HighlightsScreen({super.key});

  @override
  State<HighlightsScreen> createState() => _HighlightsScreenState();
}

class _HighlightsScreenState extends State<HighlightsScreen> {
  int _currentIndex = 0;

  final List<Map<String, String>> _screens = [
    {
      'title': 'Ask Kai Anything',
      'subtitle': 'Get real-time answer and\nupdate dinner plans on the fly.',
    },
    {
      'title': 'Find Your Tribe',
      'subtitle': 'Explore food shows, creator videos, and real stories from your favorite cities.',
    },
    {
      'title': 'Watch The City\nCome Alive',
      'subtitle': 'Build your trip and access\nbookings all in one place.',
    },
    {
      'title': 'See Whats Happening\nAround You',
      'subtitle': 'Build your trip and access\nbookings all in one place.',
    },
  ];

  void _nextScreen() async {
    if (_currentIndex < _screens.length - 1) {
      setState(() {
        _currentIndex++;
      });
    } else {
      // User has finished viewing all highlights
      // Mark that they've seen the highlights so they won't see it again
      await preferences?.setBool('hasSeenHighlights', true);
      
      Get.offAll(() => SignupScreen(fromScreen: 'highlights'));
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentScreen = _screens[_currentIndex];

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Column(
            children: [
              // Fixed height gradient container (60% of screen)
              Expanded(
                flex: 8,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(bottomLeft: Radius.circular(30), bottomRight: Radius.circular(30)),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        const Color(0xFFB0E0E6), // Light blue-green at top
                        const Color(0xFF4ECCA3), // Darker green at bottom
                      ],
                    ),
                  ),
                  child: Align(
                    alignment: const Alignment(0, 0.5), // Center horizontally, 75% down vertically (halfway between center and bottom)
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: List.generate(
                        _screens.length,
                        (index) => Container(
                          width: 8,
                          height: 8,
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: index == _currentIndex
                                ? Colors.white
                                : Colors.grey.shade300,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              // Main content card with rounded bottom corners
              Expanded(
                flex: 4,
                child: Container(
                  width: Get.width,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24.0,
                      vertical: 40.0,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Title
                        Text(
                          currentScreen['title']!,
                          style: TextStyle(
                            fontSize: 32 * (5/4),
                            fontWeight: FontWeight.w600,
                            color: AppColors.blackColor,
                            fontFamily: GoogleFonts.plusJakartaSans().fontFamily,
                            height: 0.9, // Reduced line spacing for tighter line height
                          ),
                          textAlign: TextAlign.center,
                        ),

                        const SizedBox(height: 16),

                        // Subtitle
                        Text(
                          currentScreen['subtitle']!,
                          style: TextStyle(
                            fontSize: 20 * (5/4),
                            fontWeight: FontWeight.w400,
                            color: AppColors.blackColor,
                            fontFamily: GoogleFonts.plusJakartaSans().fontFamily,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          // Fixed button at the bottom
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.only(left: 24, right: 24, top: 28, bottom: 40),
              decoration: const BoxDecoration(
                color: Colors.white,
              ),
              child: CustomButton(
                laBelText: _currentIndex == _screens.length - 1 ? 'Get Started' : 'Next',
                fontSize: 16 * (5/4),
                fontWeight: FontWeight.w600,
                fontFamily: GoogleFonts.plusJakartaSans().fontFamily,
                textColor: AppColors.whiteColor,
                containerColor: AppColors.primaryColor, // AppColors.blackColor,
                width: Get.width * 0.9,
                height: 44,
                radius: BorderRadius.circular(99),
                ontapp: _nextScreen,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

