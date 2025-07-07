
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inspired_blog/app/view/splash_screen.dart';
import 'package:inspired_blog/utils/constants.dart';
import 'package:inspired_blog/utils/themes.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: appName,
      debugShowCheckedModeBanner: false,
      theme: FindemThemes.light,
      home: const SplashScreen(),
    );
  }
}
