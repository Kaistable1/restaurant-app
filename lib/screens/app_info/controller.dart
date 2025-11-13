import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class AppInfoController extends GetxController {
  // Reactive variables to store the text data from Firestore
  final RxString aboutText = ''.obs;
  final RxString privacyPolicyText = ''.obs;
  final RxString termsAndConditionsText = ''.obs;

  // Firestore instance
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Streams for each collection
  Stream<DocumentSnapshot<Map<String, dynamic>>> _aboutStream() {
    return _firestore.collection('about_app').doc('current').snapshots();
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> _privacyPolicyStream() {
    return _firestore.collection('privacy_policy').doc('current').snapshots();
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> _termsAndConditionsStream() {
    return _firestore
        .collection('terms_and_conditions')
        .doc('current')
        .snapshots();
  }

  @override
  void onInit() {
    super.onInit();
    // Bind streams to reactive variables
    bindStreams();
  }

  // Bind Firestore streams to Rx variables
  void bindStreams() {
    // Bind about_app stream
    _aboutStream().listen(
      (snapshot) {
        if (snapshot.exists && snapshot.data() != null) {
          aboutText.value = snapshot.data()!['text'] ?? '';
        } else {
          aboutText.value = '';
          print('No data found for about_app/current');
        }
      },
      onError: (e) {
        print('Error fetching about_app data: $e');
        aboutText.value = '';
      },
    );

    // Bind privacy_policy stream
    _privacyPolicyStream().listen(
      (snapshot) {
        if (snapshot.exists && snapshot.data() != null) {
          privacyPolicyText.value = snapshot.data()!['text'] ?? '';
        } else {
          privacyPolicyText.value = '';
          print('No data found for privacy_policy/current');
        }
      },
      onError: (e) {
        print('Error fetching privacy_policy data: $e');
        privacyPolicyText.value = '';
      },
    );

    // Bind terms_and_conditions stream
    _termsAndConditionsStream().listen(
      (snapshot) {
        if (snapshot.exists && snapshot.data() != null) {
          termsAndConditionsText.value = snapshot.data()!['text'] ?? '';
        } else {
          termsAndConditionsText.value = '';
          print('No data found for terms_and_conditions/current');
        }
      },
      onError: (e) {
        print('Error fetching terms_and_conditions data: $e');
        termsAndConditionsText.value = '';
      },
    );
  }
}
