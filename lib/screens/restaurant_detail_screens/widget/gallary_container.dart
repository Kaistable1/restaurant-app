import 'dart:ui';

import 'package:flutter/material.dart';

import '../../../constants/app_colors.dart';
import '../../../utils/responsive.dart';
class GallaryContainer extends StatelessWidget {
  const GallaryContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Flexible(
          flex: 3,
          child: Container(
            height: Responsive.isMobile(context) ? 120 : 140,
            decoration: BoxDecoration(
              image: const DecorationImage(
                image: AssetImage('assets/images/img1.png'),
                fit: BoxFit.cover,
              ),
              borderRadius: BorderRadius.circular(5),
            ),
          ),
        ),
        SizedBox(width: Responsive.isMobile(context) ? 4 : 8),
        Flexible(
          flex: 2,
          child: Column(
            children: [
              Container(
                height: Responsive.isMobile(context) ? 68 : 70,
                decoration: BoxDecoration(
                  image: const DecorationImage(
                    image: AssetImage('assets/images/img1.png'),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              SizedBox(height: Responsive.isMobile(context) ? 4 : 8),
              Container(
                height: Responsive.isMobile(context) ? 50 : 70,
                decoration: BoxDecoration(
                  image: const DecorationImage(
                    image: AssetImage('assets/images/img1.png'),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
            ],
          ),
        ),
        SizedBox(width: Responsive.isMobile(context) ? 4 : 8),
        Flexible(
          flex:2,
          child: Column(
            children: [
              Container(
                height: Responsive.isMobile(context) ? 68 : 70,
                decoration: BoxDecoration(
                  image: const DecorationImage(
                    image: AssetImage('assets/images/img1.png'),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              SizedBox(height: Responsive.isMobile(context) ? 4 : 8),
              Container(
                height: Responsive.isMobile(context) ? 50 : 70,
                decoration: BoxDecoration(
                  image: const DecorationImage(
                    image: AssetImage('assets/images/img1.png'),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: Stack(
                        children: [
                          Image.asset(
                            'assets/images/img1.png',
                            fit: BoxFit.cover,
                          ),
                          BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 1, sigmaY: 1),
                            child: Container(
                              color: Colors.black.withOpacity(0),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Center(
                      child: Text(
                        'view all photos',
                        style: TextStyle(
                          decoration: TextDecoration.underline,
                          color: AppColors.whiteColor,
                          fontWeight: FontWeight.w700,
                          fontSize: Responsive.isMobile(context) ? 6 : 12,
                          fontFamily: 'Nunito-Regular',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

}
