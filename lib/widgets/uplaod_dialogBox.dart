import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:kaistable_website/screens/home_screen/home_controller/home_location_controller.dart';
import '../constants/app_colors.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';
import '../utils/responsive.dart';

@immutable
class UploadImageSection extends StatefulWidget {
  final String restaurantId;  // ← NOW FINAL + REQUIRED

  const UploadImageSection({
    super.key,
    required this.restaurantId,
  });

  @override
  UploadImageSectionState createState() => UploadImageSectionState();
}

class UploadImageSectionState extends State<UploadImageSection> {
  List<File> _selectedImages = [];
  final HomeLocationController homeLocationController =
      Get.find<HomeLocationController>();
  final TextEditingController _reviewController = TextEditingController();
  String? _errorMessage;
  final PageController _pageController = PageController();
  double ratingStars = 1.0;

  Future<void> _pickImages() async {
    if (kIsWeb) {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: true,
      );
      if (result != null && result.files.length <= 3) {
        // Handle web files if needed later
      } else if (result != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('You can only pick up to 3 images.')),
        );
      }
    } else {
      final ImagePicker picker = ImagePicker();
      final List<XFile>? images = await picker.pickMultiImage();
      if (images != null) {
        if (images.length > 3) {
          Get.snackbar('Limit Exceeded', 'You can only pick up to 3 images.');
        } else {
          setState(() {
            _selectedImages = images.map((image) => File(image.path)).toList();
          });
        }
      }
    }
  }

  void _validateAndSubmit() async {
    if (_reviewController.text.isEmpty) {
      setState(() => _errorMessage = "Please enter your review.");
      return;
    }

    await homeLocationController.addRestaurantReview(
      restaurantID: widget.restaurantId,
      description: _reviewController.text,
      images: _selectedImages,
      starRating: ratingStars,
    );

    setState(() => _errorMessage = null);
    Get.snackbar(
      "Thank you for your feedback!",
      "Your review has been successfully added.",
      colorText: AppColors.whiteColor,
      backgroundColor: AppColors.primaryColor,
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        width: Get.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: Responsive.isMobile(context) ? 12 : 14),
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
                color: AppColors.bottomSheetColor,
                fontFamily: 'Nunito-Regular',
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 20,
              child: RatingBar(
                itemSize: 18,
                initialRating: 1,
                minRating: 1,
                direction: Axis.horizontal,
                allowHalfRating: true,
                itemCount: 5,
                ratingWidget: RatingWidget(
                  full: Image.asset('assets/images/star yellow.png', height: 14),
                  half: Image.asset('assets/images/star yellow.png', height: 14),
                  empty: Image.asset('assets/images/star_empty_yellow.png', height: 14),
                ),
                itemPadding: const EdgeInsets.only(left: 2.0),
                onRatingUpdate: (rating) {
                  ratingStars = rating;
                  setState(() {});
                },
              ),
            ),
            const SizedBox(height: 12),
            CustomTextFormField(
              controller: _reviewController,
              maxLines: 5,
              width: 326,
              height: 110,
              isShadow: false,
              hintfontsize: 12,
              fontfamily: 'Nunito-Regular',
              hintfontWeight: FontWeight.w500,
              textColor: const Color(0xFF606060),
              containerColor: const Color(0xFFEEEFF1),
              hintText: 'Add review here',
            ),
            const SizedBox(height: 12),
            Container(
              width: 326,
              height: 150,
              decoration: BoxDecoration(
                color: const Color(0xFFEEEFF1),
                borderRadius: BorderRadius.circular(10),
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
                      onTap: _pickImages,
                      child: _selectedImages.isNotEmpty
                          ? PageView.builder(
                              controller: _pageController,
                              itemCount: _selectedImages.length,
                              itemBuilder: (context, index) {
                                return Stack(
                                  children: [
                                    Image.file(
                                      _selectedImages[index],
                                      width: 326,
                                      height: 150,
                                      fit: BoxFit.fitHeight,
                                    ),
                                    Positioned(
                                      top: 8,
                                      right: 8,
                                      child: GestureDetector(
                                        onTap: () => setState(() => _selectedImages.removeAt(index)),
                                        child: Container(
                                          padding: const EdgeInsets.all(4.0),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(50),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black.withOpacity(0.2),
                                                blurRadius: 3,
                                                offset: const Offset(0, 1),
                                              ),
                                            ],
                                          ),
                                          child: const Icon(Icons.delete, color: Colors.red, size: 18),
                                        ),
                                      ),
                                    ),
                                    // Navigation arrows (same as before)
                                    if (_selectedImages.length > 1) ...[
                                      Positioned(
                                        top: 50,
                                        left: 6,
                                        child: GestureDetector(
                                          onTap: () => _pageController.previousPage(
                                            duration: const Duration(milliseconds: 300),
                                            curve: Curves.easeInOut,
                                          ),
                                          child: CircleAvatar(
                                            radius: 14,
                                            backgroundColor: Colors.white.withOpacity(0.7),
                                            child: Icon(Icons.arrow_back_ios_rounded, color: AppColors.primaryColor, size: 14),
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        top: 50,
                                        right: 6,
                                        child: GestureDetector(
                                          onTap: () => _pageController.nextPage(
                                            duration: const Duration(milliseconds: 300),
                                            curve: Curves.easeInOut,
                                          ),
                                          child: CircleAvatar(
                                            radius: 14,
                                            backgroundColor: Colors.white.withOpacity(0.7),
                                            child: Icon(Icons.arrow_forward_ios_rounded, color: AppColors.primaryColor, size: 14),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ],
                                );
                              },
                            )
                          : const Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image(image: AssetImage('assets/images/document-upload.png'), width: 24, height: 24),
                                  SizedBox(height: 16),
                                  Text(
                                    'Drop your images here, or Browse',
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
            const SizedBox(height: 20),
            CustomButton(
              textColor: AppColors.whiteColor,
              width: 200,
              height: 48,
              fontSize: 17,
              fontFamily: 'Nunito-Regular',
              fontWeight: FontWeight.w700,
              laBelText: 'Submit',
              ontapp: _validateAndSubmit,
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}
