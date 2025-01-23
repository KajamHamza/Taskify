import 'package:flutter/material.dart';
import '../../../models/user_model.dart';
import '../../../services/auth_service.dart';
import '../../../utils/validators.dart';
import '../../widgets/custom_text_field.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _authService = AuthService();
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  String? _validateConfirmPassword(String? value) {
    if (value != _passwordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  Future<void> _handleRegister() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() => _isLoading = true);
      try {
        await _authService.signUpWithEmail(
          email: _emailController.text.trim(),
          password: _passwordController.text,
          name: _nameController.text.trim(),
          userType: UserType.client,
        );

        if (mounted) {
          Navigator.pushReplacementNamed(context, '/client/home');
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

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          CustomTextField(
            label: 'Full Name',
            hint: 'Enter your full name',
            controller: _nameController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your name';
              }
              return null;
            },
            prefix: const Icon(Icons.person_outline, color: Colors.grey),
          ),
          const SizedBox(height: 20),
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
          const SizedBox(height: 20),
          CustomTextField(
            label: 'Confirm Password',
            hint: 'Confirm your password',
            controller: _confirmPasswordController,
            obscureText: true,
            validator: _validateConfirmPassword,
            prefix: const Icon(Icons.lock_outlined, color: Colors.grey),
          ),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _isLoading ? null : _handleRegister,
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
                'Register',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}