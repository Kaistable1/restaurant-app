import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/foundation.dart'; // To use kIsWeb
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io'; // For handling files on mobile
import 'package:file_picker/file_picker.dart'; // For handling file picking on web
import 'package:kaistable_website/widgets/custom_button.dart';
import '../constants/app_colors.dart';
import '../widgets/custom_text_field.dart';
import '../utils/responsive.dart';

class UploadImageSection extends StatefulWidget {
  @override
  _UploadImageSectionState createState() => _UploadImageSectionState();
}

class _UploadImageSectionState extends State<UploadImageSection> {
  File? _selectedImage; // For mobile platform
  Uint8List? _webImage; // For web platform (byte data)
  TextEditingController _reviewController = TextEditingController(); // Controller for the text field
  String? _errorMessage; // Error message for validation

  Future<void> _pickImage() async {
    if (kIsWeb) {
      // Use file_picker for web
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.image,
      );
      if (result != null) {
        setState(() {
          _webImage = result.files.first.bytes;
        });
      }
    } else {
      // Use image_picker for mobile platforms
      final ImagePicker _picker = ImagePicker();
      final XFile? image = await _picker.pickImage(source:ImageSource.gallery);
      if (image != null) {
        setState(() {
          _selectedImage = File(image.path);
        });
      }
    }
  }

  // Validation method
  void _validateAndSubmit() {
    setState(() {
      if (_reviewController.text.isEmpty) {
        _errorMessage = "Please enter your review.";
      } else if (_selectedImage == null && _webImage == null) {
        _errorMessage = "Please upload an image.";
      } else {
        _errorMessage = null; // No error
        Navigator.pop(context); // Close the dialog if validation passes
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    bool isLargeScreen = screenWidth > 1400;

    return Container(
      height: 450,
      width: 120 ,
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(Responsive.isMobile(context)?6:10)
      ),
      child: Padding(
        padding: EdgeInsets.all(Responsive.isMobile(context) ? 12 : 22.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height:Responsive.isMobile(context) ? 1 : 14,),
            const Image(
              image: AssetImage('assets/images/dialogbox_img.png'),
              height: 78,
              width: 152,
            ),
            const SizedBox(height: 12),
            const Text(
              'Your opinion matters to us!',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: AppColors.botomSheetColor,
                fontFamily: 'Nunito-Regular',
              ),
            ),
            SizedBox(height: 8),
            SizedBox(
              height: 20,
              child: RatingBar(
                itemSize: 18,
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
                    'assets/images/star_empty_yellow.png',
                    height: 14,
                  ),
                ),
                itemPadding: const EdgeInsets.only(left: 2.0),
                onRatingUpdate: (rating) {
                  print(rating);
                },
              ),
            ),
            SizedBox(height: 12),
            CustomTextFormField(
              controller: _reviewController, // Assign controller to the text field
              maxLines: 5,
              width: Responsive.isMobile(context) ? 310 : isLargeScreen ? 476 : 436,
              height: Responsive.isMobile(context) ? 110 : isLargeScreen ? 183 : 120,
              isShadow: false,
              hintfontsize: Responsive.isMobile(context) ? 12 : 14,
              fontfamily: 'Nunito-Regular',
              hintfontWeight: FontWeight.w500,
              textColor: Color(0xFF606060),
              containerColor: Color(0xFFEEEFF1),
              hintText: 'Add review here',
            ),
            SizedBox(height: 12),
            Container(
              width: Responsive.isMobile(context) ? 310 : isLargeScreen ? 476 : 436,
              height: Responsive.isMobile(context) ? 110 : isLargeScreen ? 183 : 130,
              decoration: BoxDecoration(
                color: Color(0xFFEEEFF1),
                borderRadius: BorderRadius.circular(Responsive.isMobile(context) ? 4 : 15),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: DottedBorder(
                  dashPattern: const [7, 5],
                  color: AppColors.primaryColor,
                  strokeWidth: 1,
                  borderType: BorderType.RRect,
                  radius: Radius.circular(Responsive.isMobile(context) ? 6 : 12),
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(Responsive.isMobile(context) ? 4 : 10)),
                    child: InkWell(
                      onTap: _pickImage, // Open the image picker when tapped
                      child: Stack(
                        children: [
                          Container(
                            height: Responsive.isMobile(context) ? 100 : 137,
                            width: Get.width,
                            color: Colors.transparent,
                            child: _webImage != null // Check for web image first
                                ? Image.memory(
                              _webImage!,
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: double.infinity,
                            )
                                : _selectedImage != null
                                ? Image.file(
                              _selectedImage!,
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: double.infinity,
                            )
                                : Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  'assets/images/document-upload.png',
                                  width: Responsive.isMobile(context) ? 20 : 33,
                                  height: Responsive.isMobile(context) ? 20 : 33,
                                  fit: BoxFit.fill,
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'Drop your image here, or Browse',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: Responsive.isMobile(context) ? 12 : 14,
                                    fontFamily: 'Nunito-Regular',
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xFF606060),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Add a delete icon in the top-right corner
                          if (_webImage != null || _selectedImage != null)
                            Positioned(
                              top: 2,
                              right: 2,
                              child: InkWell(
                                onTap: (){
                                  setState(() {
                                    _webImage = null; // Clear web image
                                    _selectedImage = null; // Clear mobile image
                                  });
                                },
                                child: Container(
                                  height: 24,
                                  width: 24,
                                  decoration: BoxDecoration(

                                    color: AppColors.whiteColor,
                                    borderRadius: BorderRadius.circular(50)
                                  ),
                                  child: Center(
                                      child: Icon(
                                        Icons.delete,
                                        color:Colors.red,
                                        size: Responsive.isMobile(context) ? 16 : 18,
                                      ),
                                    ),


                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: Responsive.isMobile(context) ? 14 : 20),

            // Display error message here
            if (_errorMessage != null) // Show error only if there's a message
              Padding(
                padding: EdgeInsets.only(bottom: 10),
                child: Text(
                  _errorMessage!,
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: Responsive.isMobile(context) ? 10 : 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),

            CustomButton(
              textColor: AppColors.whiteColor,
              width: Responsive.isMobile(context) ? 130 : isLargeScreen ? 300 : 265,
              height: Responsive.isMobile(context) ? 32 : isLargeScreen ? 58 : 48,
              fontSize: Responsive.isMobile(context) ? 14 : isLargeScreen ? 24 : 20,
              fontFamily: 'Nunito-Regular',
              fontWeight: FontWeight.w700,
              laBelText: 'Submit',
              ontapp: _validateAndSubmit, // Call validation on submit
            ),
          ],
        ),
      ),
    );
  }
}

