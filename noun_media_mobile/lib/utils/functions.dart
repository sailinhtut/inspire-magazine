// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'dart:developer' as logger;
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

export './custom/ink_ripple_fast.dart';
import 'dart:ui' as ui;

import 'package:inspired_blog/utils/colors.dart';

LanceLogger dd = LanceLogger();

class LanceLogger {
  void call(String message,
      {bool loading = false, bool response = false, bool emphasized = true}) {
    if (emphasized) {
      logger.log(
          "${response ? "Response 💬" : ""}${loading ? "⏳" : ""}$message",
          name: "Findem",
          level: 99999);
    } else {
      debugPrint(
          "${response ? "Response 💬" : ""} ${loading ? "⏳" : ""} $message",
          wrapWidth: 800);
    }
  }
}

Future<void> sleep(int seconds) async =>
    await Future.delayed(Duration(seconds: seconds));

void showLoading({String? message, bool dismiss = false}) {
  Get.dialog(
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Center(child: CircularProgressIndicator()),
          if (message != null) const SizedBox(height: 10),
          if (message != null)
            Material(
                color: Colors.transparent,
                child: Text(message, style: TextStyle(color: mainColor))),
        ],
      ),
      barrierDismissible: dismiss);
}

String? emailValidate(String? value) {
  if (value != null && value.isEmpty) {
    return 'Email is required';
  } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value!)) {
    return 'Invalid email address';
  }
  return null;
}

String? facebookProfileValidate(String? value) {
  if (value != null && value.isEmpty) {
    return 'Link is required';
  } else if (!RegExp(
          r'(?:(?:http|https):\/\/)?(?:www.)?facebook.com\/(?:(?:\w)*#!\/)?(?:pages\/)?(?:[?\w\-]*\/)?(?:profile.php\?id=(?=\d.*))?([\w\-]*)?')
      .hasMatch(value!)) {
    return 'Invalid facebook profile';
  }
  return null;
}

String? snapchatProfileValidate(String? value) {
  if (value != null && value.isEmpty) {
    return 'Link is required';
  } else if (!RegExp(r'(https?:\/\/)?(w{3}\.)?snapchat\.com\/add/\S*')
      .hasMatch(value!)) {
    return 'Invalid snapchat profile';
  }
  return null;
}

String? instagramProfileValidate(String? value) {
  if (value != null && value.isEmpty) {
    return 'Link is required';
  } else if (!RegExp(r'(https?)?:?(www)?instagram\.com/[a-z].{3}')
      .hasMatch(value!)) {
    return 'Invalid instagram profile';
  }
  return null;
}

String? emptyValidate(String? value) {
  if (value != null && value.isEmpty) {
    return 'This field is required';
  }
  return null;
}

String? passwordValidate(String? value) {
  if (value != null && value.isEmpty) {
    return 'Password is required';
  } else if (value!.length < 6) {
    return 'Password should be at least 6 characters';
  }
  return null;
}

String? intValidate(String? value) {
  if (value != null && value.isEmpty) {
    return 'This field is required';
  } else if (int.tryParse(value!) == null) {
    return 'Invalid number';
  }
  return null;
}

String? doubleValidate(String? value) {
  if (value != null && value.isEmpty) {
    return 'This field is required';
  } else if (double.tryParse(value!) == null) {
    return 'Invalid number';
  }
  return null;
}

String? numValidate(String? value) {
  if (value != null && value.isEmpty) {
    return 'This field is required';
  } else if (num.tryParse(value!) == null) {
    return 'Invalid number';
  }
  return null;
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

extension ContextExtension on BuildContext {
  // MediaQuery
  double get screenWidth => MediaQuery.of(this).size.width;
  double get screenHeight => MediaQuery.of(this).size.height;

  // Themeing
  Color get primary => Theme.of(this).primaryColor;
  Color get foregroundColor => gitHubLightForegroundColor;
  Color get backgroundColor => Theme.of(this).scaffoldBackgroundColor;
  Color get surfaceColor => gitHubLightSecondBackgroundColor;
  Color get borderColor => gitHubLightBorderColor;
  // Color get textColor => gitHubLightForegroundColor;
  Color get textColor => Colors.white;
  Color get secondaryTextColor => gitHubLightDisabledColor;
  Color get buttonColor => gitHubLightButtonColor;
  Color get selectionBackgroundColor => gitHubLightSelectionBackgroundColor;
  Color get selectionForegroundColor => gitHubLightSelectionForegroundColor;
  Color get highlightColor => primary.withOpacity(0.3);
  Color get infoColor => gitHubLightInfoColor;
  Color get errorColor => gitHubLightErrorColor;
  Color get warningColor => gitHubLightWarningColor;
}

void setSystemUIOverlay({Color? navigationBarColor}) {
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      systemStatusBarContrastEnforced: false,
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: navigationBarColor,
      systemNavigationBarContrastEnforced: true,
      systemNavigationBarIconBrightness: Brightness.dark,
      systemNavigationBarDividerColor: Colors.transparent,
    ),
  );
}

void toast(String message) => Fluttertoast.showToast(msg: message);

void snack(BuildContext context, String message) =>
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));

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

Future<String?> showStringInputDialog(
    BuildContext context, String title, String hintText) async {
  final text = await showDialog<String?>(
      context: context,
      builder: (_) {
        final discountController = TextEditingController();
        final borderStyle = OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Colors.transparent));
        final decoration = InputDecoration(
            hintText: hintText,
            border: borderStyle,
            hintStyle: TextStyle(color: context.textColor),
            enabledBorder: borderStyle,
            focusedBorder: borderStyle,
            fillColor: context.secondaryTextColor,
            isDense: true,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            filled: true);
        return AlertDialog(
          title: Text(title),
          titleTextStyle: TextStyle(fontSize: 15, color: context.primary),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          content: TextField(
            // keyboardType: TextInputType.number,
            textInputAction: TextInputAction.go,
            controller: discountController,
            decoration: decoration,
          ),
          actionsPadding:
              const EdgeInsets.symmetric(horizontal: 10, vertical: 0)
                  .copyWith(bottom: 10),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          actions: [
            TextButton(
                onPressed: () => Navigator.of(context).pop(null),
                child: const Text("Cancel")),
            TextButton(
                onPressed: () {
                  try {
                    String percent = discountController.text;
                    Navigator.of(context).pop(percent);
                  } on FormatException catch (e) {
                    toast(e.message);
                  } catch (e) {
                    toast(e.toString());
                  }
                },
                child: const Text("Set")),
          ],
        );
      });
  return text;
}

Future<Uint8List> downloadImage(String imageUrl) async {
  final response = await http.get(Uri.parse(imageUrl));

  if (response.statusCode == 200) {
    return response.bodyBytes;
  } else {
    throw Exception('Failed to load image');
  }
}

String formatAgoDuration(DateTime datetime) {
  final difference = DateTime.now().difference(datetime);
  int maxYear = 50;
  String agoTime = "";

  if (difference.inSeconds >= 0 && difference.inSeconds <= 10) {
    agoTime = "Just Now";
  } else if (difference.inSeconds > 10 && difference.inSeconds <= 60) {
    agoTime = "${difference.inSeconds}s ago";
  } else if (difference.inSeconds > 60 && difference.inSeconds <= 3600) {
    agoTime = "${difference.inMinutes}m ago";
  } else if (difference.inSeconds > 3600 && difference.inSeconds <= 86400) {
    agoTime = "${difference.inHours}h ago";
  } else if (difference.inSeconds > 86400 && difference.inSeconds <= 2592000) {
    agoTime = "${difference.inDays}d ago";
  } else if (difference.inSeconds > 2592000 &&
      difference.inSeconds <= 31104000) {
    agoTime = "${(difference.inDays / 30).floor()}month ago";
  } else if (difference.inSeconds > 31104000 &&
      difference.inSeconds <= maxYear * 31104000) {
    agoTime = "${(difference.inDays / 365).floor()}year ago";
  }
  return agoTime;
}

Future<double?> showNumberInputDialog(
    BuildContext context, String title, String hintText) async {
  final number = await showDialog<double?>(
      context: context,
      builder: (_) {
        final discountController = TextEditingController();
        final borderStyle = OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Colors.transparent));
        final decoration = InputDecoration(
            hintText: hintText,
            border: borderStyle,
            hintStyle: TextStyle(color: context.textColor),
            enabledBorder: borderStyle,
            focusedBorder: borderStyle,
            fillColor: context.secondaryTextColor,
            isDense: true,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            filled: true);
        return AlertDialog(
          title: Text(title),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          content: TextField(
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.go,
            controller: discountController,
            decoration: decoration,
          ),
          actionsPadding:
              const EdgeInsets.symmetric(horizontal: 10, vertical: 0)
                  .copyWith(bottom: 10),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          actions: [
            TextButton(
                onPressed: () => Navigator.of(context).pop(null),
                child: const Text("Cancel")),
            TextButton(
                onPressed: () {
                  try {
                    double percent = double.parse(discountController.text);
                    Navigator.of(context).pop(percent);
                  } on FormatException catch (e) {
                    toast(e.message);
                  } catch (e) {
                    toast(e.toString());
                  }
                },
                child: const Text("Set")),
          ],
        );
      });
  return number;
}
