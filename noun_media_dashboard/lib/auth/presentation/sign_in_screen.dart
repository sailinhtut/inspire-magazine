import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inspired_blog_panel/auth/controller/auth_controller.dart';
import 'package:inspired_blog_panel/auth/presentation/forgot_password_screen.dart';
import 'package:inspired_blog_panel/auth/presentation/sign_up_screen.dart';
import 'package:inspired_blog_panel/main.dart';
import 'package:inspired_blog_panel/shared/presentation/components/input_field.dart';
import 'package:inspired_blog_panel/shared/presentation/main_screen.dart';
import 'package:inspired_blog_panel/utils/functions.dart';
import 'package:inspired_blog_panel/utils/images.dart';

class LogInScreen extends StatefulWidget {
  const LogInScreen({super.key});

  @override
  State<LogInScreen> createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Card(
          elevation: 5,
          shadowColor: context.primary,
          margin: const EdgeInsets.symmetric(horizontal: 15),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: Container(
            padding: const EdgeInsets.all(16.0),
            width: 400,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(10),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    // logo
                    Image.asset(AppAsset.appLogo, width: 100, height: 80),
                    const SizedBox(height: 20),

                    Text(context.appname,
                        style: context.textTheme.titleLarge!
                            .copyWith(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 20),

                    // email
                    TextInputWidget(
                        controller: emailController,
                        hint: "Email",
                        validate: (value) {
                          if (value != null && value.isEmpty) {
                            return "Email is required";
                          } else if (!RegExp("[a-z0-9]+@[a-z]+\\.[a-z]{2,3}")
                              .hasMatch(value!)) {
                            return "Invalid Email";
                          }
                          return null;
                        }),
                    const SizedBox(height: 10.0),

                    // password
                    TextInputWidget(
                      controller: passwordController,
                      hint: "Password",
                      inputAction: TextInputAction.go,
                      useObsecure: true,
                      maxLines: 1,
                      validate: (value) {
                        if (value!.isEmpty) {
                          return 'Password is required';
                        } else if (value.length < 6) {
                          return 'Password must be at least 6 characters long';
                        }
                        return null;
                      },
                      onSubmitted: (value) => submit(),
                    ),
                    const SizedBox(height: 10.0),

                    // forgot password
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        style: TextButton.styleFrom(
                          textStyle: const TextStyle(fontSize: 11),
                        ),
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => ForgotPasswordPage()));
                        },
                        child: const Text('Forgot Password ?'),
                      ),
                    ),

                    const SizedBox(height: 32),

                    // sign up
                    loading
                        ? const CircularProgressIndicator()
                        : ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size(double.maxFinite, 50),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                            ),
                            onPressed: submit,
                            child: const Text('Sign In'),
                          ),
                    const SizedBox(height: 16.0),

                    // already acount
                    TextButton(
                      style: TextButton.styleFrom(
                        foregroundColor: context.foregroundColor,
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SignUpScreen()),
                        );
                      },
                      child: const Text(
                        "Don't have an account? Sign Up",
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> submit() async {
    setState(() => loading = true);
    if (_formKey.currentState!.validate()) {
      final user = await AuthController.instance
          .logIn(emailController.text, passwordController.text);
      if (user != null) {
        Get.offAll(() => const DashboardScreen());
      }
    }
    setState(() => loading = false);
  }
}
