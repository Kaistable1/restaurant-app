import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/text_styles.dart'; // assuming your textStyle is here

class CustomHeaderWidget extends StatelessWidget {
  final bool back;
  final bool end;
  final VoidCallback? onBackTap;
  final String title;
  final Widget? endWidget;

  const CustomHeaderWidget({
    super.key,
    this.back = false,
    this.end = false,
    this.onBackTap,
    required this.title,
    this.endWidget,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    bool mobileView = screenWidth < 500;

    double iconSize = mobileView ? 34 : 48;
    double iconImageSize = mobileView ? 18 : 24;
    double titleTextSize = mobileView ? 24 : 32;
    double spacing = mobileView ? 16 : 24;

    return mobileView
        ? Column(
            children: [
              if (back)
                GestureDetector(
                  onTap: onBackTap,
                  child: MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: Container(
                      height: iconSize,
                      width: iconSize,
                      decoration: BoxDecoration(
                        color: white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            spreadRadius: 1,
                            blurRadius: 6,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Image.asset(
                          'assets/images/back_arrow.png',
                          height: iconImageSize,
                          width: iconImageSize,
                          fit: BoxFit.fill,
                          color: primaryColor,
                        ),
                      ),
                    ),
                  ),
                )
              else
                const SizedBox(),
              SizedBox(width: back ? spacing : 0),
              Text(title, style: headingText.copyWith(fontSize: titleTextSize)),
              end ? (endWidget ?? const SizedBox()) : const SizedBox(),
            ],
          )
        : Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  if (back)
                    GestureDetector(
                      onTap: onBackTap,
                      child: MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: Container(
                          height: iconSize,
                          width: iconSize,
                          decoration: BoxDecoration(
                            color: white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                spreadRadius: 1,
                                blurRadius: 6,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Center(
                            child: Image.asset(
                              'assets/images/back_arrow.png',
                              height: iconImageSize,
                              width: iconImageSize,
                              fit: BoxFit.fill,
                              color: primaryColor,
                            ),
                          ),
                        ),
                      ),
                    )
                  else
                    const SizedBox(),
                  SizedBox(width: back ? spacing : 0),
                  Text(title,
                      style: headingText.copyWith(fontSize: titleTextSize)),
                ],
              ),
              end ? (endWidget ?? const SizedBox()) : const SizedBox(),
            ],
          );
  }
}
