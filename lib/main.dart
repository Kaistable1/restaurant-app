import 'dart:math';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:kaistable_website/models/usermodel.dart';
import 'package:kaistable_website/splash_screen/splashscreen.dart';
import 'package:kaistable_website/widgets/global_functions.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'main_controller.dart';

// android channel for notification
const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'propertyRentalID', // id
  'High Importance Notifications', // title
  importance: Importance.max,
  playSound: true,
);

//messaging
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  debugPrint("Handling a background message: ${message.messageId}");
}

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

RemoteMessage? message; //message to handle notification

bool myFlag = false;
final auth = FirebaseAuth.instance;
SharedPreferences? preferences;
SharedPreferences? remember_me_pref;
Rx<UserModel>? currentUserDataModel;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  message = await FirebaseMessaging.instance.getInitialMessage();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
  try {
    await Firebase.initializeApp();
    // FirebaseAuth.instance.signOut();
    await getCurrentUserData();
    await requestLocationPermission();
  } on FirebaseAuthException catch (e) {
    print('Error: ${e.code} - ${e.message}');
  } catch (e) {
    print('Unhandled error: $e');
  }
  // await Firebase.initializeApp().then((value) => Get.put(()=>MainController().onInit()));

  preferences = await SharedPreferences.getInstance();
  remember_me_pref = await SharedPreferences.getInstance();

  // preferences?.clear();
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  messaging.getToken().then((value) {
    print("token : $value");
    SendNotifiation().sendPushNotification(
        title: "ghghgh",
        currentFCMToken:
            "dDQAUlQGEU0KrhJSDjPMSF:APA91bEEERrn_DeYAz3-aYXbMYJ6Xnr2aws9BzugC-abKIRr8ekW_miBOK9pQWzBbqyJ8IEyE4WoEoaty_DLRJ82WvyF2mG_EmYncRfAMxDhLbZmJDZdWCM",
        messageText: "jasjdhajhs",
        documentID: '',
        status: '');
  });
// await Future.delayed(const Duration(seconds: 3));
  await Permission.notification.isDenied.then((value) {
    if (value) {
      Permission.notification.request();
    }
  });
  await SendNotifiation().initFirebaseNotification();
  AwesomeNotifications().initialize(
    null,
    [
      NotificationChannel(
        channelKey: 'key1',
        channelName: 'Proto Coders Point',
        channelDescription: "Notification example",
        defaultColor: Color(0XFF9050DD),
        ledColor: Colors.white,
        playSound: true,
        enableLights: true,
        enableVibration: true,
      ),
    ],
  );
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((_) {
    runApp(MyApp());
  });
}

RxBool showcaseInProgress = false.obs;

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

showNotification(RemoteMessage _message) async {
  if (_message.data['title'] == "Reminder" &&
      _message.data['title'] == "PlayerSubscribedTraining") {
    await Future.delayed(
      Duration(
          milliseconds: int.parse(_message.data['reminderTime'].toString())),
      () {
        RemoteNotification? notification = _message.notification;
        AndroidNotification? androidNotification =
            _message.notification?.android;
        if (notification != null && androidNotification != null) {
          ///local notification

          flutterLocalNotificationsPlugin.show(
              notification.hashCode,
              notification.title,
              notification.body,
              NotificationDetails(
                  iOS: const DarwinNotificationDetails(
                    presentAlert: true,
                    presentBadge: true,
                    presentSound: true,
                    sound: 'assets/notification/ios_sound.caf',
                    // sound:  'assets/notification/sound_file.wav',
                  ),
                  android: AndroidNotificationDetails(
                    channel.id,
                    channel.name,
                    color: Colors.black,
                    playSound: true,
                    enableVibration: true,
                    // sound: UriAndroidNotificationSound("assets/tunes/pop.mp3"),
                    enableLights: true,
                    icon: '@mipmap/ic_launcher',
                  )));
        }
      },
    );
  } else {
    RemoteNotification? notification = _message.notification;
    AndroidNotification? androidNotification = _message.notification?.android;
    if (notification != null && androidNotification != null) {
      ///local notification
      flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
              iOS: const DarwinNotificationDetails(
                presentAlert: true,
                presentBadge: true,
                presentSound: true,
                // sound: 'assets/notification/ios_sound.caf',
                // sound:  'assets/notification/sound_file.wav',
              ),
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                color: Colors.black,
                playSound: true,
                icon: '@mipmap/ic_launcher',
              )));
    }
  }
}
