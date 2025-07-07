// import 'dart:convert';
// import 'dart:ui';

// import 'package:findem_dating/app/service/notification_service.dart';
// import 'package:findem_dating/app/view/main_screen.dart';
// import 'package:findem_dating/app/view/settings_screen.dart';
// import 'package:findem_dating/auth/controller/auth_controller.dart';
// import 'package:findem_dating/auth/controller/user_services.dart';
// import 'package:findem_dating/auth/view/notifications/notification_screen.dart';
// import 'package:findem_dating/auth/view/profile_setting/profile_screen.dart';
// import 'package:findem_dating/auth/view/profile_setting/profile_set_up_screen.dart';
// import 'package:findem_dating/auth/view/profile_setting/visit_profile_screen.dart';
// import 'package:findem_dating/chat/model/chat.dart';
// import 'package:findem_dating/chat/service/findem_chat.dart';
// import 'package:findem_dating/chat/view/chat_screen.dart';
// import 'package:findem_dating/dating/view/met_history_screen.dart';
// import 'package:findem_dating/track_map/service/track_service.dart';
// import 'package:findem_dating/utils/functions.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:get/get.dart';

// import 'package:googleapis_auth/auth_io.dart';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';

// Future<String> generateAccessToken() async {
//   final accountCredentials = ServiceAccountCredentials.fromJson({
//     "type": "service_account",
//     "project_id": "findem-dating-app",
//     "private_key_id": "5c4c797e8a8af08137c360bbfaf75008de186527",
//     "private_key":
//         "-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQDRD2tdS5Ej4Rla\npAfegdk+zZAa2cVxCldLl1JlnCv/RwShmusZwFFGx8VAg1Oluxk3e4YpvHz++LmS\nplZz6oPSGR+oT8ch2lMp/zab8IZm/ljqxfuSqE9YY9CXranVcmAcffPMdjfTmVea\nKtd77haci4lJyyz7WUTiId6leL5nhwFYO0vf+wzl/N6nVCqHNGnhFyfyAgnMoNm/\nfLmX99eNT4UKyp6tgb2VUYYoK9lCQXS+n8pLz2gIfSa02x2ON0YDSRcZyZ7MXgea\ne3XcUjVJUDoMoG4L1EopHsi4zc886Qy8qHNNvFA9Yd1UkywAG8MB5l2QEtYTFMO+\nVweNI24pAgMBAAECggEAZA2SH6tbwiUn4jZgwb+5PhJZZlBU6x2826OHPrP4ZosR\nj1o6LC/bdhmDsLVpYgbiMah/dBgOZmSZQ7Mx6vYQsottmDreHbiEVrQa6ZS6bi5K\nVcn89ZpxpubWXNEzV8EOeHRbKr5lR3K690CLsncnATLSuKtxUrXNfsAg82aPEbIw\nl7ro7pZA74F9/LxGMi2biSXIFzBtT+9AMzyrg/XOKjtiHhk1iSy11133VIHpO2Ra\n03zNu1Y4sioRSledCnpV4qv0TWN3fXptWB3Mb9Gm7aX2cgj2rNcf+OQ0LJ6XDgSW\n/4PPmq942oqwZhjwpO9nZe1Uf2ZasnbnKY6CV23C1QKBgQDsgwRtkhwjARYQ5eek\n8Kkd+A6hK+tNoFyBFmZ/FClz0KYQlqWfzTGy8nTLhaa41AKo+0iMMENVlwxkLBXs\nBeFawEzk2IxLPMycoO6D5yf5LYj8+/2L1yPGx1Td3+o9iEkw2tZ79wH/mmPyABWW\nF5qYXoiBsYgV2S02XL9Uqct8cwKBgQDiSVax01mZm1vZtgLoFTxZInmAnrHn/dZO\nPenDo426wFi/HYsc6LvaURS25I53Ughi8soQNjRa6xBWwqXGY8RW2C3SPiwrw3Zl\nInLx3OP8oWYPuazkfiYYkwt1GJQjvAWnoNxUtSUPmAi55yZvKhXmOMxPrn5kk7So\nRWl4YjQ/8wKBgAp70EFvHZIrpSfAmSEFjemHKlbYlIiPWCpcrNRrN18r24CWvOa1\neMN+3dB7ryU4OJn28YNNTF7J4EG8dohMxm14YrAuLSHUoxk6RPhR0cLI0u6r2NRP\nCAXypf9jwoVRujTRLnq2Oz9yP4XlnQ9XIoIohpKBJRAa3Vcwi0acdCmjAoGBAN6+\ncE9FCxrQOf65Um0fkjLvY4i/LcJ+NHj6KuSAV1/wPKuLqkc/tMJ3M5vAqZg8sLKt\n6UdCBBFG9+NfYQ1DYZ5W1+vvdU1y71UoLttzoxwnx65NCCo3Hsrr28hc9F2klDBo\ngNoFIcES1+we489jLwFbAYqh6hqY5qkJAoQUrvgPAoGACGorkimCJby0BcZCyL1x\n+hMjoi4C5oDO/TMfBbqPzBaB/fRtJ2yFG6aCx9JKoTiID4mfaZsmwGSv60eD/J+n\nKjnhJ4xoQWGuEg2IVdKcUXXH/H2O6ssVzNuzGkqHMfu5t5foAqnM5VI/zJlyVFb5\n4f9VdKXe3QFrL04tnPRPtmg=\n-----END PRIVATE KEY-----\n",
//     "client_email": "firebase-adminsdk-emc4u@findem-dating-app.iam.gserviceaccount.com",
//     "client_id": "110941465998209400087",
//     "auth_uri": "https://accounts.google.com/o/oauth2/auth",
//     "token_uri": "https://oauth2.googleapis.com/token",
//     "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
//     "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/firebase-adminsdk-emc4u%40findem-dating-app.iam.gserviceaccount.com",
//     "universe_domain": "googleapis.com"
//   });
//   final scopes = ['https://www.googleapis.com/auth/firebase.messaging'];

//   final client = await clientViaServiceAccount(accountCredentials, scopes);

//   final credentials = client.credentials;

//   return credentials.accessToken.data;
// }

// Future<bool> sendPushMessageWithToken(String token, {required String title, required String body, required Map<String, dynamic> data}) async {
//   try {
//     final accessToken = await generateAccessToken();
//     await http
//         .post(
//           Uri.parse('https://fcm.googleapis.com/v1/projects/findem-dating-app/messages:send'),
//           headers: <String, String>{
//             'Content-Type': 'application/json',
//             'Authorization': 'Bearer $accessToken',
//           },
//           body: jsonEncode({
//             "message": {
//               "token": token,
//               "notification": {"body": body, "title": title},
//               "data": data
//             }
//           }),
//         )
//         .then((value) => dd(value.body.toString()));
//     return true;
//   } catch (e) {
//     dd("error push notification $e");
//   }
//   return false;
// }

// /// Abstract Function for setting up cloud messaging.
// ///
// /// All things integrated and ready to use.
// Future<void> pushNotificationsSetUp() async {
//   await FirebaseMessaging.instance.setAutoInitEnabled(true);
//   await FirebaseMessaging.instance.requestPermission();
//   await CloudMessageServices.init();
//   await NotificationServices.init(onNotiTapped: _localCallback);

//   FirebaseMessaging.onMessage.listen(_foregroundCallback);
//   FirebaseMessaging.onBackgroundMessage(_backgroundCallback);

//   dd("Push Notification Service Started");
// }

// // Foreground Local Notification Handle
// Future<dynamic> _localCallback(NotificationResponse? response) async {
//   if (response == null) return;

//   if (response.actionId == "stop_service") {
//     stopTrackingService();
//     return;
//   }

//   if (response.actionId == "hide_noti") {
//     final pref = await SharedPreferences.getInstance();
//     pref.setBool("hideTrackServiceNoti", true);
//     // reset service to sync shared preference data
//     final trackingServiceEnabled = pref.getBool('trackingService') ?? true;
//     if (trackingServiceEnabled) {
//       await stopTrackingService(message: false);
//       await Future.delayed(const Duration(seconds: 1)); // delay is required to restart background service
//       await startTrackingService(message: false);
//     }
//     return;
//   }

//   dd('Here ${response.payload}');

//   if (response.payload != null && response.payload!.isNotEmpty) {
//     final dataDecode = response.payload != null ? jsonDecode(response.payload!) : {};
//     final routerName = dataDecode["route"];
//     NotificationRouter.launchRoute(routerName, dataDecode);
//   }
// }

// // Foreground Notification Handle
// Future<void> _foregroundCallback(RemoteMessage message) async {
//   if (message.notification != null) {
//     final title = message.notification!.title;
//     final body = message.notification!.body;
//     String? image = message.notification?.android?.imageUrl;

//     if (image != null && image.isEmpty) image = null;

//     dd("Foreground Notification : ${message.notification!.title} and ${message.notification!.body}");
//     dd("Foreground Notification Received Data : ${message.data}");

//     if (message.data["message"] != null) {
//       final chatMessage = ChatMessage.fromCloudMessagingJson(message.data);
//       await FindemChat.receiveMessage(chatMessage);
//       dd('Recevied Message from foreground service ->${chatMessage.message}');
//       NotificationServices.createNotification(title!, body!, image: image, payload: jsonEncode(message.data), id: 1818);
//     } else {
//       NotificationServices.createNotification(title!, body!, image: image, payload: jsonEncode(message.data));
//     }
//   }
// }

// // Background Notification Handle
// Future<void> _backgroundCallback(RemoteMessage message) async {
//   if (message.notification != null) {
//     final title = message.notification!.title;
//     final body = message.notification!.body;
//     String? image = message.notification?.android?.imageUrl;

//     if (image != null && image.isEmpty) image = null;
//     dd("Background Notification : ${message.notification!.title} and  ${message.notification!.body}");
//     dd("Background Recieved Data : ${message.data}");

//     if (message.data["message"] != null) {
//       final chatMessage = ChatMessage.fromCloudMessagingJson(message.data);
//       await FindemChat.init(); // required
//       await FindemChat.receiveMessage(chatMessage);
//       dd('Recevied Message from background service ->${chatMessage.message}');
//     }
//   }
// }

// // Initializing Firebase Messaging Service
// class CloudMessageServices {
//   static final List<String> _topicToSubscribe = ["main"];

//   static Future<String?> getToken() async => await FirebaseMessaging.instance.getToken();

//   static Future<void> init() async {
//     FirebaseMessaging messaging = FirebaseMessaging.instance;

//     messaging.requestPermission(
//       alert: true,
//       announcement: false,
//       badge: true,
//       carPlay: false,
//       criticalAlert: false,
//       provisional: false,
//       sound: true,
//     );

//     await Future.forEach<String>(_topicToSubscribe, (topic) async => messaging.subscribeToTopic(topic));
//   }
// }

// // Redirecting from received notification
// Future<void> awakeOnNotification() async {
//   RemoteMessage? initialMessage = await FirebaseMessaging.instance.getInitialMessage();
//   if (initialMessage != null) {
//     final route = initialMessage.data['route'];
//     NotificationRouter.launchRoute(route, initialMessage.data);
//   }

//   FirebaseMessaging.onMessageOpenedApp.listen((remoteMessage) {
//     final route = remoteMessage.data['route'];
//     NotificationRouter.launchRoute(route, remoteMessage.data);
//   });
// }
