import 'dart:io';
import 'dart:isolate';
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
import 'package:shared_preferences/shared_preferences.dart';

import 'main_controller.dart';

bool myFlag = false;
final auth = FirebaseAuth.instance;
SharedPreferences? preferences;
SharedPreferences? remember_me_pref;
Rx<UserModel>? currentUserDataModel;

RemoteMessage? message;

UserModel? currentUser;


ReceivePort port = ReceivePort();

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin= FlutterLocalNotificationsPlugin();

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage _message) async {
  // await Get.put(()=>MainController().onMessage());
  await showNotification(_message);
}


AndroidNotificationChannel channel =const AndroidNotificationChannel(
  'high_importance_channel',
  'high_Imporytance_Notification',
  importance: Importance.high,
  playSound: true,
);
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp();
    await getCurrentUserData();
    await requestLocationPermission();
    await Firebase.initializeApp().then((value) => Get.put(()=>MainController().onInit()));
    // FirebaseAuth.instance.signOut();
    // await Get.put(()=>MainController().onMessage());
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    /*messaging.getToken().then((value) {
    print("token : $value");
  });*/



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





    // FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    //   AwesomeNotifications().createNotificationFromJsonData(message.data);
    // });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      Navigator.of(Get.context!).pushNamed('/navigationPage');
    });

    message = await FirebaseMessaging.instance.getInitialMessage();

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    await flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.createNotificationChannel(channel);
    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
    // FirebaseMessaging messaging = FirebaseMessaging.instance;



    // NotificationSettings settings = await messaging.requestPermission(
    //   alert: true,
    //   announcement: false,
    //   badge: true,
    //   carPlay: false,
    //   criticalAlert: false,
    //   provisional: false,
    //   sound: true,
    // );






  } on FirebaseAuthException catch (e) {
    print('Error: ${e.code} - ${e.message}');
  } catch (e) {
    print('Unhandled error: $e');
  }
  preferences = await SharedPreferences.getInstance();
  remember_me_pref = await SharedPreferences.getInstance();
  // preferences?.clear();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((_) {
    runApp(MyApp());
  });
}

RxBool showcaseInProgress = false.obs;

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(
          textScaler: TextScaler.linear(
              min(MediaQuery.of(context).textScaleFactor, 0.7))),
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
  print("here i am========");
  if(_message.data['title']=="Reminder" && _message.data['title']=="PlayerSubscribedTraining"){

    await Future.delayed(Duration(milliseconds:int.parse(_message.data['reminderTime'].toString())),() {
      RemoteNotification? notification =_message.notification;
      AndroidNotification? androidNotification=_message.notification?.android;
      if(notification!=null && androidNotification!=null ) {


        ///local notification

        flutterLocalNotificationsPlugin.show(
            notification.hashCode, notification.title, notification.body,NotificationDetails(
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
            )
        ));

      }
    },);
  }
  else{
    RemoteNotification? notification =_message.notification;
    AndroidNotification? androidNotification=_message.notification?.android;
    if(notification!=null && androidNotification!=null) {

      ///local notification
      flutterLocalNotificationsPlugin.show(
          notification.hashCode, notification.title, notification.body,NotificationDetails(
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
          )
      ));

    }
  }
}