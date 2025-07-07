
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inspired_blog_panel/auth/controller/auth_controller.dart';
import 'package:inspired_blog_panel/main.dart';
import 'package:inspired_blog_panel/utils/functions.dart';
// import 'package:syncfusion_flutter_xlsio/xlsio.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(),
        if (context.isMobile) _buildProfileBoard(),
        Container(
          width: 600,
          alignment: Alignment.topLeft,
          child: Column(
            children: [
              if (context.isMobile)
                ListTile(
                    title: const Text("Edit Profile"),
                    trailing: TextButton(
                      child: const Text("Edit"),
                      onPressed: () async {
                        // final currentUser = authController.currentUser;
                        // await authController.showUserEdit(context, currentUser,
                        //     forCurrentUser: true);
                      },
                    )),
              ListTile(
                  title: const Text("Log Out"),
                  trailing: TextButton(
                    child: const Text("Log Out"),
                    onPressed: () async {
                      await showConfirmDialog(context,
                          title: "Log Out",
                          content: "Are you sure to log out ?",
                          buttonText: "Log Out", onConfirm: () async {
                        // authController.logOut();
                      });
                    },
                  )),
            ],
          ),
        ),
        // const Expanded(child: SizedBox()),
        // Padding(
        //   padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 40),
        //   child: Center(
        //     child: InkWell(
        //       hoverColor: Colors.transparent,
        //       focusColor: Colors.transparent,
        //       highlightColor: Colors.transparent,
        //       splashColor: Colors.transparent,
        //       onTap: () {
        //         window.open("https://www.facebook.com/profile.php?id=100092730696504&mibextid=ZbWKwL", "Kanbawza Studio");
        //       },
        //       child: const Text("Powered by KANBAWZA - APP STUDIO LASHIO", style: TextStyle(color: Colors.blue)),
        //     ),
        //   ),
        // )
      ],
    ));
  }

  Widget _buildProfileBoard() {
    return GetBuilder<AuthController>(builder: (authState) {
      return Container(
        width: context.screenWidth,
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () async {
                final picked = await FilePicker.platform
                    .pickFiles(allowMultiple: false, type: FileType.image);
                if (picked != null) {
                  final fileExtestion = picked.files.first.extension;
                  final fileDataBytes = picked.files.first.bytes;

                  // final downloadUrl = await authState.uploadBytesToPath(
                  //     "profile",
                  //     authState.currentUser.name ??
                  //         authState.currentUser.userId!,
                  //     fileExtestion!,
                  //     fileDataBytes!);

                  // authState.currentUser.profile = downloadUrl;
                  // await authState.editUserData(
                  //     authState.currentUser.userId!, authState.currentUser);
                  toast("Successfully Uploaded");
                }
              },
              child: CircleAvatar(
                radius: 50,
                backgroundColor: context.primary,
                backgroundImage: authState.currentUser.profile == null
                    ? null
                    : NetworkImage(authState.currentUser.profile!),
                child: authState.currentUser.profile == null
                    ? Text(authState.currentUser.name?.substring(0, 1) ?? "",
                        textScaleFactor: 2.0)
                    : null,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              authState.currentUser.name ?? "",
              textScaleFactor: 2.0,
              overflow: TextOverflow.ellipsis,
              style: context.textTheme.bodyLarge,
            ),
            const SizedBox(height: 10),
            Text(
              authState.currentUser.email ?? "",
              textScaleFactor: 1.0,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      );
    });
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("Setting", style: context.textTheme.headlineSmall!),
        ],
      ),
    );
  }
}
