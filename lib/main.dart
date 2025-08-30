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
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';
import 'main_controller.dart';

// Android channel for notifications
const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'propertyRentalID', // id
  'High Importance Notifications', // title
  importance: Importance.max,
  playSound: true,
);

// FCM background message handler
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
  await Firebase.initializeApp();
  // Initialize local notification plugin
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');
  const DarwinInitializationSettings initializationSettingsIOS =
      DarwinInitializationSettings();
  const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: initializationSettingsIOS,
  );

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  // Handle background messages
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // Disable system notification in foreground
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: false,
    badge: false,
    sound: false,
  );
  try {
    await getCurrentUserData();
    await requestLocationPermission();
  } on FirebaseAuthException catch (e) {
    print('Error: ${e.code} - ${e.message}');
  } catch (e) {
    print('Unhandled error: $e');
  }

  // Temporarily disable topic subscription for testing
  // await subscribeToTopic('allUsers');
  // debugPrint("Subscribed to topic: allUsers");

  preferences = await SharedPreferences.getInstance();
  remember_me_pref = await SharedPreferences.getInstance();

  // Log FCM token
  try {
    FirebaseMessaging.instance.getToken().then((value) {
      print("FCM token: $value");
    });
  } catch (e) {
    print('token error $e');
  }

  // Request notification permission
  await Permission.notification.isDenied.then((value) {
    if (value) {
      Permission.notification.request();
    }
  });
  await SendNotificationService()
      .initialize(); // Initialize FCM + local notifications().initFirebaseNotification();
  debugPrint("SendNotifiation initialized");
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((_) {
    runApp(MyApp());
  });
}

Future<void> subscribeToTopic(String topic) async {
  try {
    await FirebaseMessaging.instance.subscribeToTopic(topic);
    debugPrint("Subscribed to topic: $topic");
  } catch (e) {
    debugPrint("Failed to subscribe to topic: $e");
  }
}

RxBool showcaseInProgress = false.obs;

late PersistentTabController navbarController;

class MyApp extends StatelessWidget {
  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(
          textScaler: TextScaler.linear(
              min(MediaQuery.of(context).textScaleFactor, 0.8))),
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Kaistable',
        home: SplashScreen(),
      ),
    );
  }
}
//
