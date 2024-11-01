import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kaistable_website/constants/app_colors.dart';
import 'package:kaistable_website/utils/responsive.dart';

class AboutSectionWidget extends StatelessWidget {
  const AboutSectionWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 20,),
        Text(
          'About XYZ ',
          style: TextStyle(
            color: AppColors.headingTextColor,
            fontSize: Responsive.isMobile(context) ? 16 : 28,
            fontFamily: 'aftika-regular',
            fontWeight: FontWeight.w400,
          ),
        ),
        const SizedBox(height: 20),
        Text(
          'The modern and elegant Flava Lite Rooftop Pool Bar & Cafe, located on the 11th floor, offers stunning views of the city\'s skyline. Guests can unwind and enjoy a drink or a meal in a serene and relaxing atmosphere from morning until late at night. Whether you choose to sit outdoors and soak in the panoramic views or dine indoors surrounded by chic and minimalistic decor, this rooftop pool bar provides a comfortable environment. Thai-style marinated beef skewers with coriander seed are great to pair with any of your favorite drinks, while salt and pepper kurobuta crispy pork with steamed jasmine rice and Thai-style fried eggs may be more suitable for the hungrier patrons.',
          style: TextStyle(
            color: const Color(0xFF555555),
            fontSize: Responsive.isMobile(context) ? 14 : 18,
            fontFamily: 'Nunito-Regular',
            fontWeight: FontWeight.w400,
          ),
        ),
        SizedBox(height: 20,),
        Text(
          'Operating hours ',
          style: TextStyle(
            color: AppColors.headingTextColor,
            fontSize: Responsive.isMobile(context) ? 16 : 28,
            fontFamily: 'aftika-regular',
            fontWeight: FontWeight.w400,
          ),
        ),
        const SizedBox(height: 20),
        Center(
          child: Container(
            width: Responsive.isMobile(context) || Responsive.isTablet(context)
                ? Get.width
                : Get.width * 0.7,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Table(
                  border: TableBorder.symmetric(
                      inside: BorderSide(
                          width: 1, color: Colors.grey.withOpacity(0.5))),
                  columnWidths: {
                    0: const FlexColumnWidth(1.4),
                    1: const FlexColumnWidth(4),
                  },
                  children: [
                    TableRow(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                      ),
                      children: [
                        tableCell('', isHeader: true),
                        headerText(),
                      ],
                    ),
                    tableRow('Monday', 'Open all day from 11:00-22:00'),
                    tableRow('Tuesday', 'Open all day from 11:00-22:00'),
                    tableRow('Wednesday', 'Open all day from 11:00-22:00'),
                    tableRow('Thursday', 'Open all day from 11:00-22:00'),
                    tableRow('Friday', 'Open all day from 11:00-22:00'),
                  ],
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: 20,)
      ],
    );
  }
  Widget headerText() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      color: Colors.white,
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Breakfast',
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: Color(0xFF555555),
              fontSize: 14,
              fontFamily: 'Nunito-Regular',
            ),
            textAlign: TextAlign.center,
          ),
          Text(
            'Lunch',
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: Color(0xFF555555),
              fontSize: 14,
              fontFamily: 'Nunito-Regular',
            ),
            textAlign: TextAlign.center,
          ),
          Text(
            'Dinner',
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: Color(0xFF555555),
              fontSize: 14,
              fontFamily: 'Nunito-Regular',
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
  TableRow tableRow(String day, String time) {
    return TableRow(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 18.0),
          child: Center(
            child: Text(
              day,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                color: Color(0xFF555555),
                fontSize: 13,
                fontFamily: 'Nunito-Regular',
              ),
              // textAlign: TextAlign.center,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0,vertical: 12),
          child: tableCell(time, isHighlighted: true),
        ),
      ],
    );
  }



  Widget tableCell(String text,
      {bool isHeader = false, bool isHighlighted = false}) {
    return Container(
     // width: 140,
      //padding: const EdgeInsets.all(4.0),
      //margin: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        color: isHighlighted ? const Color(0xFF90D26D) : Colors.white,
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w700,
          fontFamily: 'Nunito-Regular',
          color: isHeader ? Colors.black : Colors.white,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
