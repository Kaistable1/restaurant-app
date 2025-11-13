import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:kaistable_website/models/usermodel.dart';
import 'package:kaistable_website/splash_screen/splashscreen.dart';
import 'package:kaistable_website/widgets/global_functions.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'main_controller.dart';

// Android notification channel
const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'propertyRentalID',
  'High Importance Notifications',
  importance: Importance.max,
  playSound: true,
);

// FCM background message handler (only runs on mobile)
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  debugPrint(
      "Handling a background message: ${message.messageId}, Title: ${message.notification?.title}");
}

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

bool myFlag = false;
final auth = FirebaseAuth.instance;
SharedPreferences? preferences;
SharedPreferences? remember_me_pref;
Rx<UserModel>? currentUserDataModel;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp();

  // === LOCAL NOTIFICATIONS (MOBILE ONLY) ===
  if (!kIsWeb) {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings();
    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);

    // Set up background message handler
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // Disable foreground notifications
    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: false,
      badge: false,
      sound: false,
    );
  }

  // === USER DATA & PERMISSIONS (WEB-SAFE) ===
  try {
    await getCurrentUserData();

    if (!kIsWeb) {
      await requestLocationPermission();
    }
  } on FirebaseAuthException catch (e) {
    debugPrint('Firebase Auth Error: ${e.code} - ${e.message}');
  } catch (e) {
    debugPrint('Unhandled error: $e');
  }

  // === SHARED PREFERENCES ===
  preferences = await SharedPreferences.getInstance();
  remember_me_pref = await SharedPreferences.getInstance();

  // === FCM TOKEN (MOBILE ONLY) ===
  if (!kIsWeb) {
    try {
      final token = await FirebaseMessaging.instance.getToken();
      debugPrint("FCM token: $token");
    } catch (e) {
      debugPrint('FCM token error: $e');
    }

    // Request notification permission
    final status = await Permission.notification.status;
    if (status.isDenied) {
      await Permission.notification.request();
    }
  }

  // === NOTIFICATION SERVICE (MOBILE ONLY) ===
  if (!kIsWeb) {
    await SendNotificationService().initialize();
    debugPrint("SendNotificationService initialized");
  } else {
    debugPrint("SendNotificationService skipped on web");
  }

  // === ORIENTATION (MOBILE ONLY) ===
  if (!kIsWeb) {
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  // === START APP ===
  runApp(MyApp());
}

// Optional: Subscribe to FCM topic (mobile only)
Future<void> subscribeToTopic(String topic) async {
  if (kIsWeb) return;
  try {
    await FirebaseMessaging.instance.subscribeToTopic(topic);
    debugPrint("Subscribed to topic: $topic");
  } catch (e) {
    debugPrint("Failed to subscribe to topic: $e");
  }
}

// Global reactive flag
RxBool showcaseInProgress = false.obs;

class MyApp extends StatelessWidget {
  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(
        textScaler: TextScaler.linear(
          min(MediaQuery.of(context).textScaleFactor, 0.8),
        ),
      ),
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Kaistable',
        home: SplashScreen(),
      ),
    );
  }
}
