import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../constants/app_colors.dart';
import '../../../constants/text_styles.dart';
import '../../../controllers/drawer_controller.dart';
import '../../../widgets/customheader_widget.dart';

class UserDetailsScreen extends StatelessWidget {
  UserDetailsScreen({super.key});

  final drawerController = Get.put(DrawerControllerX());

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    bool mobileView = screenWidth < 1000;
    double paddingValue = mobileView ? 16 : 24;

    // User Profile Widget
    Widget userProfileContainer = Container(
      width: mobileView ? screenWidth * 0.25 : screenWidth * 0.15,
      // height: mobileView ? screenHeight * 0.20 : screenHeight * 0.26,
      padding: const EdgeInsets.symmetric(horizontal: 23, vertical: 27),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Round Profile Image
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: const DecorationImage(
                image: AssetImage('assets/images/profile___imgg.png'),
                // Replace with actual image URL
                fit: BoxFit.fill,
              ),
            ),
          ),
          const SizedBox(height: 12),
          // Name with Heading
          ProfileTextWidget(
            mobileView: mobileView,
            screenWidth: screenWidth,
            subtitle: 'John Doe',
            title: 'Name',
          ),

          const SizedBox(height: 8),
          ProfileTextWidget(
            mobileView: mobileView,
            screenWidth: screenWidth,
            subtitle: 'john.doe@example.com',
            title: 'Email',
          ),
        ],
      ),
    );

    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(paddingValue),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomHeaderWidget(
              back: true,
              onBackTap: () {
                drawerController.userDetails.value = false;
              },
              title: 'User Details',
            ),
            const SizedBox(height: 16),
            // Show profile container above Preferences on mobile
            if (mobileView) ...[
              userProfileContainer,
              const SizedBox(height: 16),
            ],
            Text(
              'Preferences',
              style: headingText.copyWith(fontSize: mobileView ? 16 : 20),
            ),
            const SizedBox(height: 16),
            // Row for Questions 1, 2 and Profile on larger screens
            mobileView
                ? Column(
                  children: [
                    QuestionAnswerWidget(
                      questionNumber: 1,
                      question: "What Are Your Top Three Favorite Cuisines?",
                      answers: ["Vegetarian", "Caribbean", "Chinese"],
                      mobileView: mobileView,
                    ),
                    QuestionAnswerWidget(
                      questionNumber: 2,
                      question:
                          "Do You Follow Any Specific Dietary Preferences Or Restrictions?",
                      answers: ["Vegan & Plant-Based"],
                      mobileView: mobileView,
                    ),
                  ],
                )
                : Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          QuestionAnswerWidget(
                            questionNumber: 1,
                            question:
                                "What Are Your Top Three Favorite Cuisines?",
                            answers: ["Vegetarian", "Caribbean", "Chinese"],
                            mobileView: mobileView,
                          ),
                          QuestionAnswerWidget(
                            questionNumber: 2,
                            question:
                                "Do You Follow Any Specific Dietary Preferences Or Restrictions?",
                            answers: ["Vegan & Plant-Based"],
                            mobileView: mobileView,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    userProfileContainer,
                  ],
                ),
            QuestionAnswerWidget(
              questionNumber: 3,
              question:
                  "How Do You Usually Choose Where To Eat? (Select up to 2)",
              answers: [
                "Recommendations from friends/family",
                "Online reviews & ratings",
              ],
              mobileView: mobileView,
            ),
            QuestionAnswerWidget(
              questionNumber: 4,
              question: "Are You More of a Planner or a Spontaneous Diner?",
              answers: ["I like to go with the flow and decide last minute"],
              mobileView: mobileView,
            ),
            QuestionAnswerWidget(
              questionNumber: 5,
              question:
                  "What’s Most Important to You When Dining Out? (Rank in order of importance 1-6)",
              answers: [
                "Food quality",
                "Service",
                "Atmosphere & decor",
                "Entertainment(live music, DJs, etc)",
                "Pricing & discount",
                "Location/Proximity",
              ],
              mobileView: mobileView,
            ),
            QuestionAnswerWidget(
              questionNumber: 6,
              question:
                  "What Kind of Dining Experiences Do You Enjoy the Most?",
              answers: ["Cozy & intimate", "Lively with entertainment"],
              mobileView: mobileView,
            ),
          ],
        ),
      ),
    );
  }
}

// Updated ProfileTextWidget
class ProfileTextWidget extends StatelessWidget {
  const ProfileTextWidget({
    super.key,
    required this.mobileView,
    required this.screenWidth,
    required this.title,
    required this.subtitle,
  });

  final bool mobileView;
  final double screenWidth;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Title (e.g., "Name" or "Email")
        SizedBox(
          width: 60, // Fixed width to ensure parallel alignment
          child: Text(
            title,
            style: headingText.copyWith(
              fontSize: mobileView ? 14 : 16,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.start,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            subtitle,
            style: simpleText.copyWith(
              fontSize: mobileView ? 12 : 14,
              fontWeight: FontWeight.w500,
              color: secondaryColor,
            ),
            textAlign: TextAlign.start,
            overflow: TextOverflow.ellipsis
          ),
        ),
      ],
    );
  }
}

class QuestionAnswerWidget extends StatelessWidget {
  final String question;
  final List<String> answers;
  final int questionNumber;
  final bool mobileView;

  QuestionAnswerWidget({
    super.key,
    required this.question,
    required this.answers,
    required this.questionNumber,
    required this.mobileView,
  });

  final ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Question Row with Numbering
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$questionNumber. ',
                style: simpleText.copyWith(
                  fontSize: mobileView ? 14 : 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Expanded(
                child: Text(
                  question,
                  style: simpleText.copyWith(
                    fontSize: mobileView ? 14 : 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Answers List in a Horizontal Row with Scroll
          GestureDetector(
            onHorizontalDragUpdate: (details) {
              final newOffset = scrollController.offset - details.delta.dx;
              scrollController.jumpTo(
                newOffset.clamp(0.0, scrollController.position.maxScrollExtent),
              );
            },
            child: Listener(
              onPointerSignal: (PointerSignalEvent event) {
                if (event is PointerScrollEvent) {
                  final scrollDelta = event.scrollDelta.dy;
                  scrollController.jumpTo(
                    scrollController.offset + scrollDelta,
                  );
                }
              },
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                controller: scrollController,
                physics: const ClampingScrollPhysics(),
                child: Row(
                  children:
                      answers.map((answer) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          // Spacing between containers
                          child: Container(
                            height: mobileView ? 30 : 40,
                            // Fixed height based on mobileView
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: primaryColor.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(width: 1, color: green),
                            ),
                            child: Center(
                              child: Text(
                                answer,
                                style: simpleText.copyWith(
                                  fontSize: mobileView ? 11 : 14,
                                  fontWeight: FontWeight.w500,
                                  color: secondaryColor,
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
