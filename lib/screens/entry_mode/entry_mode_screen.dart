import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kaistable_website/constants/app_colors.dart';
import 'package:kaistable_website/screens/nav_bar/main_screen.dart';
import 'package:kaistable_website/widgets/custom_button.dart';

class EntryModeScreen extends StatefulWidget {
  const EntryModeScreen({super.key});

  @override
  State<EntryModeScreen> createState() => _EntryModeScreenState();
}

class _EntryModeScreenState extends State<EntryModeScreen> {
  String? _selectedMode;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            children: [
              const SizedBox(height: 60),
              // Title
              Text(
                'How do you want to explore?',
                style: TextStyle(
                  fontSize: 24 * (5/4),
                  fontWeight: FontWeight.w600,
                  color: AppColors.blackColor,
                  fontFamily: GoogleFonts.plusJakartaSans().fontFamily,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              // Subtitle
              Text(
                'Choose your starting point, you can switch anytime.',
                style: TextStyle(
                  fontSize: 16 * (5/4),
                  fontWeight: FontWeight.w400,
                  color: AppColors.blackColor,
                  fontFamily: GoogleFonts.plusJakartaSans().fontFamily,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 48),
              // Ask Kai (AI Mode) option
              _ModeOption(
                title: 'Ask Kai (AI Mode)',
                description: 'Chat with Savrli AI and get instant suggestions.',
                isSelected: _selectedMode == 'ai',
                onTap: () {
                  setState(() {
                    _selectedMode = 'ai';
                  });
                },
              ),
              const SizedBox(height: 86),
              // Explore the Community option
              _ModeOption(
                title: 'Explore the Community',
                description: 'See the map, explore vibes, and connect with people.',
                isSelected: _selectedMode == 'community',
                onTap: () {
                  setState(() {
                    _selectedMode = 'community';
                  });
                },
              ),
              const Spacer(),
              // OK, let's go button
              CustomButton(
                laBelText: 'OK, let\'s go!',
                fontSize: 16 * (5/4),
                fontWeight: FontWeight.w600,
                fontFamily: GoogleFonts.plusJakartaSans().fontFamily,
                textColor: AppColors.blackColor,
                containerColor: Color(0xFFF5F5F5), // Light grey/off-white
                width: 160,
                height: 48,
                radius: BorderRadius.circular(99),
                ontapp: () {
                  if (_selectedMode != null) {
                    // If Ask Kai is selected, start on tab index 1 (Ask Kai tab)
                    // If Explore Community is selected, start on tab index 0 (Home tab)
                    int initialTabIndex = _selectedMode == 'ai' ? 1 : 0;
                    Get.offAll(() => MainScreen(initialTabIndex: initialTabIndex));
                  }
                },
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}

// Mode option widget
class _ModeOption extends StatelessWidget {
  final String title;
  final String description;
  final bool isSelected;
  final VoidCallback onTap;

  const _ModeOption({
    required this.title,
    required this.description,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            // width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            decoration: BoxDecoration(
              color: isSelected ? Color(0xFFEB8C1F) : Colors.white, // Orange when selected, white when not
              borderRadius: BorderRadius.circular(99),
              border: Border.all(
                color: isSelected ? Color(0xFFEB8C1F) : Color(0xFFEB8C1F),
                width: isSelected ? 2 : 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(isSelected ? 0.15 : 0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Text(
              title,
              style: TextStyle(
                fontSize: 18 * (5/4),
                fontWeight: FontWeight.w700,
                fontFamily: GoogleFonts.plusJakartaSans().fontFamily,
                color: isSelected ? Colors.white : AppColors.blackColor,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          description,
          style: TextStyle(
            fontSize: 16 * (5/4),
            fontWeight: FontWeight.w400,
            fontFamily: GoogleFonts.plusJakartaSans().fontFamily,
            color: AppColors.blackColor,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

