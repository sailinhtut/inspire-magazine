import 'dart:convert';

import 'package:get/get.dart';
import 'package:inspired_blog_panel/api/noun_api.dart';
import 'package:inspired_blog_panel/auth/model/user.dart';
import 'package:inspired_blog_panel/auth/presentation/sign_in_screen.dart';
import 'package:inspired_blog_panel/main.dart';

class AuthController extends GetxController {
  static AuthController get instance => Get.find<AuthController>();

  User? _currentUser;

  User get currentUser {
    if (_currentUser == null) {
      // Get.offAll(() => const LogInScreen());
      return User.sample();
    }
    return _currentUser!;
  }

  void setUser(User user) {
    _currentUser = user;
    saveUserData();
  }

  Future<User?> register(User userModel, String password) async {
    final credential = await NounAPI.register(userModel, password);
    _currentUser = credential;
    await saveUserData();
    update();
    return credential;
  }

  Future<User?> logIn(String email, String password) async {
    final credential = await NounAPI.logIn(email, password);
    _currentUser = credential;
    await saveUserData();
    update();
    return credential;
  }

  Future<bool> logOut() async {
    if (_currentUser == null) return false;
    final passed = await NounAPI.logOut(_currentUser!.userId!);
    if (passed) {
      _currentUser = null;
      await clearUserData();
      update();
      return true;
    }

    return false;
  }

  Future<bool> updateUser(User user) async {
    if (_currentUser == null) return false;
    final passed = await NounAPI.updateUser(user);
    if (passed) {
      _currentUser = user;
      await saveUserData();
      update();
      return true;
    }

    return false;
  }

  // user data saving
  Future<void> saveUserData() async {
    if (_currentUser == null) return;
    await pref.setString("currentUser", jsonEncode(_currentUser!.toJson()));
  }

  Future<User?> loadUserData() async {
    final data = pref.getString("currentUser");
    if (data != null) {
      return User.fromJson(jsonDecode(data));
    }
    return null;
  }

  Future<void> clearUserData() async {
    await pref.remove("currentUser");
  }
}
