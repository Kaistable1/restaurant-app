import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:googleapis_auth/auth_io.dart' as auth;
import 'package:http/http.dart' as http;

class SendNotifiation {
  final _firebaseMessaging = FirebaseMessaging.instance;

// ====-============- setting local notification for receive notification
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  void initNotifications() async {
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'bubbly', // id
      'Notification', // title
      // 'This channel is used for bubbly notifications.', // description
      importance: Importance.max,
    );
    await _firebaseMessaging
        .requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    )
        .then((value) async {
      if (value.authorizationStatus == AuthorizationStatus.authorized) {
        FirebaseMessaging.onMessage.listen((RemoteMessage message) {
          //android
          var initializationSettingsAndroid =
              const AndroidInitializationSettings('@mipmap/ic_launcher');
          //ios
          var initializationSettings =
              InitializationSettings(android: initializationSettingsAndroid);

          /// notification clicking function
          FlutterLocalNotificationsPlugin().initialize(initializationSettings,
              onDidReceiveNotificationResponse: (payload) {});
          RemoteNotification? notification = message.notification;

          flutterLocalNotificationsPlugin.show(
              1,
              notification?.title?.split(',')[0],
              notification?.body,
              payload: 'chatList',
              NotificationDetails(
                android: AndroidNotificationDetails(
                  channel.id,
                  channel.name,
                  // channel.description,
                  // other properties...
                ),
              ));
          print('notification===================');
        });
        await flutterLocalNotificationsPlugin
            .resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin>()
            ?.createNotificationChannel(channel);
      }
    });
  }

  // =============-======= setting send push notification for other devices

  handleMessage(RemoteMessage message) {
    print('message title ${message.notification?.title}');
  }

  initFirebaseNotification() async {
    initNotifications();
    requestNotificationPermission();

    // final fcmToken = Platform.isAndroid
    //     ? await _firebaseMessaging.getToken()
    //     : await _firebaseMessaging.getAPNSToken();
    // print('fcm token $fcmToken');

    //

    await FirebaseMessaging.instance.setAutoInitEnabled(true);

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.notification?.body}');
    });
  }

  Future<void> _firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    // If you're going to use other Firebase services in the background, such as Firestore,
    // make sure you call `initializeApp` before using other Firebase services.
    ///await Firebase.initializeApp();
    print("Handling a background message: ${message.messageType}");
  }

  Future<void> requestNotificationPermission() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    print('Notification permission granted: ${settings.authorizationStatus}');
  }

  //

  Future<String> getAccessToken() async {
    // Your client ID and client secret obtained from Google Cloud Console
    final serviceAccountJson = {
      "type": "service_account",
      "project_id": "restaurantwebsite-4bdd8",
      "private_key_id": "e7970552575d032564082fdef12fdef7e6b74b62",
      "private_key":
          "-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQCZ79AztB/Z556s\nblRqUzFyhqEIw3cLPZyjY9s05xtuCDXOlxV7qcx1RoN1cBRI9iRljdx1uMlaDCYJ\nzdM8xXzq3Y/R8Oezmqn57rlFDS5d1Jnae637FtH7Ttq5BcrwYsTY8J9csEUgMEwP\nXyCCvv0VDROqTc1f3uYoinamfRwNQVdsevJHVplsvdhJFHqijIA/6FTdrFw0Kkku\nA9w+or20lPST3KIE8LgpDKlkP+5DlogHS5xwB9BQXWXw1XCr2K/skrNOv5Jv2X8U\nBpEAuav6soKuDqopLYtOYMNI/7ndtrnY3d+uma84cBfIDtK26oe0DYUZhIb1YD64\nXbGG5hidAgMBAAECggEAFvIC4g4VmFS412F7tjyP2I8eRlDid/u3UziBdn2DXm+d\nW520H1KETi/UTQdHkseTzcprQ+XnJ4O7kMcMF1kloVmkxCmpU+F4OC/AEH2iPWzB\nASrh2FVCt/e9TQqCwTmrt12Il5eTujRQxhLLJQoEbeSc24wM0p9GReE7xd3MtmHd\ndV8TmnJfmAe9M8GgeaIor4+4MlGseF+mhUg180lHcwQ92zQq+w5fz3n17YgG+if9\ntuQ6O3OFmZ4Ooz/QKGSDzKQJh96+pGMV5R/2gc100tvAK3heD9X2YoUU5IplsVv5\nHXisYEguHl79rYdtvDOjXlKcxsqu0vx/rU8Tk3bVQQKBgQDSyXxXONPelt0y2k8t\nlZpMvpwXlamu6KkDM68r/UTRU6IGs1CEVSxqHYy6/u/XC4srfPyaTV+5Y+yIQ2mF\n5Xo6KSsL52boEd9++850lRTGzxDiXlv8A76QJbCDuSbfBTU8wFhOVGlv6SLobo/j\neD2om2UcfD544qMGaxfv03/lXQKBgQC69KAYKDMgxCqotWTS8y6cXNdXN7oQypgs\ncss2U0yEMgxb4oZ2tzTiAgucnr6YPUr/57OrQE8AOA+OanW9f6QXRgAToxAJA2IJ\nk18b0T0/QiqkxGEX8ps3tVmiFjX4yTJ4vZDzpUseHKl84SsKzApXBco+m86jPxqg\ngjBbHBaMQQKBgHRLkfyVb995IOVzqQefaJg6+efRPOMxnj4T/+unOpa7K8PCnwPD\n8lNBpmltSmo9BjWiKcQAOHYSeWfcuZWUPFFmcUeKDi6v3b0ztH6B2gquJ8SdBucO\nMc9Z2/9w4c9eEjdIb/AXhmymFgpjJaP8rRgfVDPZIKaVdBiQcY5yBDhJAoGACrTB\nikCbFPBG5RxmJrJoY+npJwR48kc3yavVOUox4owfKw/g1WGOdLbbRV/N2FgCOH9j\nSZZIL+IF+gjcrzplAjQvAvDelTWNYrD+zFACKuI2IPNiAAYTn3ASLvcIpjOXYVSx\nvVIk6BeKGS2n0ll26h7ZwxYXEkAl3TU3YbBNFkECgYEAiSXHj8zuOYpgraDONlxh\nArLsRPXX2whpbN5zQQ7fwHqJ+mrsZpCNs/tyRo4DVlcv8aRIFUDsR6BXZPjabyM6\nexRXQRctMs+Ps5g6IPxVaSaDyrwkFw+hh96tBAO7KeHi+5aw2Ut8kPWqA9DUF++v\ndIPiaHHbzNs6lBMvWo7/rvU=\n-----END PRIVATE KEY-----\n",
      "client_email":
          "firebase-adminsdk-q09x4@restaurantwebsite-4bdd8.iam.gserviceaccount.com",
      "client_id": "109139757324442988323",
      "auth_uri": "https://accounts.google.com/o/oauth2/auth",
      "token_uri": "https://oauth2.googleapis.com/token",
      "auth_provider_x509_cert_url":
          "https://www.googleapis.com/oauth2/v1/certs",
      "client_x509_cert_url":
          "https://www.googleapis.com/robot/v1/metadata/x509/firebase-adminsdk-q09x4%40restaurantwebsite-4bdd8.iam.gserviceaccount.com",
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
  }

  Future<void> sendPushNotification({
    required String currentFCMToken,
    required String messageText,
    required String title,
    required String documentID,
    required String status,
  }) async {
    print("currentFCMToken: $currentFCMToken");
    try {
      final String serverKey = await getAccessToken();
      const String fcmEndpoint =
          'https://fcm.googleapis.com/v1/projects/restaurantwebsite-4bdd8/messages:send';

      final Map<String, dynamic> message = {
        'message': {
          'token': currentFCMToken,
          'notification': {
            'body': messageText,
            'title': title,
          },
          'data': {
            'documentID': documentID,
            'Status': status,
            'current_user_fcm_token': currentFCMToken,
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
        print('Response body: ${response.body}');
      }
    } catch (e) {
      print('Error sending push notification: $e');
    }
  }

// Future<void> sendFCMMessage({String? messageText,  title}) async {
//   final String serverKey = await getAccessToken(); // Your FCM server key
//   const String fcmEndpoint = 'https://fcm.googleapis.com/v1/projects/bahrain-bid/messages:send';
//
//   print("Sending message to all users");
//   final Map<String, dynamic> message = {
//     'message': {
//       'topic': 'allUsers',
//       'notification': {
//         'body': messageText,
//         'title': title
//       },
//       'data': {
//         'type': 'general',
//       },
//     }
//   };
//
//   final http.Response response = await http.post(
//     Uri.parse(fcmEndpoint),
//     headers: <String, String>{
//       'Content-Type': 'application/json',
//       'Authorization': 'Bearer $serverKey',
//     },
//     body: jsonEncode(message),
//   );
//
//   if (response.statusCode == 200) {
//     print('FCM message sent successfully');
//   } else {
//     print('Failed to send FCM message: ${response.statusCode}');
//     print('Response body: ${response.body}');
//   }
// }
}
