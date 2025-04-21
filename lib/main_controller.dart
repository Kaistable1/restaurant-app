import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:firebase_messaging_platform_interface/src/notification_settings.dart' as firebase_settings;

// import 'package:alarm/model/alarm_settings.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
// import 'package:googleapis_auth/auth_io.dart' as auth;

import 'main.dart';


class MainController extends GetxController {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  @override
  Future<void> onInit() async {
    super.onInit();
    await initializeNotifications();
    await getNotificationPermission();
    onInitFrameCallBack();
    await onMessage();
    checkAndroidScheduleExactAlarmPermission();
  }

  Future<void> initializeNotifications() async {
    tz.initializeTimeZones();
    final InitializationSettings initializationSettings = InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      iOS: DarwinInitializationSettings(
          defaultPresentSound: true,
          requestSoundPermission: true
      ),
    );
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> checkAndroidScheduleExactAlarmPermission() async {
    final status = await Permission.scheduleExactAlarm.status;
    print('Schedule exact alarm permission: $status.');
    if (status.isDenied) {
      print('Requesting schedule exact alarm permission...');
      final res = await Permission.scheduleExactAlarm.request();
      print('Schedule exact alarm permission ${res.isGranted
          ? ''
          : 'not'} granted.');
    }
  }



  /* Future<void> scheduleNotification(reminderDateTime, String title,
      String body) async {
    final scheduledNotificationDateTime = DateTime.fromMillisecondsSinceEpoch(
        reminderDateTime);
    final tz.TZDateTime tzDateTime = tz.TZDateTime.from(
        scheduledNotificationDateTime, tz.local);

    print('Scheduled Notification DateTime: $scheduledNotificationDateTime');
    print('Scheduled TZDateTime: $tzDateTime');

    final androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'your_channel_id',
      'your_channel_name',
      channelDescription: 'your_channel_description',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: false,
      sound: RawResourceAndroidNotificationSound('ios_sound.caf'),
      playSound: true,
      enableVibration: true,
      enableLights: true,
      // largeIcon: DrawableResourceAndroidBitmap('@mipmap/ic_launcher'),
    );
    final iOSPlatformChannelSpecifics = DarwinNotificationDetails();
    final platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );

    await flutterLocalNotificationsPlugin.zonedSchedule(
      0, // Notification ID
      title,
      body,
      tzDateTime,
      platformChannelSpecifics, androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,

      // androidAllowWhileIdle: true,

      // uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation
      //     .absoluteTime, androidScheduleMode: AndroidScheduleMode.alarmClock,
    ).catchError((error) {
      print('Error scheduling notification: $error');
    }).whenComplete(() {
      print('Notification scheduled successfully');
    });
  }*/

  Future<void> getNotificationPermission() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    firebase_settings.NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else
    if (settings.authorizationStatus == AuthorizationStatus.provisional) {
      print('User granted provisional permission');
    } else {
      print('User declined or has not accepted permission');
    }
  }


  void onInitFrameCallBack() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (kDebugMode) {
        print('A new ON INIT event was published!');
      }
      if (message != null) {
        notificationNavigation(message!);
      }
    });
  }

  void notificationNavigation(RemoteMessage message) {
    print("Reminder");
    print("Reminder NavID ${message.data["navigationId"]}");
    print("Reminder ProgramID ${message.data["SubscriberProgramId"]}");
    /*Future.delayed(const Duration(milliseconds: 1000), () async {
      if (message.data["route"] == "FreeWorkoutPlan") {
        await FirebaseFirestore.instance.collection("Users").doc(
            message.data["userId"]).get().then((user) {
          if (user.exists) {
            UserModel userModel = UserModel.fromDocumentSnapshot(user);
            Get.to(() =>
                FreeWorkoutPlan(user: userModel,
                    subscriberProgramId:  message.data["SubscriberProgramId"],docId: message.data["navigationId"]));
          }
        });
      } else if (message.data["route"] == "PlayerSubscribedTraining") {
        await FirebaseFirestore.instance.collection("SubscriberProgram").doc(
            message.data["navigationId"]).get().then((value) {
          if (value.exists) {
            SubscriberProgramModel data = SubscriberProgramModel
                .fromDocumentSnapshot(
                value.data() as DocumentSnapshot<Map<String, dynamic>>);
            Get.to(() => PlayerSubscribedTraining(data: data));
          }
        });
      } else if (message.data["route"] == "FreeChat") {
        Get.to(() =>
            FreeChat(chatId: message.data["navigationId"],
                userId: message.data["userId"]));
      } else if (message.data["title"] == "Reminder") {

        loadingDialog(loading: true, message: "Wait...");
        FirebaseFirestore.instance.collection("SubscriberProgram").doc(
            message.data["SubscriberProgramId"]).collection("SubscriptionPlanTotal").doc(message.data["navigationId"]).get().then((value) {
          if (value.exists) {
            SubscriberProgramModel data = SubscriberProgramModel
                .fromDocumentSnapshot(
                value.data() as DocumentSnapshot<Map<String, dynamic>>);
            Get.off(() => PlayerSubscribedTraining(data: data));
          }
        }).onError((error, stackTrace) {
          customAlertDialog("Error", "Something went wrong");
        });
      } else if (message.data["title"] == "New Message") {
        Get.off(() =>
            FreeChat(chatId: message.data["navigationId"],
                userId: message.data["userId"]));
      }
    });*/
  }

  Future<void> onMessage() async {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      if (kDebugMode) {
        print('A new onMessage event was published!');
      }
      print("message ${message.data["reminderTime"]}");
      await showNotification(message);
    });
  }

  Future<void> showNotification(RemoteMessage message) async {

    const androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'your_channel_id',
      'your_channel_name',
      channelDescription: 'your_channel_description',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: false,
    );

    const platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );

    print('Notification ID: ${message.notification!.title}');
    if(Platform.isAndroid){
      if (message.data["title"] == "Reminder" || message.data["title"] == "تنبيه"){
        final reminderTime = DateFormat('dd/MM/yyyy hh:mm a').format(DateTime.parse(message.data["reminderTime"]));
        await flutterLocalNotificationsPlugin.show(
          0, // Notification ID
          '${message.notification!.title} ${reminderTime}',
          message.notification!.body,
          platformChannelSpecifics,
        );
      }else{
        await flutterLocalNotificationsPlugin.show(
          0, // Notification ID
          message.notification!.title,
          message.notification!.body,
          platformChannelSpecifics,
        );
      }
    }
    if (message.data["title"] == "Reminder" || message.data["title"] == "تنبيه"){
      final reminderTime = DateFormat('dd/MM/yyyy hh:mm a').format(DateTime.parse(message.data["reminderTime"]));
      await flutterLocalNotificationsPlugin.show(
        0, // Notification ID
        '${message.notification!.title} ${reminderTime}',
        message.notification!.body,
        platformChannelSpecifics,
      );
    }else{
      await flutterLocalNotificationsPlugin.show(
        0, // Notification ID
        message.notification!.title,
        message.notification!.body,
        platformChannelSpecifics,
      );
    }

    print('Notification DateTime: ${tz.TZDateTime.now(tz.local).add(
        const Duration(minutes: 1))}');

    print(message.data["title"]);
    print(message.data["title"]);

    if (message.data["title"].toString().contains("Reminder") || message.data["title"].toString().contains("تنبيه")) {

      DateTime dateTime = DateTime.parse(message.data["reminderTime"]);
      print(dateTime);

      final formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(dateTime);
      print(formattedDate);
      String trimmedDateTime = formattedDate.replaceAll(
          RegExp(r'\.(\d{3})\d+Z'), '.001Z');
      //
      print('trimmedDateTime.......${tz.TZDateTime.from(DateTime.parse(trimmedDateTime), tz.local)}');
      // Notify(tz.TZDateTime.from(DateTime.parse(trimmedDateTime), tz.local),
      //     message.notification!.title, message.notification!.body);
    }
    else {

    }
  }

 /* Future<String> getAccessToken() async {
    // Your client ID and client secret obtained from Google Cloud Console
    final serviceAccountJson = {
      "type": "service_account",
      "project_id": "restaurantwebsite-4bdd8",
      "private_key_id": "989bd1e3e63d28e4c8ae65cc466563750af111c0",
      "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQC8TBp3eNeq3fNT\nE82jzsOENaLbL/dM/ObNiJnXo8z1TXJyRSEc14r/OKvWS6ByudMALnJtKodBTOsV\n2IRSgd8mkHMuRyOdpMimEmDndvUnQugQigJ8tzkxRyp9CxifoGQAatRNxR8y01wm\n2cGpgkm3mIt+IqXYHO5VmtfPWQ6XsVnnNwQiVsgyLq6TXAvzP+CInWi+ozkKL8fa\nyVDdiRiO8O/cHXZdXHjID9R1XS1B8qScmiNINpumH623Djh7jzpknNDedR57nOF9\nbX/zAuVe5J0GQ5ZScxZKoGK9IsmUTvTqWfRTqBeQphdVYMCOHapDE8V3c4/L2oES\nH67wpsjnAgMBAAECggEAMi3xy67ngoB9jME1Rxcd4YjNqq3gsKKg+1sQ7HeZcjG+\ncxdbGK2UPCmlGYmz63777QtzsQXpX4yZBYxazwYPKt7J4yZQJn24fxFcw7Je6KSa\n5XVx7jyBwFEf0Iz5deivXbEafNMwWkIbR7s2Me8nqAa9/dJL8gjbtvJ52qb4DZJf\nxq4dPvzR6Vh4oH+YKiyYFWqT2vAMlSu1+t18i4jZgyLwDD39ClebsnhmVZTi4PSt\nfN/1/kUsbb27M7BgF5zHThnex1rrp4V+CTTmSL/khqQ/pjvqD71IgPLk+F2UuvmU\nOZ1qTrHx94DibKqhf2dFuvFshQRP10YUgDWQMKswsQKBgQDcZg77TGXSJy/epDjl\n28GfluQM1ybaju57hhT/dm/lqlTY7UNNlhQBs34YMk7TgPPkqWbjZx1FQrdb0cKr\nYGNkgbZCHyYbsFc/QtB15ILqq4Cd1h1eJryRHo/alAwyMcApit4R/IyEIRsnEZbp\nX/LxPNVg8x/6LQeh3Lh1T0zqjwKBgQDatpYDg25YnWSJ024+/7i8IQPvMZy2HiTU\nkUdQ3+6pMm+/LHGwOiW9c6OP78+I6R7JEuJLw3GRVDR2DO+tw5teWl/eOBRSEnLU\nmQ4eIODZZ6RXN14MBrnfkFzXjveWqJpxy7kYu+vEUC1R1ZMxi7PFpESlEFOSZtiu\nAzLzAVNIKQKBgQCNKRTZYUIpyo1/ZOFIX2rxAxzHGJo7C6a1GNikEkBy8ZhsY/Ji\nZAgmWscdSkNwdbxALTvH1EhMDwIPXhb32sFuIyIP0ZF/1H7c9rc7ewNauEOlU/j1\nT4wgyllKnt383B5+vQGktYNuMSIJ8NseWCTq25KzCKTngCXORuchw4u5AwKBgQCV\nQU0WkLbZGm/l7repnnG/UPiSX1UGo4OW3J3Cf08rgBPqbrYXAVeH9kaEj68dS5mK\ntqxf77ys5L34YdOezYJV3W7XA4Y6jAR5OQn9XYqUUrpAGrS/mEd4Xdg98n7b/auI\nRPLIAlZe3ihPVGTixuej1PpTetTNcAomlmBKnXjsIQKBgCYeOOhBXQVUHSyrYgVO\nD1X9eT70jYJiCNYjAU6hyohbTdZMN5ueB/WwsJs3JMEyC2VwnfZAbSo4w1X8tb7k\n5OIIhH7jE2yH3KOzbTEnGWYxbTtki8bOr+Zu4lrI60oCB0nD71Osq9OwNjSg5ztf\nu1YsOrSBHPQMFFw985Wieyn0\n-----END PRIVATE KEY-----\n",
      "client_email": "firebase-adminsdk-q09x4@restaurantwebsite-4bdd8.iam.gserviceaccount.com",
      "client_id": "109139757324442988323",
      "auth_uri": "https://accounts.google.com/o/oauth2/auth",
      "token_uri": "https://oauth2.googleapis.com/token",
      "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
      "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/firebase-adminsdk-q09x4%40restaurantwebsite-4bdd8.iam.gserviceaccount.com",
      "universe_domain": "googleapis.com"
    };

    List<String> scopes = [
      "https://www.googleapis.com/auth/userinfo.email",
      "https://www.googleapis.com/auth/firebase.database",
      "https://www.googleapis.com/auth/firebase.messaging"
    ];

    http.Client client = await auth.clientViaServiceAccount(
      auth.ServiceAccountCredentials.fromJson(serviceAccountJson),
      scopes,
    );

    // Obtain the access token
    auth.AccessCredentials credentials =
    await auth.obtainAccessCredentialsViaServiceAccount(
        auth.ServiceAccountCredentials.fromJson(serviceAccountJson),
        scopes,
        client);

    // Close the HTTP client
    client.close();

    // Return the access token
    return credentials.accessToken.data;
  }*/


  /*Future<void> sendPushNotification({
    required String route,
    required String token,
    required String body,
    required String title,
    String? image,
    String? navigationId,
    required String userId,
    final  reminderTime,
    String? SubscriberProgramId,
  }) async {
    final String serverKey = await getAccessToken(); // Your FCM server key
    const String fcmEndpoint =
        'https://fcm.googleapis.com/v1/projects/restaurantwebsite-4bdd8/messages:send';

    print("fcmkey : $token");
    final Map<String, dynamic> message = {
      'message': {
        'token': token,
        'notification': {
          'body': body,
          'title': title,
          // 'sound': true
        },
        // "apns": {
        //   "payload": {
        //     "aps": {
        //       "sound": "sound_file.wav"
        //     }
        //   }
        // },
        'data': <String, dynamic>{
          'click_action': "FLUTTER_NOTIFICATION_CLICK",
          'status': 'done',
          'current_user_fcm_token': token,
          'body': body,
          // 'sound': true,
          'title': title,
          'userId': userId,
          'SubscriberProgramId': SubscriberProgramId ?? '',
          "navigationId": navigationId ?? '', // Handle nulls with empty string
          "reminderTime": reminderTime?.toString() ?? '', // Convert to string
          "route": route,
          "scheduledTime": reminderTime?.toString() ?? '', // Convert to string
        },
      }
    };

    final http.Response response = await http.post(
      Uri.parse(fcmEndpoint),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $serverKey',
      },
      body: jsonEncode(message),
    );

    if (response.statusCode == 200) {
      print('FCM message sent successfully');
    } else {
      print('Failed to send FCM message: ${response.statusCode}');
      print(response.body);
    }
  }*/
}