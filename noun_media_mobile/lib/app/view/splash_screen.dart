// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:inspired_blog/app/view/main_screen.dart';
import 'package:inspired_blog/entertainment/controller/entertainment_controller.dart';
import 'package:inspired_blog/magazine/controller/magazine_controller.dart';
import 'package:inspired_blog/main.dart';
import 'package:inspired_blog/utils/colors.dart';
import 'package:inspired_blog/utils/constants.dart';
import 'package:inspired_blog/utils/functions.dart';
import 'package:inspired_blog/utils/images.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController animateController;

  late Animation animationOne;
  late Animation animationTwo;

  bool loading = false;

  @override
  void initState() {
    super.initState();
    getData();

    animateController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 2000));
    animationOne = CurvedAnimation(
        parent: animateController,
        curve: const Interval(0, 0.5, curve: Curves.ease));
    animationTwo = CurvedAnimation(
        parent: animateController,
        curve: const Interval(0.4, 0.75, curve: Curves.fastOutSlowIn));

    SchedulerBinding.instance.addPostFrameCallback((timeStamp) async {
      animateController
        ..reset()
        ..forward().then((value) async {
          if (loading) {
            await Future.delayed(const Duration(seconds: 2));
            authorize(context);
          } else {
            authorize(context);
          }
        });
    });
  }

  Future<void> getData() async {
    setState(() => loading = true);
    await clearImageCache();
    await MagazineController.instance.getMagazines(page: 1);
    await EntertainmentController.instance.getEntertainments(page: 1);
    setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle.light
            .copyWith(systemNavigationBarColor: scaffoldBackgroundColor),
      ),
      body: Stack(
        children: [
          AnimatedBuilder(
              animation: animateController,
              builder: (_, __) {
                return Positioned(
                  left: 0,
                  right: 0,
                  top: 0,
                  bottom: 0,
                  child: Center(
                    child: Align(
                      alignment: Alignment(
                          0, 0 + (3 - (3 * animationTwo.value)).toDouble()),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Opacity(
                          opacity: animationTwo.value,
                          child: const FittedBox(
                            child: Text(
                              appName,
                              textScaleFactor: 2,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }),
          AnimatedBuilder(
              animation: animateController,
              builder: (_, __) {
                return Positioned(
                  left: 0,
                  right: 0,
                  top: 0,
                  bottom: 0,
                  child: Center(
                    child: Align(
                      alignment: Alignment(0,
                          -0.5 + (0 + (0.2 * animationOne.value)).toDouble()),
                      child: Icon(Icons.spa, size: 100, color: context.primary),
                    ),
                  ),
                );
              }),
          Positioned(
            left: 0,
            right: 0,
            top: 0,
            bottom: 0,
            child: AnimatedBuilder(
                animation: animateController,
                builder: (_, __) {
                  return AnimatedOpacity(
                    duration: const Duration(milliseconds:1000),
                    opacity: loading ? animationTwo.value : 0,
                    child: const Center(
                      child: Align(
                        alignment: Alignment(0, 0.7),
                        child: Text(
                          "Loading...",
                          textScaleFactor: 1,
                        ),
                      ),
                    ),
                  );
                }),
          ),
        ],
      ),
    );
  }

  Future<void> authorize(BuildContext context) async {
    Get.offAll(() => const MainScreen(loadAppData: true));

    // bool isAuthorized = await AuthController.instance.authorize();

    // if (isAuthorized) {
    //   Get.offAll(() => const MainScreen(loadAppData: true));
    //   // Get.offAll(() => const TestScreen());
    // } else {
    //   Get.offAll(() => const SignInOptionScreen());
    // }
  }
}
