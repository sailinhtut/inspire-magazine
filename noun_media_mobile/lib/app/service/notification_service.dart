// import 'dart:math';

// import 'package:findem_dating/utils/functions.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:http/http.dart' as http;
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// // import 'package:timezone/data/latest.dart' as tz;
// // import 'package:timezone/timezone.dart' as tz;

// /// Need to initialize at first
// ///
// /// `NotificationServices.instance.init()` in main function
// class NotificationServices {
//   static final _notiPlugIn = FlutterLocalNotificationsPlugin();

//   // Setting Up Plug In
//   static Future<void> init( {void Function(NotificationResponse)? onNotiTapped,BuildContext? context}) async {
//     const androidSettings = AndroidInitializationSettings("@mipmap/ic_launcher");
//     const iosSettings = DarwinInitializationSettings();

//     const initializationSettings = InitializationSettings(android: androidSettings, iOS: iosSettings);

//     // tz.initializeTimeZones();

//     final details = await _notiPlugIn.getNotificationAppLaunchDetails();
//     if (details?.notificationResponse != null && details!.didNotificationLaunchApp) {
//       onNotiTapped?.call(details.notificationResponse!);
//     }

//     await _notiPlugIn.initialize(initializationSettings, onDidReceiveBackgroundNotificationResponse: onNotiTapped, onDidReceiveNotificationResponse: onNotiTapped);
//   }

//   // Getting Notification Details
//   static Future<NotificationDetails> getNotiDetails(String title, String body, {String? image}) async {
//     Uint8List? imageData;
//     if (image != null) imageData = await downloadFile(image);

//     final androidPlatformChannelSpecifics = AndroidNotificationDetails('Findem', 'Findem_Notification',
//         channelDescription: 'Notification Sending For Findem Application',
//         groupKey: 'Findem_Notification_Group',
//         importance: Importance.max,
//         priority: Priority.max,
//         playSound: true,
//         color: Colors.white,
//         enableVibration: true,
//         styleInformation: image == null ? BigTextStyleInformation(body) : BigPictureStyleInformation(ByteArrayAndroidBitmap(imageData!)),
//         largeIcon: image != null ? null : const DrawableResourceAndroidBitmap("app_icon"));

//     const iosPlatformChannelSpecifics = DarwinNotificationDetails();

//     final platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics, iOS: iosPlatformChannelSpecifics);

//     return platformChannelSpecifics;
//   }

//   static Future<Uint8List?> downloadFile(String url) async {
//     final http.Response response = await http.get(Uri.parse(url));
//     if (response.statusCode == 200) return response.bodyBytes;
//     return null;
//   }

//   static Future<void> createNotification(String title, String body, {String? payload, String? image,int? id}) async {
//     final notificationDetail = await getNotiDetails(title, body, image: image);
//     await _notiPlugIn.show(id ?? Random().nextInt(1000), title, body, notificationDetail, payload: payload);
//   }

//   static Future<void> createLocationUpdateNoti(int notiId, String title, String body, {String? payload}) async {
//     final androidPlatformChannelSpecifics = AndroidNotificationDetails('Findem_Tracking', 'Findem_Notification',
//         channelDescription: 'Notification Sending For Findem Application',
//         groupKey: 'Findem_Notification_Group',
//         importance: Importance.min,
//         priority: Priority.min,
//         playSound: false,
//         color: Colors.white,
//         enableVibration: false,
//         sound: null,
//         styleInformation: BigTextStyleInformation(body),
//         actions: [
//           const AndroidNotificationAction('stop_service', "Stop", showsUserInterface: true, titleColor: Colors.red),
//           const AndroidNotificationAction('hide_noti', "Hide", showsUserInterface: true, titleColor: Colors.black),
//         ]);

//     const iosPlatformChannelSpecifics = DarwinNotificationDetails();
//     final platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics, iOS: iosPlatformChannelSpecifics);

//     await _notiPlugIn.show(notiId, title, body, platformChannelSpecifics, payload: payload);
//   }

//   // Future<void> createScheduleNotification(
//   //     String title, String body, int timestamp) async {
//   //   await _notiPlugIn.zonedSchedule(
//   //       Random().nextInt(1000),
//   //       title,
//   //       body,
//   //       tz.TZDateTime.fromMillisecondsSinceEpoch(tz.local, timestamp),
//   //       getNotiDetails(title, body),
//   //       uiLocalNotificationDateInterpretation:
//   //           UILocalNotificationDateInterpretation.absoluteTime,
//   //       androidAllowWhileIdle: true);
//   // }

//   static Future<void> deleteAllScheduledNotifications() async {
//     _notiPlugIn.cancelAll();
//   }

//   /// For testing, Can Delete
//   static void showLocalNotification(String title, String body) {
//     const androidNotificationDetail = AndroidNotificationDetails(
//         '0', // channel Id
//         'general' // channel Name
//         );
//     const iosNotificatonDetail = DarwinNotificationDetails();
//     const notificationDetails = NotificationDetails(
//       iOS: iosNotificatonDetail,
//       android: androidNotificationDetail,
//     );
//     _notiPlugIn.show(0, title, body, notificationDetails);
//   }
// }
