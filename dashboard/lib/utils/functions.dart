// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'dart:developer' as logger;
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:inspired_blog_panel/api/http_service.dart';
import 'package:inspired_blog_panel/utils/constants.dart';
import 'package:inspired_blog_panel/utils/theme/colors.dart';
import 'package:http/http.dart' as http;

LanceLogger dd = LanceLogger();

/// Debug Output
class LanceLogger {
  void call(String message,
      {bool loading = false, bool response = false, bool emphasized = true}) {
    if (emphasized) {
      logger.log(
          "${response ? "Response 💬" : ""}${loading ? "⏳" : ""}$message",
          name: appName,
          level: 1000);
    } else {
      debugPrint(
          "${response ? "Response 💬" : ""} ${loading ? "⏳" : ""} $message",
          wrapWidth: 800);
    }
  }
}

String uniqueId(int length) {
  String seed = "asdfghjklqwertyuiopzxcvbmn0123456789";
  String result = "";
  for (int i = 0; i < length; i++) {
    result +=
        seed.characters.elementAt(Random().nextInt(seed.characters.length));
  }
  return result;
}

/// Confirm Dialog
Future<void> showConfirmDialog(BuildContext context,
    {required String title,
    required String content,
    required String buttonText,
    required VoidCallback onConfirm,
    Color? accentColor}) async {
  await showDialog(
      context: context,
      builder: (context) => AlertDialog(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [Text(title)],
            ),
            titleTextStyle: TextStyle(
              fontSize: 18,
              color: accentColor ?? Theme.of(context).primaryColor,
              fontWeight: FontWeight.w500,
            ),
            content: Text(
              content,
              style: const TextStyle(color: Colors.white),
            ),
            backgroundColor: const Color(0xff333333),
            scrollable: true,
            titlePadding:
                const EdgeInsets.all(20).copyWith(bottom: 10, top: 15),
            contentPadding:
                const EdgeInsets.all(20).copyWith(bottom: 10, top: 0),
            actionsPadding: const EdgeInsets.only(bottom: 10, right: 10),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            actions: [
              TextButton(
                  style: TextButton.styleFrom(
                      foregroundColor:
                          accentColor ?? Theme.of(context).primaryColor),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("Cancel")),
              TextButton(
                  style: TextButton.styleFrom(
                      foregroundColor:
                          accentColor ?? Theme.of(context).primaryColor),
                  onPressed: onConfirm,
                  child: Text(buttonText)),
            ],
          ));
}

extension ContextExtension on BuildContext {
  // Information
  String get appname => appName;
  String get appDes => description;
  String get pravicyLink => pravicy;
  String get termsLink => terms;
  String get aboutUs => about;

  // MediaQuery
  double get screenWidth => MediaQuery.of(this).size.width;
  double get screenHeight => MediaQuery.of(this).size.height;
  MediaTypes get mediaType =>
      screenWidth < 640 ? MediaTypes.mobile : MediaTypes.desktop;
  bool get isMobile => screenWidth < 640 ? true : false;

  // Themeing
  Color get primary => Theme.of(this).primaryColor;
  Color get foregroundColor => gitHubLightForegroundColor;
  Color get backgroundColor => Theme.of(this).scaffoldBackgroundColor;
  Color get secondBackgroundColor => gitHubLightSecondBackgroundColor;
  Color get surfaceColor => gitHubLightBackgroundColor;
  Color get borderColor => gitHubLightBorderColor;
  Color get textColor => gitHubLightForegroundColor;
  Color get secondaryTextColor => gitHubLightDisabledColor;
  Color get buttonColor => gitHubLightButtonColor;
  Color get selectionBackgroundColor => gitHubLightSelectionBackgroundColor;
  Color get selectionForegroundColor => gitHubLightSelectionForegroundColor;
  Color get highlightColor => primary.withOpacity(0.3);
  Color get infoColor => gitHubLightInfoColor;
  Color get errorColor => gitHubLightErrorColor;
  Color get warningColor => gitHubLightWarningColor;
}

enum MediaTypes { mobile, desktop }

void setSystemUIOverlay({Color? navigationBarColor}) {
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      systemStatusBarContrastEnforced: false,
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: navigationBarColor,
    ),
  );
}

/// GetX Web Toast
void toast(String message,
    {String title = "", IconData? icon, Color iconColor = Colors.green}) {
  Get.snackbar(
    "",
    "",
    titleText: const SizedBox.shrink(),
    messageText: Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) Icon(icon, size: 25, color: iconColor),
          if (icon != null) const SizedBox(width: 10),
          Expanded(
              child: Text(message,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontWeight: FontWeight.w500, color: Colors.white)))
        ],
      ),
    ),
    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
    snackPosition: SnackPosition.TOP,
    backgroundColor: gitHubLightForegroundColor,
    colorText: Colors.white,
    maxWidth: 300,
    duration: const Duration(milliseconds: 1000),
    boxShadows: const [BoxShadow(blurRadius: 10, color: Colors.grey)],
    margin: const EdgeInsets.only(top: 20),
  );
}

void snack(BuildContext context, String message) =>
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));

Widget sizeHeight(double height) => SizedBox(height: height);

Widget sizeWidth(double width) => SizedBox(width: width);

/// Color Converter
MaterialColor getMaterialColor(Color color) {
  final int red = color.red;
  final int green = color.green;
  final int blue = color.blue;

  final Map<int, Color> shades = {
    50: Color.fromRGBO(red, green, blue, .1),
    100: Color.fromRGBO(red, green, blue, .2),
    200: Color.fromRGBO(red, green, blue, .3),
    300: Color.fromRGBO(red, green, blue, .4),
    400: Color.fromRGBO(red, green, blue, .5),
    500: Color.fromRGBO(red, green, blue, .6),
    600: Color.fromRGBO(red, green, blue, .7),
    700: Color.fromRGBO(red, green, blue, .8),
    800: Color.fromRGBO(red, green, blue, .9),
    900: Color.fromRGBO(red, green, blue, 1),
  };

  return MaterialColor(color.value, shades);
}

/// Check Internet
Future<bool> checkConnectivity() async {
  try {
    final result = await InternetAddress.lookup('google.com');
    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      return true;
    }
  } on SocketException catch (_) {
    return false;
  }
  return false;
}

String capitalize(String name) {
  if (name.isEmpty) return name;
  String first = name.substring(0, 1);
  String processed = first.toUpperCase() + name.substring(1, name.length);
  return processed;
}

String splitter(String? username) {
  if (username == null) {
    return "Username";
  }

  final words = username.split(" ");

  if (words.isEmpty) {
    return "No Username";
  } else if (words.isNotEmpty) {
    final firstCap = words[0].substring(0, 1).toUpperCase();
    // final secondCap = words[1].substring(0, 1).toUpperCase();
    return firstCap;
  } else {
    return words.first.toUpperCase();
  }
}

Future<Uint8List> downloadImage(String imageUrl) async {
  final response = await http.get(Uri.parse(imageUrl));

  if (response.statusCode == 200) {
    return response.bodyBytes;
  } else {
    throw Exception('Failed to load image');
  }
}


/// Timestamp to Datetime
///
/// Already handled null safety.
// DateTime timestampToDateTime(dynamic timestamp) {
//   if (timestamp == null) {
//     return DateTime.now();
//   }
//   final milliseconds = (timestamp as Timestamp).millisecondsSinceEpoch;
//   return DateTime.fromMillisecondsSinceEpoch(milliseconds);
// }

// /// Datetime to Timestamp
// Timestamp datetimeToTimestamp(DateTime date) {
//   return Timestamp.fromDate(date);
// }


