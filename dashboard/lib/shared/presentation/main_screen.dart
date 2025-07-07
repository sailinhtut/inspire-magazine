// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:inspired_blog_panel/advertisement/view/advertisement_list_screen.dart';
import 'package:inspired_blog_panel/auth/controller/auth_controller.dart';
import 'package:inspired_blog_panel/auth/model/user.dart';
import 'package:inspired_blog_panel/auth/presentation/sign_in_screen.dart';
import 'package:inspired_blog_panel/blog/view/blog_list_screen.dart';
import 'package:inspired_blog_panel/blog/view/genre_list_screen.dart';
import 'package:inspired_blog_panel/entertainment/view/entertainment_list_screen.dart';
import 'package:inspired_blog_panel/header_image/view/header_image_list_screen.dart';
import 'package:inspired_blog_panel/magazine/view/magazine_list_screen.dart';
import 'package:inspired_blog_panel/meta_data/view/meta_data_list_screen.dart';
import 'package:inspired_blog_panel/shared/presentation/components/input_field.dart';
import 'package:inspired_blog_panel/shared/presentation/components/loading_widget.dart';
import 'package:inspired_blog_panel/shared/presentation/components/side_bar.dart';
import 'package:inspired_blog_panel/shared/presentation/setting_screen.dart';
import 'package:inspired_blog_panel/utils/functions.dart';
import 'package:inspired_blog_panel/utils/images.dart';
import 'package:provider/provider.dart';

import '../../utils/constants.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key, this.loadUserData = false});

  final bool loadUserData;

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int currentPage = 0;
  bool isCompleted = false;
  bool isSuperUser = false;
  bool showProfileEdit = false;
  bool loadingUserVenue = false;
  bool isSideBarCollapse = false;
  bool showMenu = true;

  List<Widget> pages = const [
    MagazineListScreen(),
    EntertainmentListScreen(),
    HeaderImageListScreen(),
    AdvertisementListScreen(),
    MetaDataListScreen(),
    SettingScreen(),
  ];
  List<BottomNavigationBarItem> mobileMenu = [
    const BottomNavigationBarItem(icon: Icon(Icons.bookmarks), label: 'Blogs'),
    const BottomNavigationBarItem(icon: Icon(Icons.category), label: 'Genres'),
    const BottomNavigationBarItem(
        icon: Icon(Icons.image), label: 'Slide Images'),
    const BottomNavigationBarItem(
        icon: Icon(Icons.image), label: 'Advertisements'),
    const BottomNavigationBarItem(
        icon: Icon(Icons.edit_document), label: 'Documents'),
    const BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Setting'),
  ];

  @override
  initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      loadAppData();
    });
  }

  Future<void> loadAppData() async {}

  void onIndexed(int index) {
    setState(() {
      currentPage = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar:
          context.mediaType == MediaTypes.mobile ? mobileBottomBar() : null,
      body: Row(
        children: [
          // desktop side bar
          if (MediaQuery.of(context).size.width >= 640)
            SideBar(
              currentIndex: currentPage,
              onTap: onIndexed,
              leadingBuilder: profileWidget,
              trailingBuilder: logOutButton,
            ),

          // content
          Expanded(
            child: Stack(
              children: [
                pages[currentPage],
                AnimatedPositioned(
                  left: showProfileEdit ? 10 : -320,
                  top: 20,
                  duration: const Duration(milliseconds: 1000),
                  curve: Curves.fastLinearToSlowEaseIn,
                  child: _buildProfileBoard(),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget mobileBottomBar() {
    return BottomNavigationBar(
      currentIndex: currentPage,
      unselectedItemColor: Colors.black,
      selectedItemColor: context.primary,
      onTap: onIndexed,
      items: mobileMenu,
      elevation: 0,
    );
  }

  Widget _buildProfileBoard() {
    return GetBuilder<AuthController>(builder: (authState) {
      return Container(
        height: 300,
        width: 300,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
          border: Border.all(color: Colors.black12),
          boxShadow: const [
            BoxShadow(
              blurRadius: 4,
              color: Colors.black12,
              offset: Offset(0, 3),
            )
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  style: IconButton.styleFrom(
                    minimumSize: const Size(30, 30),
                    padding: const EdgeInsets.all(3),
                    iconSize: 20,
                  ),
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () {
                    setState(() => showProfileEdit = false);
                  },
                )),
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
            const Expanded(child: SizedBox(height: 10)),
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(250, 40),
                side: BorderSide(color: context.primary),
                foregroundColor: context.primary,
              ),
              onPressed: () async {
                showUserEdit(
                  context,
                  AuthController.instance.currentUser,
                );
              },
              child: const Text("Edit Profile"),
            ),
          ],
        ),
      );
    });
  }

  Widget profileWidget(bool collapsed) {
    return collapsed
        ? Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Image.asset(AppAsset.appLogo, height: 25, width: 25),
          )
        : ListTile(
            leading: const CircleAvatar(
              radius: 20,
              backgroundImage: AssetImage(AppAsset.appLogo),
            ),
            title: const Text(appName),
            subtitle: GetBuilder<AuthController>(
              builder: (authState) => GestureDetector(
                onTap: () {
                  setState(() {
                    showProfileEdit = !showProfileEdit;
                  });
                },
                child: Text(
                  authState.currentUser.name ?? "",
                  style: TextStyle(color: context.primary),
                  textScaleFactor: 0.9,
                ),
              ),
            ),
          );
  }

  Widget logOutButton(bool collapsed) {
    return ListTile(
      leading: const Icon(
        Icons.logout,
        color: Colors.black,
      ),
      hoverColor: Colors.black,
      textColor: Colors.black,
      title: collapsed
          ? null
          : const Text(
              "Log Out",
              style: TextStyle(fontSize: 13),
            ),
      onTap: () async {
        await showConfirmDialog(context,
            title: "Log Out",
            content: "Are you sure to log out ?",
            buttonText: "Log Out", onConfirm: () async {
          Navigator.pop(context);
          final passed = await AuthController.instance.logOut();
          if (passed) {
            Get.offAll(() => const LogInScreen());
          }
        });
      },
    );
  }

  Future<void> showUserEdit(
    BuildContext context,
    User user,
  ) async {
    final formKey = GlobalKey<FormState>();
    final nameController = TextEditingController();
    final emailController = TextEditingController();

    String oldName = user.name ?? "";
    nameController.text = user.name ?? "";
    emailController.text = user.email ?? "";
    bool loading = false;

    showModalBottomSheet(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setSt) {
            return Container(
                height: context.screenHeight * 0.7,
                width: context.screenWidth,
                decoration: BoxDecoration(
                    color: context.backgroundColor,
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(15))),
                alignment: Alignment.center,
                padding: const EdgeInsets.all(15).copyWith(top: 20),
                child: SizedBox(
                  width: 400,
                  height: double.maxFinite,
                  child: SingleChildScrollView(
                    child: Form(
                      key: formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text("Edit ${user.name}",
                              style: Theme.of(context).textTheme.headlineSmall),
                          const SizedBox(height: 15),
                          TextInputWidget(
                            hint: "Name",
                            autoFills: const [AutofillHints.name],
                            controller: nameController,
                            validate: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter your name';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 10.0),

                          // email
                          TextInputWidget(
                            hint: "Email",
                            autoFills: const [AutofillHints.email],
                            controller: emailController,
                            enabled: false,
                            validate: (value) {
                              if (value!.isEmpty) {
                                return 'Email is required';
                              } else if (!RegExp(r'\S+@\S+\.\S+')
                                  .hasMatch(value)) {
                                return 'Please enter a valid email address';
                              }
                              return null;
                            },
                          ),

                          const SizedBox(height: 32),

                          // sign up
                          Align(
                            alignment: Alignment.centerRight,
                            child: loading
                                ? const LoadingWidget()
                                : ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      minimumSize: const Size(100, 40),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                    ),
                                    onPressed: () async {
                                      user.name = nameController.text;

                                      setSt(() => loading = true);

                                      // edit user
                                      await AuthController.instance
                                          .updateUser(user)
                                          .then((value) async {
                                        if (value) {
                                          setSt(() => loading = false);
                                          Navigator.pop(context);
                                          toast("Successfully Edited",
                                              icon: Icons.person);
                                        }
                                      });
                                    },
                                    child: const Text('Save'),
                                  ),
                          ),
                          const SizedBox(height: 16.0),
                        ],
                      ),
                    ),
                  ),
                ));
          });
        });
  }
}
