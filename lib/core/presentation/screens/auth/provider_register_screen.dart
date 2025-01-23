import 'package:flutter/material.dart';
import '../../../models/user_model.dart';
import '../../../services/auth_service.dart';
import '../../../services/provider_service.dart';
import '../../../utils/validators.dart';
import '../../widgets/custom_text_field.dart';

class ProviderRegisterScreen extends StatefulWidget {
  const ProviderRegisterScreen({Key? key}) : super(key: key);

  @override
  State<ProviderRegisterScreen> createState() => _ProviderRegisterScreenState();
}

class _ProviderRegisterScreenState extends State<ProviderRegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isLoading = false;
  bool _acceptedTerms = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
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
    if (!_acceptedTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please accept the terms and conditions'),
        ),
      );
      return;
    }

    if (_formKey.currentState?.validate() ?? false) {
      setState(() => _isLoading = true);
      try {
        final authService = AuthService();
        final providerService = ProviderService();

        final userCredential = await authService.signUpWithEmail(
          email: _emailController.text,
          password: _passwordController.text,
          name: _nameController.text,
          userType: UserType.serviceProvider,
        );

        final providerId = userCredential.user!.uid;
        await providerService.createProvider(
          providerId: providerId,
          name: _nameController.text,
          email: _emailController.text,
          phone: _phoneController.text,
        );

        if (mounted) {
          Navigator.pushReplacementNamed(context, '/setup');
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
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Start Your Business Journey',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0080FF),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                'Create your service provider account',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              CustomTextField(
                label: 'Business Name',
                hint: 'Enter your business name',
                controller: _nameController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your business name';
                  }
                  return null;
                },
                prefix: const Icon(Icons.business_outlined, color: Colors.grey),
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
                label: 'Phone Number',
                hint: 'Enter your phone number',
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                validator: Validators.validatePhone,
                prefix: const Icon(Icons.phone_outlined, color: Colors.grey),
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
              const SizedBox(height: 24),
              Row(
                children: [
                  Checkbox(
                    value: _acceptedTerms,
                    onChanged: (value) {
                      setState(() => _acceptedTerms = value ?? false);
                    },
                    activeColor: Color(0xFF0080FF),
                  ),
                  Expanded(
                    child: Text(
                      'I accept the terms and conditions',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _isLoading ? null : _handleRegister,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF0080FF),
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
                  'Continue',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}