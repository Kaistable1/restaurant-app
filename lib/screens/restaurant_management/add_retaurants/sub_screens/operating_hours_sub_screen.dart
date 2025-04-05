import 'package:flutter/material.dart';
import 'package:savrly/constants/text_styles.dart';

class OperatingHoursSubScreen extends StatelessWidget {
  const OperatingHoursSubScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    bool mobileView = screenWidth < 900;
    return Column(
      children: [
        Text('Operating Images',style: headingText.copyWith(fontSize: mobileView ? 16 : 20),),
      ],
    );
  }
}
