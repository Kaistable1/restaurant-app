import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
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
        SizedBox(
          height: 20,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 16.0, right: 16),
          child: Text(
            'Operating hours',
            style: TextStyle(
              color: AppColors.headingTextColor,
              fontSize: Responsive.isMobile(context) ? 20 : 28,
              fontFamily: 'aftika-regular',
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        SizedBox(
          height: 10,
        ),
        MyAbout(),
        SizedBox(
          height: 10,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 16.0, right: 16),
          child: Text(
            'About XYZ',
            style: TextStyle(
              color: AppColors.headingTextColor,
              fontSize: Responsive.isMobile(context) ? 20 : 28,
              fontFamily: 'aftika-regular',
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.only(left: 16.0, right: 16),
          child: Text(
            'The modern and elegant Flava Lite Rooftop Pool Bar & Cafe, located on the 11th floor, offers stunning views of the city\'s skyline. Guests can unwind and enjoy a drink or a meal in a serene and relaxing atmosphere from morning until late at night. Whether you choose to sit outdoors and soak in the panoramic views or dine indoors surrounded by chic and minimalistic decor, this rooftop pool bar provides a comfortable environment. Thai-style marinated beef skewers with coriander seed are great to pair with any of your favorite drinks, while salt and pepper kurobuta crispy pork with steamed jasmine rice and Thai-style fried eggs may be more suitable for the hungrier patrons.',
            style: TextStyle(
              color: AppColors.tableHeadingColor,
              fontSize:  14,
              fontFamily: 'Nunito-Regular',
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}

class MyAbout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(6),
        ),
        width: Get.width,
        child: Padding(
          padding: const EdgeInsets.only(left: 4.0, right: 4, top: 22, bottom: 10),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              dividerThickness: 1,
              columnSpacing: 4,
              horizontalMargin: 5,
              dataRowMinHeight: 12,
              headingRowHeight: 32,
              columns: [
                DataColumn(
                  label: SizedBox(
                    width: 60,
                    child: Row(
                      children: [
                        Text(
                          '',
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFF555555),
                            fontWeight: FontWeight.w500,
                            fontFamily: "Nunito-Bold",
                          ),
                        ),
                        Spacer(),
                        Container(
                          height: Get.height,
                          width: 0.5,
                          color: AppColors.hintText,
                        )
                      ],
                    ),
                  ),
                ),
                DataColumn(

                  label: Text(
                    'Breakfast',
                    style: TextStyle(
                      fontSize: 8,
                      color: AppColors.tableHeadingColor,
                      fontWeight: FontWeight.w500,
                      fontFamily: "Nunito-Sans",
                    ),
                  ),
                ),
                DataColumn(

                  label: Text(
                    'Brunch',
                    style: TextStyle(
                      fontSize: 8,
                      color: AppColors.tableHeadingColor,
                      fontWeight: FontWeight.w500,
                      fontFamily: "Nunito-Sans",
                    ),
                  ),
                ),
                DataColumn(

                  label: Text(
                    'Lunch',
                    style: TextStyle(
                      fontSize: 8,
                      color: AppColors.tableHeadingColor,
                      fontWeight: FontWeight.w500,
                      fontFamily: "Nunito-Sans",
                    ),
                  ),
                ),
                DataColumn(

                  label: Text(
                    'Dinner',
                    style: TextStyle(
                      fontSize: 8,
                      color: AppColors.tableHeadingColor,
                      fontWeight: FontWeight.w500,
                      fontFamily: "Nunito-Sans",
                    ),
                  ),
                ),
                DataColumn(

                  label: Text(
                    'Late Night',
                    style: TextStyle(
                      fontSize: 8,
                      color: AppColors.tableHeadingColor,
                      fontWeight: FontWeight.w500,
                      fontFamily: "Nunito-Sans",
                    ),
                  ),
                ),
              ],
              rows: [
                _buildRow('Monday', '11:00-22:00', '11:00-22:00', '11:00-22:00',
                    '11:00-22:00', '11:00-22:00'),
                _buildRow('Tuesday', '11:00-22:00', '11:00-22:00', '11:00-22:00',
                    '11:00-22:00', 'Closed'),
                _buildRow('Wednesday', '11:00-22:00', '11:00-22:00',
                    '11:00-22:00', 'Closed', 'Closed'),
                _buildRow('Thursday', '11:00-22:00', '11:00-22:00', 'Closed',
                    'Closed', 'Closed'),
                _buildRow('Friday', '11:00-22:00', 'Closed', 'Closed', 'Closed',
                    'Closed'),
                _buildRow(
                    'Saturday', 'Closed', 'Closed', 'Closed', 'Closed', 'Closed'),
                _buildRow(
                    'Sunday', 'Closed', 'Closed', 'Closed', 'Closed', 'Closed'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  DataRow _buildRow(String day, String breakfast, String brunch, String lunch,
      String dinner, String lateNight) {
    Color availableColor = AppColors.primaryColor.withOpacity(.9);
    Color closedColor = AppColors.hintText.withOpacity(.8);

    return DataRow(
      cells: [
        DataCell(
          SizedBox(
            width: 60,
            child: Row(
              children: [
                Text(
                  day,
                  style: TextStyle(
                    fontSize: 8,
                    color: AppColors.tableHeadingColor,
                    fontWeight: FontWeight.w500,
                    fontFamily: "Nunito-Sans",
                  ),
                ),
                const Spacer(),
                Container(
                  height: Get.height,
                  width: 0.5,
                  color: AppColors.hintText,
                ),
              ],
            ),
          ),
        ),
        DataCell(buildCell(breakfast, availableColor, closedColor)),
        DataCell(buildCell(brunch, availableColor, closedColor)),
        DataCell(buildCell(lunch, availableColor, closedColor)),
        DataCell(buildCell(dinner, availableColor, closedColor)),
        DataCell(buildCell(lateNight, availableColor, closedColor)),
      ],
    );
  }

  Widget buildCell(String value, Color availableColor, Color closedColor) {
    return Container(
      width: 66,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(3),
        color: value == 'Closed' ? closedColor : availableColor,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 4),
        child: Text(
          value,
          style: const TextStyle(
            fontSize: 9,
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontFamily: "Nunito-Sans",
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}


