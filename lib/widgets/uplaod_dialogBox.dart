
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:kaistable_website/widgets/custom_button.dart';
import '../constants/app_colors.dart';
import '../widgets/custom_text_field.dart';
import '../utils/responsive.dart';

Widget uploadImageSection(BuildContext context) {
  double screenWidth = MediaQuery.of(context).size.width;
  bool isLargeScreen = screenWidth > 1400;
  return Container(
    height: Responsive.isMobile(context) ? 410 :isLargeScreen?700: 730, // Pass context here
    width: Responsive.isMobile(context) ? 300:isLargeScreen?730:600,
    decoration: BoxDecoration(
      color: AppColors.whiteColor,
      borderRadius: BorderRadius.circular(Responsive.isMobile(context) ? 6:10),
    ),
    child: Padding(
      padding:  EdgeInsets.all(Responsive.isMobile(context) ? 12:22.0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Image(
              image: AssetImage('assets/images/dialogbox_img.png'),
              height: 78,
              width: 152,
            ),
            SizedBox(height: 16),
            Text(
              'Your opinion matters to us!',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: AppColors.botomSheetColor,
                fontFamily: 'Nunito-Regular',
              ),
            ),
            SizedBox(height: 10),
            SizedBox(
              height: 20,
              child: RatingBar(
                itemSize: 14,
                ignoreGestures: false,
                initialRating: 4,
                minRating: 1,
                direction: Axis.horizontal,
                allowHalfRating: true,
                itemCount: 5,
                ratingWidget: RatingWidget(
                  full: Image.asset(
                    'assets/images/star yellow.png',
                    height: 14,
                  ),
                  half: Image.asset(
                    'assets/images/star yellow.png',
                    height: 14,
                  ),
                  empty: Image.asset(
                    'assets/images/star_empty.png',
                    height: 14,
                  ),
                ),
                itemPadding: const EdgeInsets.only(left: 2.0),
                onRatingUpdate: (rating) {
                  print(rating);
                },
              ),
            ),
            SizedBox(height: 10),
            CustomTextFormField(

              maxLines: 5,
              width: Responsive.isMobile(context) ? 230:isLargeScreen?476:436,
              height: Responsive.isMobile(context) ? 100:isLargeScreen?183:120,
              isShadow: false,
              hintfontsize: Responsive.isMobile(context) ? 8:14,

              fontfamily: 'Nunito-Regular',
              hintfontWeight: FontWeight.w500,
              textColor: Color(0xFF606060),
              containerColor: Color(0xFFEEEFF1),
              hintText: 'Add review here',
            ),
            SizedBox(height: 10),
            Container(
              width: Responsive.isMobile(context) ? 230:isLargeScreen?476:436,
              height: Responsive.isMobile(context) ? 100:isLargeScreen?183:120,
              decoration: BoxDecoration(
                color: Color(0xFFEEEFF1),
                borderRadius: BorderRadius.circular( Responsive.isMobile(context) ?4:15),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: DottedBorder(
                  dashPattern: const [7, 5],
                  color: AppColors.primaryColor,
                  strokeWidth: 1,
                  borderType: BorderType.RRect,
                  radius:  Radius.circular( Responsive.isMobile(context) ?6:12),
                  child: ClipRRect(
                    borderRadius:  BorderRadius.all(Radius.circular( Responsive.isMobile(context) ?4:10)),
                    child: GestureDetector(
                      onTap: () {
                        // Image picker code here
                      },
                      child: Container(
                        height:  Responsive.isMobile(context) ? 100:137,
                        width: Get.width,
                        color: Colors.transparent,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/images/document-upload.png',
                              width:  Responsive.isMobile(context) ? 20:33,
                              height:  Responsive.isMobile(context) ? 20:33,
                              fit: BoxFit.fill,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Drop your image/document here, or Browse',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize:  Responsive.isMobile(context) ? 8:14,
                                fontFamily: 'Nunito-Regular',
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF606060),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: Responsive.isMobile(context) ?10:20,),
            CustomButton(
                textColor: AppColors.whiteColor,
                width: Responsive.isMobile(context) ?100:isLargeScreen?300:265,
                height:Responsive.isMobile(context) ?28:isLargeScreen?58: 48,
                fontSize: Responsive.isMobile(context) ?12:isLargeScreen?24:20,
                fontFamily: 'Nunito-Regular',
                fontWeight: FontWeight.w700,
                laBelText: 'Submit')
          ],
        ),
      ),
    ),
  );
}
