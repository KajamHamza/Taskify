import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'register_screen.dart';
import 'provider_register_screen.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool _showLogin = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 48),
                Text(
                  _showLogin ? 'Welcome Back!' : 'Create Account',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  _showLogin
                      ? 'Sign in to continue'
                      : 'Fill in your details to get started',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Colors.grey[600],
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 48),
                _showLogin ? const LoginScreen() : const RegisterScreen(),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _showLogin
                          ? "Don't have an account? "
                          : 'Already have an account? ',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    TextButton(
                      onPressed: () {
                        setState(() => _showLogin = !_showLogin);
                      },
                      child: Text(
                        _showLogin ? 'Register' : 'Login',
                        style: const TextStyle(color: Color(0xFF0080FF)),
                      ),
                    ),
                  ],
                ),
                if (_showLogin) ...[
                  const SizedBox(height: 24),
                  const Divider(height: 1),
                  const SizedBox(height: 24),
                  OutlinedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                          const ProviderRegisterScreen(),
                        ),
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF0080FF),
                      side: const BorderSide(color: Color(0xFF0080FF)),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: const Text('Promote Your Service', style: TextStyle(
                      color: Color(0xFF0080FF),
                      fontSize: 16,
                    )),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
