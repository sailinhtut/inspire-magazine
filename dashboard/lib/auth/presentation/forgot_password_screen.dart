
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inspired_blog_panel/main.dart';
import 'package:inspired_blog_panel/shared/presentation/components/input_field.dart';
import 'package:inspired_blog_panel/utils/functions.dart';

class ForgotPasswordPage extends StatelessWidget {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();

  ForgotPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: SizedBox(
            width: 500,
            height: 300,
            child: Card(
              elevation: 5,
              shadowColor: context.primary,
              margin: const EdgeInsets.symmetric(horizontal: 15),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Reset Password',
                        style: TextStyle(fontSize: 24.0),
                      ),
                      const SizedBox(height: 16.0),
                      const Text(
                        'Enter the email associated with your account to reset your password.',
                      ),
                      const SizedBox(height: 16.0),
                      TextInputWidget(
                        controller: emailController,
                        hint: "Email",
                        validate: (value) {
                          if (value != null && value.isEmpty) {
                            return "Email is required";
                          } else if (!RegExp("[a-z0-9]+@[a-z]+\\.[a-z]{2,3}").hasMatch(value!)) {
                            return "Invalid Email";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16.0),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(double.maxFinite, 50),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            // authController.sendPasswordResetEmail(emailController.text);
                          }
                        },
                        child: const Text('Reset Password'),
                      ),
                      const SizedBox(height: 16.0),
                      TextButton(
                        onPressed: () {
                          Get.back();
                        },
                        child: const Text('Back to Login'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
