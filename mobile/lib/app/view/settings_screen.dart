// ignore_for_file: use_build_context_synchronously


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:inspired_blog/utils/functions.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen>
{

  @override
  Widget build(BuildContext context) {
    final screen = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text("Setting",
            style:
                TextStyle(color: context.primary, fontWeight: FontWeight.bold)),
      ),
      body: Container(
        width: screen.width,
        height: screen.height,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            
             
            ],
          ),
        ),
      ),
    );
  }

  // Future<void> processLogOut() async {
  //   showConfirmDialog(context,
  //       title:,
  //       content: S.current.are_you_sure_to_logout,
  //       buttonText: S.current.log_out, onConfirm: () async {
  //     Navigator.pop(context);
  //     final result = await AuthController.instance.logOut();
  //     if (result) {
  //       context.read<FriendRelactionController>().clearFriendRelations();
  //       context.read<DatingController>().clearFriends();
  //       stopTrackingService();

  //       Get.offAll(() => const SignInOptionScreen());
  //     }
  //   });
  // }

  Widget buildSettingTile({
    Widget? title,
    Widget? trailing,
    VoidCallback? onTap,
    Widget? subtitle,
  }) {
    return SizedBox(
      height: 40,
      child: ListTile(
        dense: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 5),
        title: title,
        subtitle: subtitle,
        trailing: trailing,
        onTap: onTap,
      ),
    );
  }
}
