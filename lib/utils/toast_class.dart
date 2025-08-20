

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:kaistable_website/constants/app_colors.dart';

toastMessage({message, isDanger = false}) {
  Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 2,
      backgroundColor: isDanger ? Colors.red : AppColors.primaryColor,
      textColor: Colors.white,
      fontSize: 16.0);
}