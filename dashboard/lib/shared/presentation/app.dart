import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inspired_blog_panel/shared/presentation/splash_screen.dart';
import 'package:inspired_blog_panel/utils/constants.dart';
import 'package:inspired_blog_panel/utils/theme/themes.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: appName,
      theme: PoultryThemes.light,
      home: const SplashScreen(),
    );
  }
}
