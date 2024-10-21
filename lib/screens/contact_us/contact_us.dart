import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kaistable_website/screens/contact_us/controller/contact_us_controller.dart';
import 'package:kaistable_website/widgets/custom_button.dart';
import 'package:kaistable_website/widgets/custom_dropdown.dart';

import '../../constants/app_colors.dart';
import '../../utils/responsive.dart';
import '../../widgets/custom_text_field.dart';

class ContactUs extends StatelessWidget {
  final controller = Get.put(ContactUsController());
   ContactUs({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: Responsive.isMobile(context) ? 300 :677,


        child:  Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 20,), // Add some spacing at the top
            Text(
              'Contact us',
              style: TextStyle(
                fontFamily: 'aftika-regular',
                fontWeight: FontWeight.w400,
                fontSize: Responsive.isMobile(context) ? 15 :30,
                color: AppColors.blackColor,
              ),
            ),
            SizedBox(height: Responsive.isMobile(context) ? 10 :20,),
            Text(
              'You have questions, we have answers - you can find the most frequently asked questions in our faq section Cant find the answers you need in the faq section? Send us an email now or contact us via live chat.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Nunito-Regular',
                fontSize: Responsive.isMobile(context) ? 9 :14,
                fontWeight: FontWeight.w400,
                color: AppColors.textColor,
              ),
            ),
            SizedBox(height: 20,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset('assets/images/email_icon.png',
                height: 11,width: 14,),
                SizedBox(width: 6,),
                Text(
                  'xyz@support.com',
                  style: TextStyle(
                    fontFamily: 'Nunito-Regular',
                    fontSize: Responsive.isMobile(context) ? 9 :14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primaryColor,
                  ),
                ),
                SizedBox(width: 16,),
                Image.asset('assets/images/phone_icon.png',
                  height: 14,width: 14,),
                SizedBox(width: Responsive.isMobile(context) ? 4 :6,),
                Text(
                  '648-393-3115',
                  style: TextStyle(
                    fontFamily: 'Nunito-Regular',
                    fontSize: Responsive.isMobile(context) ? 9 :14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primaryColor,
                  ),
                ),
              ],
            ),


            // More terms...
            SizedBox(height: 60,),
            Container(
              width: 568,
              child: Column(
                children: [
                  // Inside your ContactUs widget
                  Obx(()=>
                     CustomDropdown(
                      height: Responsive.isMobile(context) ? 34 : 44,
                      hintText: "Tell us why you're contacting us",
                      items: [
                        "Olivia Rhye", "Phoenix Baker", "Lana Steiner", "Demi Wilkinson", "Candice Wu", "Natali Craig", "Drew Cano"
                      ],
                      selectedValue: controller.contactingUs.value,
                      onChanged: (value) {
                        controller.contactingUs.value = value!;
                        controller.hasError.value = false;
                      },
                      containerColor: Color(0xFFFFFFFF),
                      textColor: Colors.grey,
                       fontfamily: 'Nunito-Regular',
                       hintfontsize: Responsive.isMobile(context)? 7:14,
                    ),
                  ),

                  SizedBox(height: 20,),
                  CustomTextFormField(
                    imgHeight: Responsive.isMobile(context) ? 8 :11,
                    imgWidth: Responsive.isMobile(context) ? 9 :14,
                    prefixImagePath: 'assets/images/email_icon_black.png',
                    height: Responsive.isMobile(context)? 34:44,
                    hintText: 'Please Enter your email',
                    controller: controller.emailController,
                    containerColor: AppColors.whiteColor,
                    fontfamily: 'Nunito-Regular',
                    hintfontsize: Responsive.isMobile(context)? 7:14,
                    textColor: AppColors.textColor,),
                  SizedBox(height: 20,),
                  CustomTextFormField(

                    height: Responsive.isMobile(context)? 70:89,
                    hintText: 'Message note',

                    controller: controller.messagreController,
                    containerColor: AppColors.whiteColor,
                    fontfamily: 'Nunito-Regular',
                    hintfontsize: Responsive.isMobile(context)? 7:14,
                    textColor: AppColors.textColor,),

                  SizedBox(height: 60,),
                  CustomButton(
                   height: Responsive.isMobile(context)? 34:64,
                    laBelText: 'Search',
                    textColor: AppColors.whiteColor,
                    fontFamily: 'Nunito-Regular',
                    fontWeight: FontWeight.w500,
                    fontSize: Responsive.isMobile(context)? 10:18,

                  )



                ],
              ),

            ),
            SizedBox(height: 120,),
          ],
        ),
      ),
    );
  }
}
