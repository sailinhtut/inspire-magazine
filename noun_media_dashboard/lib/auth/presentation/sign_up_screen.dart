import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_utils/src/extensions/context_extensions.dart';
import 'package:inspired_blog_panel/auth/controller/auth_controller.dart';
import 'package:inspired_blog_panel/auth/model/user.dart';
import 'package:inspired_blog_panel/auth/presentation/sign_in_screen.dart';
import 'package:inspired_blog_panel/main.dart';
import 'package:inspired_blog_panel/shared/presentation/components/input_field.dart';
import 'package:inspired_blog_panel/shared/presentation/main_screen.dart';
import 'package:inspired_blog_panel/utils/functions.dart';
import 'package:inspired_blog_panel/utils/images.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Card(
          elevation: 5,
          margin: const EdgeInsets.symmetric(horizontal: 10),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: Container(
            padding: const EdgeInsets.all(16.0),
            width: 400,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(15),
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
                        controller: nameController,
                        hint: "Name",
                        validate: (value) {
                          if (value != null && value.isEmpty) {
                            return "Name is required";
                          }
                          return null;
                        }),
                    const SizedBox(height: 10.0),

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
                      useObsecure: true,
                      validate: (value) {
                        if (value!.isEmpty) {
                          return 'Password is required';
                        } else if (value.length < 6) {
                          return 'Password must be at least 6 characters long';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 32),

                    // sign up
                    loading
                        ?
                        // LoadingAnimationWidget.staggeredDotsWave(color: context.primary, size: 40)
                        const CircularProgressIndicator()
                        : ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size(double.maxFinite, 50),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                            ),
                            onPressed: submit,
                            child: const Text('Create Account'),
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
                              builder: (context) => const LogInScreen()),
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
      final newUser = User(
        email: emailController.text,
        name: nameController.text,
      );
      final user = await AuthController.instance
          .register(newUser, passwordController.text);
      if (user != null) {
        Get.offAll(() => const DashboardScreen());
      } else {
        toast('Unexpected Error Occured');
      }
    }
    setState(() => loading = false);
  }
}
