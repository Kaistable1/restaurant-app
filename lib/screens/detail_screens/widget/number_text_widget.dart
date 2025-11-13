import 'package:flutter/material.dart';

import '../../../utils/responsive.dart';

class NumberedTextWidget extends StatelessWidget {
  final int number;
  final String text;

  const NumberedTextWidget({Key? key, required this.number, required this.text})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$number.',
            style: TextStyle(
              color: const Color(0xFF555555),
              fontSize: Responsive.isMobile(context) ? 14 : 16,
              fontFamily: 'Nunito-Regular',
              fontWeight: FontWeight.w400,
              height: 0,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: const Color(0xFF555555),
                fontSize: Responsive.isMobile(context) ? 14 : 16,
                fontFamily: 'Nunito-Regular',
                fontWeight: FontWeight.w400,
                height: 0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
