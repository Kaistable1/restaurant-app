import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:kaistable_website/widgets/custom_button.dart';
import '../constants/app_colors.dart';
import '../widgets/custom_text_field.dart';
import '../utils/responsive.dart';

class UploadImageSection extends StatefulWidget {
  const UploadImageSection({super.key});

  @override
  _UploadImageSectionState createState() => _UploadImageSectionState();
}

class _UploadImageSectionState extends State<UploadImageSection> {
  File? _selectedImage; // For mobile platform
  Uint8List? _webImage; // For web platform (byte data)
  final TextEditingController _reviewController = TextEditingController();
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
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        setState(() {
          _selectedImage = File(image.path);
        });
      }
    }
  }

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
    return Center( // Center the dialog
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.whiteColor,
          borderRadius: BorderRadius.circular(6),
        ),
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center, // Center vertically
              children: [
                SizedBox(height: Responsive.isMobile(context) ? 30 : 14),
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
                const SizedBox(height: 8),
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
                    onRatingUpdate: (rating) {},
                  ),
                ),
                const SizedBox(height: 12),
                CustomTextFormField(
                  controller: _reviewController,
                  maxLines: 5,
                  width: 310,
                  height: 110,
                  isShadow: false,
                  hintfontsize: Responsive.isMobile(context) ? 12 : 14,
                  fontfamily: 'Nunito-Regular',
                  hintfontWeight: FontWeight.w500,
                  textColor: const Color(0xFF606060),
                  containerColor: const Color(0xFFEEEFF1),
                  hintText: 'Add review here',
                ),
                const SizedBox(height: 12),
                Container(
                  width: 310,
                  height: 150,
                  decoration: BoxDecoration(
                    color: const Color(0xFFEEEFF1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: DottedBorder(
                      dashPattern: const [7, 5],
                      color: AppColors.primaryColor,
                      strokeWidth: 1,
                      borderType: BorderType.RRect,
                      radius: const Radius.circular(6),
                      child: ClipRRect(
                        borderRadius: const BorderRadius.all(Radius.circular(4)),
                        child: InkWell(
                          onTap: _pickImage, // Open the image picker when tapped
                          child: Stack(
                            children: [
                              Container(
                                width: Get.width,
                                color: Colors.transparent,
                                child: _webImage != null
                                    ? Image.memory(
                                  _webImage!,
                                  fit: BoxFit.fill,
                                  width: double.infinity,
                                  height: double.infinity,
                                )
                                    : _selectedImage != null
                                    ? Image.file(
                                  _selectedImage!,
                                  fit: BoxFit.fill, // Change to BoxFit.contain
                                  width: double.infinity,
                                  height: double.infinity,
                                )
                                    : Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      'assets/images/document-upload.png',
                                      width: 24,
                                      height: 24,
                                      fit: BoxFit.fill,
                                    ),
                                    const SizedBox(height: 16),
                                    const Text(
                                      'Drop your image here, or Browse',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 12,
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
                                    onTap: () {
                                      setState(() {
                                        _webImage = null;
                                        _selectedImage = null;
                                      });
                                    },
                                    child: Container(
                                      height: 24,
                                      width: 24,
                                      decoration: BoxDecoration(
                                          color: AppColors.whiteColor,
                                          borderRadius: BorderRadius.circular(50)),
                                      child: const Center(
                                        child: Icon(
                                          Icons.delete,
                                          color: Colors.red,
                                          size: 16,
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
                if (_errorMessage != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
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
                  width: 130,
                  height: 32,
                  fontSize: 14,
                  fontFamily: 'Nunito-Regular',
                  fontWeight: FontWeight.w700,
                  laBelText: 'Submit',
                  ontapp: _validateAndSubmit, // Call validation on submit
                ),
                SizedBox(height: 30,)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
