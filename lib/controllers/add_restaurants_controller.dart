// import 'dart:html' as html;
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:savrly/main.dart';
import 'package:savrly/models/resaturant_model.dart';
import 'dart:typed_data';
import 'package:http/http.dart' as http;

import 'package:savrly/widgets/global_functions.dart';

class AddRestaurantTabController extends GetxController {
  final basicInfoFormKey = GlobalKey<FormState>();
  final restaurantNameController = TextEditingController();
  final emailController = TextEditingController();
  final assignPasswordController = TextEditingController();
  final areaController = TextEditingController();
  final zipCodeController = TextEditingController();
  final phoneNoController = TextEditingController();
  final websiteUrlController = TextEditingController();

  final tiktokLinkController = TextEditingController();
  final instagramController = TextEditingController();
  RestaurantModel? restaurantModel;
  bool? isNewRegistery;
  String currentRestaurantID = '';
  var isPasswordVisible = false.obs;
  RxInt selectedIndex = 0.obs;
  RxString selectedState = ''.obs;
  RxString selectedCity = ''.obs;
  RxString selectedSpokenLanguage = ''.obs;
  RxDouble latitude = 0.0.obs;
  RxDouble longitude = 0.0.obs;
  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  RxList<String> spokenLanguageList = <String>[
    "English",
    "French",
    "Spanish",
  ].obs;

  RxList<String> stateList = <String>["New York", "California"].obs;
  final List<String> tabs = [
    'Basic Info',
    'Amenities',
    'Experiences',
    'Operating Hours',
    'Menu',
  ];

  // Store uploaded images
  var uploadedImage = <UploadedImageModel>[].obs;
  void pickImageWeb() async {
    print("Upload tapped");
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.image,
      withData: true,
    );

    if (result != null) {
      print("Picked ${result.files.length} files");
      for (var file in result.files) {
        if (file.bytes != null) {
          uploadedImage.add(UploadedImageModel(bytes: file.bytes!));
        }
      }
    } else {
      print("No file selected");
    }
  }

  void removeImage(int index) {
    if (index >= 0 && index < uploadedImage.length) {
      uploadedImage.removeAt(index);
    }
  }

  bool areBasicInfoFieldsFilled() {
    return restaurantNameController.text.trim().isNotEmpty &&
        emailController.text.trim().isNotEmpty &&
        assignPasswordController.text.trim().isNotEmpty &&
        areaController.text.trim().isNotEmpty &&
        selectedState.value.isNotEmpty &&
        selectedCity.value.isNotEmpty && phoneNoController.text.trim().isNotEmpty && websiteUrlController.text.isNotEmpty;
  }

  void clearFields() {
    restaurantNameController.clear();
    emailController.clear();
    assignPasswordController.clear();
    areaController.clear();
    instagramController.clear();
    tiktokLinkController.clear();
    phoneNoController.clear();
    websiteUrlController.clear();
    uploadedImage.clear();
    selectedState.value = '';
    selectedCity.value = '';
    selectedSpokenLanguage.value = '';
    isPasswordVisible.value = false; // Reset visibility
    update();
  }

  // Backend code

  addRestaurant() async {
    try {
      // Show loading dialog
      loadingDialog();

      // Upload all images to Firebase Storage and get their URLs
      List<Uint8List> imageBytesList = uploadedImage
          .where((img) => img.bytes != null)
          .map((img) => img.bytes!)
          .toList();

      List<String> imagesList = await uploadImagesToFirebase(imageBytesList);

      String docID = await assignedCredencialsLogin(
          email: emailController.text.trim(),
          userPassword: assignPasswordController.text.trim());
      if (docID == 'error') {
        Get.snackbar('Savrly', 'Restaurant not registered!');
        Get.back();
        return;
      }
      // Prepare the restaurant data
      final restaurantData = {
        'phoneNo': phoneNoController.text.trim(),
        'websiteUrl': websiteUrlController.text.trim(),
        'about': 'Coming Soon!! Stay tuned for something exciting!',
        'address': areaController.text.trim(),
        'atmopshereList': [],
        'vibesList': [] ,// Empty array as per your data
        'averageRating': 0,
        'reviewCount': 0,
        'city': selectedCity.value.trim(),
        'country': selectedState.value.trim(),
        'createdAt': DateTime.now(),
        'dietaryList': [], // Empty array as per your data
        'docID': docID, // Will be set after adding the document
        'entertainmentScheduleList': [], // Empty array as per your data
        'facilityList': [], // Empty array as per your data
        'resImages': imagesList,
        'latitude':
            latitude.value, // Hardcoded for now; you can add a map picker later
        'logoImage': imagesList.isEmpty
            ? 'https://s3-media2.fl.yelpcdn.com/bphoto/iCP4QYCjWf9i-qDIBQrsnQ/o.jpg'
            : imagesList.first,
        'longitude': longitude
            .value, // Hardcoded for now; you can add a map picker later
        'menuList': [], // Empty array as per your data
        'password': assignPasswordController.text.trim(),
        'priceRange': '', // Hardcoded for now; you can add a field for this
        'resEmail': emailController.text.trim(),
        'resName': restaurantNameController.text.trim(),
        'socialLink': instagramController.text.trim(),
        'socialMedia': tiktokLinkController.text.trim(),
        'specialConditions': 'Coming Soon!! Stay tuned for something exciting!',
        'spokenLanguage': selectedSpokenLanguage.value.trim(),
        'zipcode': zipCodeController.text.trim(),
      };

      // Add the restaurant to Firestore
      await FirebaseFirestore.instance
          .collection('restaurants')
          .doc(docID)
          .set(restaurantData);
      if (isNewRegistery == true) {
        print('is new registry true------------------');
        restaurantModel = RestaurantModel.fromMap(restaurantData);
        update();
      }
      update();
      // Dismiss the loading dialog
      Get.back();
      // Show success message
      selectedIndex.value++;
      clearFields();
      uploadedImage.clear();
    } catch (e) {
      Get.back();
      Get.snackbar('Error', 'Failed to add restaurant: $e');
      print('Error $e');
    }
  }

  updateBasicInfo() async {
    try {
      if (isNewRegistery == true) {
        await FirebaseFirestore.instance
            .collection('restaurants')
            .doc(restaurantModel!.docID)
            .delete();
        await addRestaurant();
        Get.back();
        return;
      }
      // Show loading dialog
      loadingDialog();

      if (restaurantModel!.resEmail != emailController.text.trim()) {
        // Get new email and password from controllers
        String newEmail = emailController.text.trim();
        String newPassword = assignPasswordController.text.trim();
        String uid = await updateCredentials(
            currentEmail: restaurantModel!.resEmail,
            currentPassword: restaurantModel!.password,
            newEmail: newEmail,
            newPassword: newPassword);
        if (uid != 'error') {
          await FirebaseFirestore.instance
              .collection('restaurants')
              .doc(restaurantModel?.docID)
              .update({
            'password': assignPasswordController.text.trim(),
            'resEmail': emailController.text.trim(),
          });
        }
        Get.back();
      }

      List<String> imagesList =
          await imagesUrl(uploadedImageModels: uploadedImage);
      // Prepare the restaurant data
      final restaurantData = {
        'address': areaController.text.trim(),
        'city': selectedCity.value.trim(),
        'country': selectedState.value.trim(),
        'resImages': imagesList,
        'latitude':
            latitude.value, // Hardcoded for now; you can add a map picker later
        'logoImage': imagesList.isEmpty
            ? 'https://s3-media2.fl.yelpcdn.com/bphoto/iCP4QYCjWf9i-qDIBQrsnQ/o.jpg'
            : imagesList.first,
        'longitude': longitude
            .value, // Hardcoded for now; you can add a map picker later
        'resName': restaurantNameController.text.trim(),
        'socialLink': instagramController.text.trim(),
        'socialMedia': tiktokLinkController.text.trim(),
        'spokenLanguage': selectedSpokenLanguage.value.trim(),
        'phoneNo':phoneNoController.text.trim(),
        'websiteUrl':websiteUrlController.text.trim()
      };

      await FirebaseFirestore.instance
          .collection('restaurants')
          .doc(restaurantModel?.docID)
          .update(restaurantData);

      // Dismiss the loading dialog
      Get.back();
      // Show success message
      selectedIndex.value++;
      // clearFields();
      // uploadedImage.clear();
    } catch (e) {
      Get.back();
      Get.snackbar('Error', 'Failed to updated restaurant: $e');
      print('Error $e');
    }
  }

  imagesUrl({
    required List<UploadedImageModel> uploadedImageModels,
  }) async {
    List<String> imagesList = [];
    List<String> existingImageUrls = [];
    List<Uint8List> newImagesToUpload = [];

    for (var image in uploadedImageModels) {
      if (image.url != null) {
        existingImageUrls.add(image.url!);
      } else if (image.bytes != null) {
        newImagesToUpload.add(image.bytes!);
      }
    }

    // Upload new images to Firebase
    if (newImagesToUpload.isNotEmpty) {
      final uploadedImageUrls = await uploadImagesToFirebase(newImagesToUpload);
      imagesList = [
        ...existingImageUrls,
        ...uploadedImageUrls,
      ];
    } else {
      imagesList = existingImageUrls.isNotEmpty
          ? existingImageUrls
          : restaurantModel?.imagesList ?? [];
    }

    return imagesList;
  }

  Future<String> assignedCredencialsLogin(
      {required String email, required String userPassword}) async {
    try {
      // Get admin credentials from SharedPreferences
      String? adminEmail = preferences?.getString('adminEmail');
      String? adminPassword = preferences?.getString('adminPassword');

      // Sign out temporarily
      await FirebaseAuth.instance.signOut();
      print('admin logout successfully');
      // Create restaurant user
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: assignPasswordController.text.trim(),
      );
      print(
          'restaurant user regiester successfully with id ${userCredential.user?.uid}');
      User? newUser = userCredential.user;

      if (newUser != null) {
        // Sign out restaurant
        await FirebaseAuth.instance.signOut();
        print('logout restaurant');
        // Sign admin back in
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: adminEmail!,
          password: adminPassword!,
        );
        print('login admin again');
      } else {
        Get.snackbar('Error', 'Failed to create restaurant',
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.red,
            colorText: Colors.white);
        print('failf to create restaurant');
      }
      return newUser!.uid;
    } catch (e) {
      print('create reaturant issue $e');
      return 'error';
    }
  }

  Future<String> updateCredentials({
    required String currentEmail,
    required String currentPassword,
    required String newEmail,
    required String newPassword,
  }) async {
    try {
      print('Current email: $currentEmail');
      print('Current password: $currentPassword');
      print('New email: $newEmail');
      print('New password: $newPassword');

      String? adminEmail = preferences?.getString('adminEmail');
      String? adminPassword = preferences?.getString('adminPassword');

      if (adminEmail == null || adminPassword == null) {
        Get.snackbar('Error', 'Admin credentials not found',
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.red,
            colorText: Colors.white);
        print('Admin credentials not found');
        return 'error';
      }

      bool isValidEmail(String email) {
        return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
      }

      if (newEmail.isNotEmpty && !isValidEmail(newEmail)) {
        Get.snackbar('Error', 'Invalid email format',
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.red,
            colorText: Colors.white);
        print('Invalid email format: $newEmail');
        return 'error';
      }

      if (newPassword.isNotEmpty && newPassword.length < 6) {
        Get.snackbar('Error', 'Password must be at least 6 characters',
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.red,
            colorText: Colors.white);
        print('Invalid password: too short');
        return 'error';
      }

      // Logout admin to sign in restaurant user
      await FirebaseAuth.instance.signOut();
      print('Admin logged out successfully');

      // Sign in restaurant user
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: currentEmail,
        password: currentPassword,
      );
      print('Restaurant user logged in with ID ${userCredential.user?.uid}');
      User? restaurantUser = userCredential.user;

      if (restaurantUser == null) {
        Get.snackbar('Error', 'Failed to authenticate restaurant user',
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.red,
            colorText: Colors.white);
        print('Failed to authenticate restaurant user');
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: adminEmail,
          password: adminPassword,
        );
        print('Admin logged back in');
        return 'error';
      }

      // Update Email if needed
      if (newEmail.isNotEmpty && newEmail != currentEmail) {
        try {
          if (restaurantUser.uid.isEmpty) {
            throw Exception('User UID is empty');
          }
          if (newEmail.isEmpty) {
            throw Exception('New email is empty');
          }
          final payload = {
            'uid': restaurantUser.uid,
            'newEmail': newEmail.trim().toLowerCase(),
          };
          print('Sending payload to Cloud Function: $payload');

          final callable = FirebaseFunctions.instanceFor(region: 'us-central1')
              .httpsCallable('updateUserEmail');
          final response = await callable.call(payload);
          print('Cloud Function response: ${response.data}');

          if (response.data['success'] == true) {
            print(
                'Restaurant user email updated to $newEmail via Cloud Function');

            // *** FIX: Re-sign in with new email to refresh token ***
            UserCredential newCredential =
                await FirebaseAuth.instance.signInWithEmailAndPassword(
              email: newEmail,
              password: currentPassword,
            );
            restaurantUser = newCredential.user;
            print(
                'Restaurant user re-logged in with updated email: ${restaurantUser?.uid}');
          } else {
            String errorMessage = response.data['error'] ?? 'Unknown error';
            String userFriendlyMessage;
            switch (errorMessage) {
              case 'Email already in use':
                userFriendlyMessage = 'Email is already in use';
                break;
              case 'Invalid email format':
                userFriendlyMessage = 'Invalid email format';
                break;
              case 'User not found':
                userFriendlyMessage = 'User not found';
                break;
              default:
                userFriendlyMessage = 'Failed to update email: $errorMessage';
            }
            Get.snackbar('Error', userFriendlyMessage,
                snackPosition: SnackPosition.TOP,
                backgroundColor: Colors.red,
                colorText: Colors.white);
            print('Email update failed: $errorMessage');
            await FirebaseAuth.instance.signInWithEmailAndPassword(
              email: adminEmail,
              password: adminPassword,
            );
            print('Admin logged back in');
            return 'error';
          }
        } catch (e) {
          Get.snackbar('Error', 'Failed to update email: $e',
              snackPosition: SnackPosition.TOP,
              backgroundColor: Colors.red,
              colorText: Colors.white);
          print('Email update failed: $e');
          await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: adminEmail,
            password: adminPassword,
          );
          print('Admin logged back in');
          return 'error';
        }
      }

      // Update Password if needed
      if (newPassword.isNotEmpty && restaurantModel!.password != newPassword) {
        try {
          await restaurantUser?.updatePassword(newPassword);
          print('Restaurant user password updated');
        } catch (e) {
          if (e is FirebaseAuthException && e.code == 'requires-recent-login') {
            try {
              AuthCredential credential = EmailAuthProvider.credential(
                email: currentEmail,
                password: currentPassword,
              );
              await restaurantUser?.reauthenticateWithCredential(credential);
              print('Re-authentication successful');
              await restaurantUser?.updatePassword(newPassword);
              print('Restaurant user password updated after re-auth');
            } catch (reAuthError) {
              Get.snackbar('Error', 'Failed to update password: $reAuthError',
                  snackPosition: SnackPosition.TOP,
                  backgroundColor: Colors.red,
                  colorText: Colors.white);
              print(
                  'Re-authentication or password update failed: $reAuthError');
              await FirebaseAuth.instance.signInWithEmailAndPassword(
                email: adminEmail,
                password: adminPassword,
              );
              print('Admin logged back in');
              return 'error';
            }
          } else {
            throw e;
          }
        }
      }

      await FirebaseAuth.instance.signOut();
      print('Restaurant user logged out');

      // Sign admin back in
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: adminEmail,
        password: adminPassword,
      );
      print('Admin logged back in');

      return restaurantUser!.uid;
    } catch (e) {
      print('Error updating credentials: $e');
      try {
        String? adminEmail = preferences?.getString('adminEmail');
        String? adminPassword = preferences?.getString('adminPassword');
        if (adminEmail != null && adminPassword != null) {
          await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: adminEmail,
            password: adminPassword,
          );
          print('Admin logged back in after error');
        }
      } catch (signInError) {
        print('Error signing admin back in: $signInError');
      }
      Get.snackbar('Error', 'Failed to update credentials: $e',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white);
      return 'error';
    }
  }

//
}

class UploadedImageModel {
  final Uint8List? bytes;
  final String? url;

  UploadedImageModel({this.bytes, this.url});
}
