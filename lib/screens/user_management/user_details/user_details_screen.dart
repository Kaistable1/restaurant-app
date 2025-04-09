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
            SizedBox(height: 16),
            Text(
              'Preferences',
              style: headingText.copyWith(fontSize: mobileView ? 16 : 20),
            ),
            SizedBox(height: 16),
            // Static QuestionAnswerWidgets with questions and answers
            QuestionAnswerWidget(
              questionNumber: 1,
              question: "What type of cuisine do you prefer?",
              answers: ["Italian", "Chinese", "Mexican"],
              mobileView: mobileView,
            ),
            QuestionAnswerWidget(
              questionNumber: 2,
              question: "How often do you dine out in a week?",
              answers: ["1-2 times", "3-5 times"],
              mobileView: mobileView,
            ),
            QuestionAnswerWidget(
              questionNumber: 3,
              question: "What is your preferred dining atmosphere?",
              answers: [
                "Casual",
                "Formal",
                "Family-Friendly",
                'preferred dining atmosphere',
                'preferred dining atmosphere',
                'preferred dining atmosphere',
                'preferred dining atmosphere preferred dining atmosphere',
              ],
              mobileView: mobileView,
            ),
            QuestionAnswerWidget(
              questionNumber: 4,
              question:
                  "Do you have any dietary restrictions or preferences that influence your dining choices?",
              answers: ["Vegetarian", "Gluten-Free"],
              mobileView: mobileView,
            ),
          ],
        ),
      ),
    );
  }
}

class QuestionAnswerWidget extends StatelessWidget {
  final String question;
  final List<String> answers;
  final int questionNumber;
  final bool mobileView;

  const QuestionAnswerWidget({
    super.key,
    required this.question,
    required this.answers,
    required this.questionNumber,
    required this.mobileView,
  });

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
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
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
        ],
      ),
    );
  }
}
