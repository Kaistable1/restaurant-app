import 'package:flutter/material.dart';
import 'package:kaistable_website/constants/app_colors.dart';
import 'search_page.dart'; // create this file

class LocationSearchWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SearchPage()), // new page
        );
      },
      child: Container(
        height: 48,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: AppColors.whiteColor,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: AppColors.blackColor)
        ),
        child: Row(
          children: const [
            Icon(Icons.search, color: AppColors.blackColor),
            SizedBox(width: 8),
            Expanded(
              child: Text(
                "Search Restaurants...",
                style: TextStyle(color:AppColors.tableHeadingColor,fontSize: 12,fontFamily: 'NunitoSans-Regular'),
              ),
            ),
            Icon(Icons.my_location, color:AppColors.bottomSheetColor,size: 18,),
          ],
        ),
      ),
    );
  }
}
