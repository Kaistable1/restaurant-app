import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:kaistable_website/screens/home_screen/my_home_screen.dart';

import '../../constants/app_colors.dart';
import '../../utils/responsive.dart';

class AboutApp extends StatelessWidget {
  final Function(int)? onNavigate;
  const AboutApp({super.key, this.onNavigate});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: ()async{
        Get.offAll(MyHomeScreen());
        return false;

      },
      child: Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: AppColors.primaryColor, // Set your desired color for the drawer icon
          ),
          centerTitle: true,
          automaticallyImplyLeading: true,
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
                    color: Colors.black.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 3,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: GestureDetector(
                onTap: () {
                  Get.offAll(MyHomeScreen()); // Navigate back to the home screen
                },
                child: Icon(Icons.arrow_back, size: 18),
              ),
            ),
          ),

          title: const Text('About app',
            style: TextStyle(
              fontSize: 20,
              color: AppColors.primaryColor,
              fontWeight: FontWeight.w700,
              fontFamily: 'Nunito-Bold',
            ),),
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Container(
              width: Responsive.isMobile(context) ? 300 :565,


              child:  Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 20,), // Add some spacing at the top
                  // Text(
                  //   'Terms and conditions',
                  //   style: TextStyle(
                  //     fontFamily: 'aftika-regular',
                  //     fontWeight: FontWeight.w400,
                  //     fontSize: Responsive.isMobile(context) ? 16 :30,
                  //     color: AppColors.blackColor,
                  //   ),
                  // ),
                  SizedBox(height: Responsive.isMobile(context) ? 5 :20,),
                  Text(
                    'Last Updated: [02/02/2018]',
                    style: TextStyle(
                      fontFamily: 'Nunito-Regular',
                      fontSize: Responsive.isMobile(context) ? 12 :12,
                      fontWeight: FontWeight.w400,
                      color: AppColors.textColor,
                    ),
                  ),
                  SizedBox(height: 10,),
                  Text(
                    '1: Use of services',
                    style: TextStyle(
                      fontFamily: 'Nunito-Regular',
                      fontSize: Responsive.isMobile(context) ? 12 :14,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primaryColor,
                    ),
                  ),
                  SizedBox(height: 10,),
                  Text('The modern and elegant Flava Lite Rooftop Pool Bar & Cafe, located on the 11th floor, offers stunning views of the citys skyline. Guests can unwind and enjoy a drink or a meal in a serene and relaxing atmosphere from morning until late at night. Whether you choose to sit outdoors and soak in the panoramic views or dine indoors surrounded by chic and minimalistic decor, this rooftop pool bar provides a comfortable environment. Thai-style marinated beef skewers with coriander seed are great to pair with any of your favorite drinks, while salt and pepper kurobuta crispy pork with steamed jasmine rice and Thai-style fried eggs may be more suitable for the hungrier patrons.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Nunito-Regular',
                      fontSize: Responsive.isMobile(context) ? 11 :14,
                      fontWeight: FontWeight.w400,
                      color: AppColors.textColor,
                    ),),
                  SizedBox(height: 10,),
                  Text(
                    '2. User accounts',
                    style: TextStyle(
                      fontFamily: 'Nunito-Regular',
                      fontSize: Responsive.isMobile(context) ? 12 :14,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primaryColor,
                    ),
                  ),
                  SizedBox(height: 10,),
                  Text('The modern and elegant Flava Lite Rooftop Pool Bar & Cafe, located on the 11th floor, offers stunning views of the citys skyline. Guests can unwind and enjoy a drink or a meal in a serene and relaxing atmosphere from morning until late at night. Whether you choose to sit outdoors and soak in the panoramic views or dine indoors surrounded by chic and minimalistic decor, this rooftop pool bar provides a comfortable environment. Thai-style marinated beef skewers with coriander seed are great to pair with any of your favorite drinks, while salt and pepper kurobuta crispy pork with steamed jasmine rice and Thai-style fried eggs may be more suitable for the hungrier patrons.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Nunito-Regular',
                      fontSize: Responsive.isMobile(context) ? 11 :14,
                      fontWeight: FontWeight.w400,
                      color: AppColors.textColor,
                    ),
                  ),
                  SizedBox(height: 10,),
                  Text(
                    '3. User and site content',
                    style: TextStyle(
                      fontFamily: 'Nunito-Regular',
                      fontSize: Responsive.isMobile(context) ? 12 :14,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primaryColor,
                    ),
                  ),
                  SizedBox(height: 10,),
                  Text('The modern and elegant Flava Lite Rooftop Pool Bar & Cafe, located on the 11th floor, offers stunning views of the citys skyline. Guests can unwind and enjoy a drink or a meal in a serene and relaxing atmosphere from morning until late at night. Whether you choose to sit outdoors and soak in the panoramic views or dine indoors surrounded by chic and minimalistic decor, this rooftop pool bar provides a comfortable environment. Thai-style marinated beef skewers with coriander seed are great to pair with any of your favorite drinks, while salt and pepper kurobuta crispy pork with steamed jasmine rice and Thai-style fried eggs may be more suitable for the hungrier patrons.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Nunito-Regular',
                      fontSize: Responsive.isMobile(context) ? 11 :14,
                      fontWeight: FontWeight.w400,
                      color: AppColors.textColor,
                    ),
                  ),
                  // More terms...
                  SizedBox(height: 2,), // Add spacing at the bottom if needed
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
