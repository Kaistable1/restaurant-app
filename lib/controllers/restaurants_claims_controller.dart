import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:savrly/constants/app_colors.dart';
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

      String docID = await assignedCredencialsLogin(
          email: restaurantClaimModel.email,
          userPassword: passwordController.text);

      if (docID != 'error') {
        // Restaurant already exists, just update email and password
        await FirebaseFirestore.instance
            .collection('restaurants')
            .doc(restaurantClaimModel.restaurantData.docID)
            .update({
          'resEmail': restaurantClaimModel.email,
          'password': passwordController.text,
          'docID': docID, // Update with Auth UID
        });

        print(
            '✅ Restaurant updated with credentials: ${restaurantClaimModel.restaurantData.docID}');

        // Check if restaurant owner document already exists
        final ownerDoc = await FirebaseFirestore.instance
            .collection('restaurantOwner')
            .doc(docID)
            .get();

        // Prepare restaurant data map
        final restaurantDataMap =
            await restaurantClaimModel.restaurantData.toMap();
        restaurantDataMap['docID'] = docID;
        restaurantDataMap['resEmail'] = restaurantClaimModel.email;
        restaurantDataMap['password'] = passwordController.text;

        final ownerData = {
          'docID': docID,
          'contact': restaurantClaimModel.contact,
          'email': restaurantClaimModel.email,
          'img': restaurantClaimModel.restaurantData.imagesList.isEmpty
              ? ''
              : restaurantClaimModel.restaurantData.imagesList.first,
          'password': passwordController.text,
          'restaurantData': restaurantDataMap,
        };

        if (ownerDoc.exists) {
          // Update existing owner document
          await FirebaseFirestore.instance
              .collection('restaurantOwner')
              .doc(docID)
              .update(ownerData);

          print('✅ Restaurant owner document updated: $docID');
        } else {
          // Create new owner document
          ownerData['createdAt'] = DateTime.now();
          await FirebaseFirestore.instance
              .collection('restaurantOwner')
              .doc(docID)
              .set(ownerData);

          print('✅ Restaurant owner document created: $docID');
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
