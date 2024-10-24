import 'package:flutter/material.dart';

import '../../constants/app_colors.dart';
import '../../utils/responsive.dart';

class AboutApp extends StatelessWidget {
  const AboutApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: Responsive.isMobile(context) ? 300 :565,


        child:  Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 20,), // Add some spacing at the top
            Text(
              'About app',
              style: TextStyle(
                fontFamily: 'aftika-regular',
                fontWeight: FontWeight.w400,
                fontSize: Responsive.isMobile(context) ? 15 :30,
                color: AppColors.blackColor,
              ),
            ),
            SizedBox(height: Responsive.isMobile(context) ? 10 :20,),
            Text(
              'Last Updated: [02/02/2018]',
              style: TextStyle(
                fontFamily: 'Nunito-Regular',
                fontSize: Responsive.isMobile(context) ? 8 :12,
                fontWeight: FontWeight.w400,
                color: AppColors.textColor,
              ),
            ),
            SizedBox(height: 20,),
            Text(
              '1: Use of services',
              style: TextStyle(
                fontFamily: 'Nunito-Regular',
                fontSize: Responsive.isMobile(context) ? 9 :14,
                fontWeight: FontWeight.w700,
                color: AppColors.primaryColor,
              ),
            ),
            Text('The modern and elegant Flava Lite Rooftop Pool Bar & Cafe, located on the 11th floor, offers stunning views of the citys skyline. Guests can unwind and enjoy a drink or a meal in a serene and relaxing atmosphere from morning until late at night. Whether you choose to sit outdoors and soak in the panoramic views or dine indoors surrounded by chic and minimalistic decor, this rooftop pool bar provides a comfortable environment. Thai-style marinated beef skewers with coriander seed are great to pair with any of your favorite drinks, while salt and pepper kurobuta crispy pork with steamed jasmine rice and Thai-style fried eggs may be more suitable for the hungrier patrons.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Nunito-Regular',
                fontSize: Responsive.isMobile(context) ? 9 :14,
                fontWeight: FontWeight.w400,
                color: AppColors.textColor,
              ),),
            SizedBox(height: 20,),
            Text(
              '2. User accounts',
              style: TextStyle(
                fontFamily: 'Nunito-Regular',
                fontSize: Responsive.isMobile(context) ? 9 :14,
                fontWeight: FontWeight.w700,
                color: AppColors.primaryColor,
              ),
            ),
            Text('The modern and elegant Flava Lite Rooftop Pool Bar & Cafe, located on the 11th floor, offers stunning views of the citys skyline. Guests can unwind and enjoy a drink or a meal in a serene and relaxing atmosphere from morning until late at night. Whether you choose to sit outdoors and soak in the panoramic views or dine indoors surrounded by chic and minimalistic decor, this rooftop pool bar provides a comfortable environment. Thai-style marinated beef skewers with coriander seed are great to pair with any of your favorite drinks, while salt and pepper kurobuta crispy pork with steamed jasmine rice and Thai-style fried eggs may be more suitable for the hungrier patrons.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Nunito-Regular',
                fontSize: Responsive.isMobile(context) ? 9 :14,
                fontWeight: FontWeight.w400,
                color: AppColors.textColor,
              ),
            ),
            SizedBox(height: 20,),
            Text(
              '3. User and site content',
              style: TextStyle(
                fontFamily: 'Nunito-Regular',
                fontSize: Responsive.isMobile(context) ? 9 :14,
                fontWeight: FontWeight.w700,
                color: AppColors.primaryColor,
              ),
            ),
            Text('The modern and elegant Flava Lite Rooftop Pool Bar & Cafe, located on the 11th floor, offers stunning views of the citys skyline. Guests can unwind and enjoy a drink or a meal in a serene and relaxing atmosphere from morning until late at night. Whether you choose to sit outdoors and soak in the panoramic views or dine indoors surrounded by chic and minimalistic decor, this rooftop pool bar provides a comfortable environment. Thai-style marinated beef skewers with coriander seed are great to pair with any of your favorite drinks, while salt and pepper kurobuta crispy pork with steamed jasmine rice and Thai-style fried eggs may be more suitable for the hungrier patrons.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Nunito-Regular',
                fontSize: Responsive.isMobile(context) ? 9 :14,
                fontWeight: FontWeight.w400,
                color: AppColors.textColor,
              ),
            ),
            // More terms...
            SizedBox(height: 2,), // Add spacing at the bottom if needed
          ],
        ),
      ),
    );
  }
}
