import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants/app_colors.dart';
import '../models/restaurant_model.dart';
import '../screens/nav_bar/widgets/custom_button.dart';

void showCustomDialog(BuildContext context1,
    {required RestaurantModel resaturant_model}) {
  TextEditingController nameController = TextEditingController();
  TextEditingController resNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController messageController = TextEditingController();
  TextEditingController contactController = TextEditingController();

  showDialog(
    context: context1,
    builder: (BuildContext context) {
      return Dialog(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Dialog Title
              Center(
                child: Text(
                  "Claim your business",
                  style: TextStyle(
                    fontFamily: GoogleFonts.plusJakartaSans().fontFamily,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textColor,
                  ),
                ),
              ),
              SizedBox(height: 15),

              // Name Field
              Text("Your Name", style: _textStyle()), SizedBox(height: 10),
              SizedBox(
                height: 40,
                child: TextField(
                  controller: nameController,
                  decoration: _inputDecoration("Enter your name"),
                ),
              ),
              SizedBox(height: 10),

              // Email Field
              Text("Email", style: _textStyle()), SizedBox(height: 10),
              SizedBox(
                height: 40,
                child: TextField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: _inputDecoration("Enter your email"),
                ),
              ),
              SizedBox(height: 10),
              // Email Field
              Text("Contact No.", style: _textStyle()), SizedBox(height: 10),
              SizedBox(
                height: 40,
                child: TextField(
                  controller: contactController,
                  keyboardType: TextInputType.phone,
                  decoration: _inputDecoration("Enter your email"),
                ),
              ),
              SizedBox(height: 10),

              // Message Field
              Text("Message", style: _textStyle()), SizedBox(height: 10),
              TextField(
                controller: messageController,
                maxLines: 3,
                decoration: _inputDecoration("Enter your message"),
              ),
              SizedBox(height: 20),

              // Buttons Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Cancel Button
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      "Cancel",
                      style: TextStyle(
                        fontFamily: GoogleFonts.plusJakartaSans().fontFamily,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                    ),
                  ),

                  // Submit Button (Same as your UI)
                  CustomButton(
                    laBelText: 'Submit',
                    textColor: AppColors.whiteColor,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    width: Get.width * 0.3,
                    height: 40,
                    ontapp: () async {
                      if (nameController.text.isEmpty ||
                          emailController.text.isEmpty ||
                          messageController.text.isEmpty ||
                          contactController.text.isEmpty) {
                        showScaffoldMessenger(
                            context, 'SAVRLY', 'Please fill all fields',
                            isSuccess: false);
                      } else {
                        try {
                          Navigator.pop(context);

                          // Get reference and auto-generate doc
                          final docRef = FirebaseFirestore.instance
                              .collection('businessClaims')
                              .doc();

                          // Prepare data
                          final data = {
                            'id': docRef.id,
                            'ownerName': nameController.text.trim(),
                            'contact': contactController.text.trim(),
                            'message': messageController.text.trim(),
                            'createdAt': FieldValue.serverTimestamp(),
                            'status': 'Pending',
                            'password': '',
                            'priceRange': '',
                            // Hardcoded for now; you can add a field for this
                            'email': emailController.text.trim(),
                            'restaurantData': resaturant_model.toMap()
                          };

                          // Upload to Firestore
                          await docRef.set(data);
                          showScaffoldMessenger(context1, 'SAVRLY',
                              'Your claim submitted successfully!',
                              isSuccess: true);
                        } catch (e) {
                          print('Error submitting claim: ${e.toString()}');
                          showScaffoldMessenger(context1, 'Error',
                              'Something went wrong. Please try again later.',
                              isSuccess: false);
                        }
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}

// Common TextStyle for Labels
TextStyle _textStyle() {
  return TextStyle(
    fontFamily: GoogleFonts.plusJakartaSans().fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColors.textColor,
  );
}

showScaffoldMessenger(BuildContext context, String title, String description,
    {bool? isSuccess = false}) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: isSuccess! ? Colors.green : Colors.red,
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 14,
                fontFamily: 'Nunito-Bold'),
          ),
          SizedBox(
            height: 8,
          ),
          Text(
            description,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              fontFamily: 'Nunito-Regular',
            ),
          ),
        ],
      )));
}

// Common InputDecoration for TextFields
InputDecoration _inputDecoration(String hint) {
  return InputDecoration(
    hintText: hint,
    hintStyle: _textStyle().copyWith(fontSize: 12),
    contentPadding: EdgeInsets.only(bottom: 4, left: 12),
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
  );
}
