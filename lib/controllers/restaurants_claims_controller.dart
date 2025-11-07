import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:savrly/constants/app_colors.dart';
import 'package:savrly/constants/text_styles.dart';
import 'package:savrly/main.dart';
import 'package:savrly/widgets/global_functions.dart';
import '../models/claims_model.dart';

class RestaurantsClaimsController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    getAllBusinessClaims();
  }

  final passwordController = TextEditingController();
  final emailSubjectController = TextEditingController();
  final emailMessageController = TextEditingController();
  var restaurantsClaims = <RestaurantClaimsModel>[].obs;
  var filteredClaimsRestaurants = <RestaurantClaimsModel>[].obs;
  RestaurantClaimsModel? viewClaimsDetails;

// Fetch all business claims from Firestore and update restaurantsClaims
  Future<void> getAllBusinessClaims() async {
    // try {
    final querySnapshot =
        await FirebaseFirestore.instance.collection('businessClaims').get();
    final claims = querySnapshot.docs
        .map((doc) => RestaurantClaimsModel.fromFirestore(doc))
        .toList();
    restaurantsClaims.assignAll(claims); // Update observable list
    print('Fetched ${claims.length} business claims');
    update();
    // } catch (e) {
    //   print('Error fetching all business claims: $e');
    //   Get.snackbar('Error', 'Failed to fetch business claims: $e');
    // }
  }

  // Delete a business claim from Firestore and update restaurantsClaims
  Future<void> deleteBusinessClaim(String docID) async {
    try {
      await FirebaseFirestore.instance
          .collection('businessClaims')
          .doc(docID)
          .delete();
      restaurantsClaims
          .removeWhere((claim) => claim.id == docID); // Update observable list
      print('Deleted business claim with docID: $docID');
      Get.snackbar('Success', 'Business claim deleted successfully');
    } catch (e) {
      print('Error deleting business claim: $e');
      Get.snackbar('Error', 'Failed to delete business claim: $e');
    }
  }

  filteredClaims({search}) {
    if (search.isEmpty) {
      filteredClaimsRestaurants.value = restaurantsClaims;
    } else {
      filteredClaimsRestaurants.value = restaurantsClaims
          .where((subAdmin) =>
              subAdmin.restaurantData.resName
                  .toLowerCase()
                  .contains(search.toLowerCase()) ||
              subAdmin.ownerName.toLowerCase().contains(search.toLowerCase()))
          .toList();
    }
    update();
  }

  approvedResturnatsClaims() async {
    try {
      RestaurantClaimsModel restaurantClaimModel = viewClaimsDetails!;
      // Show loading dialog
      loadingDialog();

      // await FirebaseFirestore.instance
      //     .collection('restaurants')
      //     .doc(restaurantClaimModel.restaurantData.docID)
      //     .collection('operatingHours')
      //     .doc('Monday').delete();
      // await FirebaseFirestore.instance
      //     .collection('restaurants')
      //     .doc(restaurantClaimModel.restaurantData.docID)
      //     .collection('operatingHours')
      //     .doc('Tuesday').delete();
      // await FirebaseFirestore.instance
      //     .collection('restaurants')
      //     .doc(restaurantClaimModel.restaurantData.docID)
      //     .collection('operatingHours')
      //     .doc('Wednesday').delete();
      // await FirebaseFirestore.instance
      //     .collection('restaurants')
      //     .doc(restaurantClaimModel.restaurantData.docID)
      //     .collection('operatingHours')
      //     .doc('Thursday').delete();
      // await FirebaseFirestore.instance
      //     .collection('restaurants')
      //     .doc(restaurantClaimModel.restaurantData.docID)
      //     .collection('operatingHours')
      //     .doc('Friday').delete();
      // await FirebaseFirestore.instance
      //     .collection('restaurants')
      //     .doc(restaurantClaimModel.restaurantData.docID)
      //     .collection('operatingHours')
      //     .doc('Saturday').delete();
      // await FirebaseFirestore.instance
      //     .collection('restaurants')
      //     .doc(restaurantClaimModel.restaurantData.docID)
      //     .collection('operatingHours')
      //     .doc('Sunday').delete();
      //
      // await FirebaseFirestore.instance
      //     .collection('restaurants')
      //     .doc(restaurantClaimModel.restaurantData.docID)
      //     .delete();

      // Restaurant is a separate entity - keep its own document ID
      final restaurantDocID = restaurantClaimModel.restaurantData.docID;
      
      // IMPORTANT: Check if this restaurant already has an owner account
      // First, check if the restaurant document has credentials (indicates it might have an owner)
      final restaurantDoc = await FirebaseFirestore.instance
          .collection('restaurants')
          .doc(restaurantDocID)
          .get();

      String? existingRestaurantEmail;
      if (restaurantDoc.exists) {
        final restaurantData = restaurantDoc.data();
        existingRestaurantEmail = restaurantData?['resEmail'] as String?;
      }

      // If restaurant has an email, check if an owner account exists for this restaurant
      if (existingRestaurantEmail != null && existingRestaurantEmail.isNotEmpty) {
        // Query restaurantOwner by email to find existing owner
        QuerySnapshot existingOwnersQuery = await FirebaseFirestore.instance
            .collection('restaurantOwner')
            .where('email', isEqualTo: existingRestaurantEmail)
            .limit(1)
            .get();

        if (existingOwnersQuery.docs.isNotEmpty) {
          // Found an owner with this email, verify it's for the same restaurant
          final existingOwnerDoc = existingOwnersQuery.docs.first;
          final existingOwnerData = existingOwnerDoc.data() as Map<String, dynamic>;
          final existingOwnerEmail = existingOwnerData['email'] as String? ?? '';
          final existingOwnerRestaurantData = existingOwnerData['restaurantData'] as Map<String, dynamic>?;
          final existingOwnerRestaurantDocID = existingOwnerRestaurantData?['docID'] as String?;

          // Verify this owner is for the same restaurant
          if (existingOwnerRestaurantDocID == restaurantDocID) {
            // Check if it's the same person trying to reclaim (same email)
            if (existingOwnerEmail.toLowerCase() == restaurantClaimModel.email.toLowerCase()) {
              // Same person - allow reclaiming/updating credentials
              print('⚠️ Same owner reclaiming restaurant: $restaurantDocID');
              // Continue with the approval process below
            } else {
              // Different person trying to claim an already-owned restaurant
              // Show dialog to inform admin and get confirmation
              Get.back(); // Close loading dialog first
              
              bool? shouldProceed = await Get.dialog<bool>(
                AlertDialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  title: Text(
                    'Restaurant Already Has Owner',
                    style: headingText.copyWith(fontSize: 18),
                  ),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'This restaurant already has an owner account.',
                        style: simpleText.copyWith(
                          fontSize: 16,
                          color: secondaryColor,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Existing Owner:',
                        style: simpleText.copyWith(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: secondaryColor,
                        ),
                      ),
                      Text(
                        existingOwnerEmail,
                        style: simpleText.copyWith(
                          fontSize: 14,
                          color: primaryColor,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'New Claim Email:',
                        style: simpleText.copyWith(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: secondaryColor,
                        ),
                      ),
                      Text(
                        restaurantClaimModel.email,
                        style: simpleText.copyWith(
                          fontSize: 14,
                          color: primaryColor,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Approving this claim will replace the existing owner account. Do you want to proceed?',
                        style: simpleText.copyWith(
                          fontSize: 14,
                          color: Colors.red,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Get.back(result: false); // Cancel
                      },
                      child: Text(
                        'Cancel',
                        style: headingText.copyWith(
                          fontSize: 14,
                          color: Colors.blueAccent,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Get.back(result: true); // Accept
                      },
                      child: Text(
                        'Accept',
                        style: headingText.copyWith(
                          fontSize: 14,
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                barrierDismissible: false,
              );

              if (shouldProceed != true) {
                // User cancelled
                print('❌ Claim approval cancelled by admin');
                return;
              }

              // User accepted - proceed with claim approval
              print('⚠️ Admin approved claim replacement for restaurant $restaurantDocID');
              // Continue with the approval process below (re-open loading dialog)
              loadingDialog();
            }
          }
        }
      }

      String authUid = await assignedCredencialsLogin(
          email: restaurantClaimModel.email,
          userPassword: passwordController.text);

      if (authUid != 'error') {
        // Restaurant already exists, just update email and password
        await FirebaseFirestore.instance
            .collection('restaurants')
            .doc(restaurantDocID)
            .update({
          'resEmail': restaurantClaimModel.email,
          'password': passwordController.text,
          // Note: Do NOT update restaurant's docID field with auth UID
          // Restaurant keeps its own document ID
        });

        print(
            '✅ Restaurant updated with credentials: $restaurantDocID');

        // Check if restaurant owner document already exists with this auth UID
        // RestaurantOwner is a separate entity with auth UID as its document ID
        final ownerDoc = await FirebaseFirestore.instance
            .collection('restaurantOwner')
            .doc(authUid)
            .get();

        // Prepare restaurant data map
        // Keep the restaurant's own document ID (not auth UID)
        final restaurantDataMap =
            await restaurantClaimModel.restaurantData.toMap();
        restaurantDataMap['docID'] = restaurantDocID; // Restaurant's own document ID
        restaurantDataMap['resEmail'] = restaurantClaimModel.email;
        restaurantDataMap['password'] = passwordController.text;

        // RestaurantOwner is a separate entity with auth UID as its document ID
        // The docID field should also contain the auth UID (not restaurant doc ID)
        final ownerData = {
          'docID': authUid, // Auth user's UID (same as document ID)
          'contact': restaurantClaimModel.contact,
          'email': restaurantClaimModel.email,
          'img': restaurantClaimModel.restaurantData.imagesList.isEmpty
              ? 'https://s3-media2.fl.yelpcdn.com/bphoto/iCP4QYCjWf9i-qDIBQrsnQ/o.jpg'
              : restaurantClaimModel.restaurantData.imagesList.first,
          'password': passwordController.text,
          'restaurantData': restaurantDataMap, // Contains restaurant's own docID inside
        };

        if (ownerDoc.exists) {
          // Update existing owner document
          await FirebaseFirestore.instance
              .collection('restaurantOwner')
              .doc(authUid)
              .set(ownerData, SetOptions(merge: true));

          print('✅ Restaurant owner document updated - Document ID: $authUid, Restaurant DocID: $restaurantDocID');
        } else {
          // Create new owner document
          ownerData['createdAt'] = DateTime.now();
          await FirebaseFirestore.instance
              .collection('restaurantOwner')
              .doc(authUid)
              .set(ownerData);

          print('✅ Restaurant owner document created - Document ID: $authUid, Restaurant DocID: $restaurantDocID');
        }

        // Update the claim status
        await FirebaseFirestore.instance
            .collection('businessClaims')
            .doc(restaurantClaimModel.id)
            .update({
          'status': 'Approved',
          'password': passwordController.text,
        });

        print('✅ Business claim approved: ${restaurantClaimModel.id}');

        await getAllBusinessClaims();
        Get.back();
        Get.snackbar('Success!', "Restaurant claim approved successfully",
            maxWidth: 400,
            backgroundColor: primaryColor,
            colorText: Colors.white);
      } else {
        Get.back();
        Get.snackbar('Error', "Failed to create restaurant account",
            maxWidth: 400,
            backgroundColor: Colors.red,
            colorText: Colors.white);
      }
    } catch (e) {
      Get.back(); // Close loading dialog
      Get.snackbar('Error', "Failed to approve restaurant claim: $e",
          maxWidth: 400, backgroundColor: Colors.red, colorText: Colors.white);
      print('❌ Error approving restaurant claim: $e');
    }
  }

  Future<String> assignedCredencialsLogin(
      {required String email, required String userPassword}) async {
    // Get admin credentials from SharedPreferences
    String? adminEmail = preferences?.getString('adminEmail');
    String? adminPassword = preferences?.getString('adminPassword');

    try {
      // Sign out temporarily
      await FirebaseAuth.instance.signOut();
      print('admin logout successfully');
      // Create restaurant user
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: userPassword,
      );
      print(
          'restaurant user registered successfully with id ${userCredential.user?.uid}');
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
        print('failed to create restaurant');
      }
      return newUser!.uid;
    } catch (e) {
      // Sign out restaurant
      await FirebaseAuth.instance.signOut();
      print('logout restaurant');
      // Sign admin back in
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: adminEmail!,
        password: adminPassword!,
      );
      Get.back();
      Get.snackbar('Error', 'Failed to create restaurant $e',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white);
      print('create restaurant issue $e');
      return 'error';
    }
  }

  // Delete a business claim from Firestore and update restaurantsClaims
  RxBool isSending = false.obs;

  Future<void> sendEmail({required String to}) async {
    var headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json', // Added for compatibility
    };
    var data = json.encode({
      "to": to,
      "subject": emailSubjectController.text,
      "message": emailMessageController.text,
    });

    try {
      print('Sending email to: $to');
      print('Request body: $data');
      print('Headers: $headers');

      var response = await http.post(
        Uri.parse('https://sendemail-6nrfvx3mia-uc.a.run.app/'),
        headers: headers,
        body: data,
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        print('Email sent successfully: ${json.decode(response.body)}');
      } else {
        print('Failed to send email: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Error sending email: $e');
    }
  }
}
