import 'package:flutter/material.dart';
import '../widgets/auth_button.dart';
import '../widgets/auth_text_field.dart';
import '../widgets/divider_with_text.dart';
import '../widgets/google_button.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 40),
                const Text(
                  'Create Your Account',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.black
                  ),
                ),
                const SizedBox(height: 40),
                const AuthTextField(
                  label: 'Name',
                  hintText: 'Enter name',
                  icon: Icons.person_outline,
                ),
                const SizedBox(height: 20),
                const AuthTextField(
                  label: 'Email',
                  hintText: 'Enter your email',
                  icon: Icons.mail_outline,
                ),
                const SizedBox(height: 20),
                const AuthTextField(
                  label: 'Password',
                  hintText: 'Enter password',
                  icon: Icons.lock_outline,
                  isPassword: true,
                ),
                const SizedBox(height: 40),
                AuthButton(
                  text: 'Sign UP',
                  onPressed: () {
                    // Handle sign up
                  },
                ),
                const SizedBox(height: 20),
                const DividerWithText(text: 'or'),
                const SizedBox(height: 20),
                const GoogleButton(),
                const SizedBox(height: 20),
                Center(
                  child: RichText(
                    text: TextSpan(
                      text: 'Wanna Promote your service? ',
                      style: TextStyle(color: Colors.grey[600]),
                      children: [
                        TextSpan(
                          text: 'Sign UP',
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}