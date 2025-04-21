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
import 'package:googleapis_auth/auth_io.dart' as auth;

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

  Future<String> getAccessToken() async {
    // Your client ID and client secret obtained from Google Cloud Console
    final serviceAccountJson = {
      "type": "service_account",
      "project_id": "sport-traning-app",
      "private_key_id": "a04da5363add8de195440fb54fc7ae9310506586",
      "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQDnhebleMS/d3QL\nrZcHulKR5K3fEIoZxsm8v8ZW8YibADnZI8xgTVtJHRNI2I+RYi7MbrJdtJg345ZF\nZ//ck2JMaW55vciSoygoWdrR7T7QlA2RtuLaIeC7QcG9vDEGOiEgGoCXQ9Wyxgf8\n6F1nrMrqpokwXFvGgDgfggMvLeVPTok4nN2PsHOl7rjferpfjzsMBcbVGtLvCmCL\nLhIeE44G5NZ2fCpCyZ0NS1o7zaABaRwpF1TnaoUUeUjj+pOtXylvlKQZu/vnROsr\nOq2QQjerGG+QODtOSEE1NMJoDdSCmarZsKeH74kTKYvg0zxcQOX7dEQHqEZbFbLq\nGvPMNFT/AgMBAAECggEADfD1NLovTBblqP0HTCgpvVlCKF127hMXUMNSLn1q1r05\nE9yLplI3ffvp47K5VRgkGJv4fPCuqHw5hJe87iD92VC780lnS3/W9N8Rmx8ob3zg\nIvcan+dMVgT2pUswvzQ+4bpW0JpSwuoZJF8wSK7nT8vpaj0VgFV2NlzTfkLK58SF\n5f9IafvzBiQ1CetRn9nJ35SKy3yljAGUMwCZOV14zmJa9rhKxsipc0mZegKdEl4j\nglCyYYSztqkHGiLWHDGnx8zD+0ygMHipVT4+Dt7WTeMBrUPepz1kf2cAmDOK85mu\n377NUSJNFb/0L8zoSldp088LrjDds574pP81p0IQeQKBgQD5gFn0+etpbbu1b2at\n5V771u9Imk3FTumrO9x+SKe3N4yxF5H65XCQFBV0Oulj2IcMtsLlLOSDiwdaUTBt\nfURVPijQyrL+5KQXXE6PY4h1uCsAJ9+C6jAJE3iTtNfwARgjzDGe9duPxxq6f4st\nO6XqJgUHYug89vCRaRPSWD78iwKBgQDtjaxL0cBNyXNaZixXAJg694VEbab+Z0sO\nJP453GHQ+x8PIxDsdO6l615I5CXr9aS4/PzWgzSOmzx+gpN4GHbGAAqDMIzF7dYO\nLRku52hbCgteZNnygfmpJjNI2ehXS6Tfa+za3OBuUeTJOOeGsFsNydS6LIgVCUhs\nu+r/6AIT3QKBgQCcIFcqVuGa/ZHCfU1xb+C6Est1USltWG4cOr9FPs3EdrxRbQBq\nUfzYC9lI/DxjwHDx4cOfiTINpogZWkjFmueRt+3uiYjsu8J648Y9L/mKQI6X8FuL\nHmSkqUyAkV+2zdh/Ph2m7Q5RsDPnlDxRN8wg812eO6Q70gLD208OBy6S9QKBgQCE\nOA+HH9b2NMMktKvHPQh+AZjGbnW9Mcbft41crSIwjCVMaosX4TmXVfrjfUDyJYYq\nhH1B9ENDgHnaPFlSReON7yXqwRIJdIho2YcjyR8XVO7g+icoyFkqYZ231blxJSQ+\nSrbJVpkALkq2CRssp2n2sbjaasDPXJxYEPwKtZq6bQKBgBNEa+RT7LVNty8KIc4s\ncLIUdeKZagK8PZA8pwTnAvqUAuPiz78XuOSYDCDeJaudF5FI89H+OwAi8ub/uvbS\n9PwdXA8SrL0u9RqeEBDlVfKdqpdrAb8+ptSlIW9SLlTnU8efJONdiKutd1W8jbi2\nYqU/77dy/mzZzmegeha7NZyh\n-----END PRIVATE KEY-----\n",
      "client_email": "firebase-adminsdk-5watd@sport-traning-app.iam.gserviceaccount.com",
      "client_id": "111093551752678700327",
      "auth_uri": "https://accounts.google.com/o/oauth2/auth",
      "token_uri": "https://oauth2.googleapis.com/token",
      "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
      "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/firebase-adminsdk-5watd%40sport-traning-app.iam.gserviceaccount.com",
      "universe_domain": "googleapis.com"
    }
    ;

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
  }


  Future<void> sendPushNotification({
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
        'https://fcm.googleapis.com/v1/projects/sport-traning-app/messages:send';

    print("fcmkey : $token");
    final Map<String, dynamic> message = {
      'message': {
        'token': token,
        'notification': {
          'body': body,
          'title': title,
          // 'sound': true
        },
        "apns": {
          "payload": {
            "aps": {
              "sound": "sound_file.wav"
            }
          }
        },
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
  }
}