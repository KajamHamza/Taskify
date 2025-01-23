import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../models/user_model.dart';
import '../../../services/auth_service.dart';
import '../../../utils/validators.dart';
import '../../widgets/custom_text_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _authService = AuthService();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() => _isLoading = true);
      try {
        await _authService.signInWithEmail(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        );

        if (mounted) {
          final userType = await _authService.getCurrentUserType();
          if (userType == UserType.serviceProvider) {
            Navigator.pushReplacementNamed(context, '/provider/home');
          } else {
            Navigator.pushReplacementNamed(context, '/client/home');
          }
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(e.toString())),
          );
        }
      } finally {
        if (mounted) {
          setState(() => _isLoading = false);
        }
      }
    }
  }

  Future<void> _handleGoogleSignIn() async {
    setState(() => _isLoading = true);
    try {
      await _authService.signInWithGoogle();
      if (mounted) {
        final userType = await _authService.getCurrentUserType();
        if (userType == UserType.serviceProvider) {
          Navigator.pushReplacementNamed(context, '/provider/home');
        } else {
          Navigator.pushReplacementNamed(context, '/client/home');
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _handlePasswordReset() async {
    final email = _emailController.text.trim();
    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your email')),
      );
      return;
    }

    try {
      await _authService.resetPassword(email);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Password reset email sent')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          CustomTextField(
            label: 'Email',
            hint: 'Enter your email',
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            validator: Validators.validateEmail,
            prefix: const Icon(Icons.email_outlined, color: Colors.grey),
          ),
          const SizedBox(height: 20),
          CustomTextField(
            label: 'Password',
            hint: 'Enter your password',
            controller: _passwordController,
            obscureText: true,
            validator: Validators.validatePassword,
            prefix: const Icon(Icons.lock_outlined, color: Colors.grey),
          ),
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: _handlePasswordReset,
              child: const Text(
                'Forgot Password?',
                style: TextStyle(color: Color(0xFF0080FF)),
              ),
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _isLoading ? null : _handleLogin,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0080FF),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: _isLoading
                  ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
                  : const Text(
                'Login',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: 32),
          Row(
            children: [
              const Expanded(child: Divider(color: Colors.grey)),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'OR',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey,
                  ),
                ),
              ),
              const Expanded(child: Divider(color: Colors.grey)),
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: _isLoading ? null : _handleGoogleSignIn,
              icon: SvgPicture.asset(
                'lib/assets/images/google.svg',
                height: 24,
                width: 24,
              ),
              label: const Text(
                'Continue with Google',
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                side: BorderSide(color: Colors.grey.shade300),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}