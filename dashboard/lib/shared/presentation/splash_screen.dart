import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inspired_blog_panel/auth/presentation/sign_in_screen.dart';
import 'package:inspired_blog_panel/shared/presentation/main_screen.dart';
import 'package:inspired_blog_panel/utils/images.dart';

import '../../auth/controller/auth_controller.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool showLogo = false;
  @override
  void initState() {
    super.initState();
    runAnimation().then((_) => authorize());
  }

  Future<void> runAnimation() async {
    await Future.delayed(const Duration(milliseconds: 500));
    setState(() => showLogo = true);
    await Future.delayed(const Duration(seconds: 1));
  }

  Future<void> authorize() async {
    final authorizedUser = await AuthController.instance.loadUserData();
    if (authorizedUser != null) {
      AuthController.instance.setUser(authorizedUser);
      Get.offAll(() => const DashboardScreen());
    } else {
      Get.offAll(() => const LogInScreen());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: AnimatedScale(
          duration: const Duration(milliseconds: 500),
          scale: showLogo ? 1 : 0,
          child: Image.asset(
            AppAsset.appLogo,
            width: 100,
            height: 100,
          ),
        ),
      ),
    );
  }
}
