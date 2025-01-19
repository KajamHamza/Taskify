import 'package:Taskify/core/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'widgets/profile_header.dart';
import 'widgets/profile_menu_item.dart';
import 'controllers/profile_controller.dart';
import 'package:provider/provider.dart';

class ProviderProfileScreen extends StatelessWidget {
  const ProviderProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ProfileController(),
      child: const _ProviderProfileScreen(),
    );
  }
}

class _ProviderProfileScreen extends StatelessWidget {
  const _ProviderProfileScreen();

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<ProfileController>();

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 80, 16, 20),
          children: [
            const ProfileHeader(),
            const SizedBox(height: 32),
            ProfileMenuItem(
              icon: Icons.credit_card,
              title: 'Payments',
              onTap: () => controller.navigateToPayments(context),
            ),
            ProfileMenuItem(
              icon: Icons.local_offer,
              title: 'Your Promos',
              onTap: () => controller.navigateToPromos(context),
            ),
            ProfileMenuItem(
              icon: Icons.settings,
              title: 'Settings',
              onTap: () => controller.navigateToSettings(context),
            ),
            ProfileMenuItem(
              icon: Icons.headset_mic,
              title: 'Support',
              onTap: () => controller.navigateToSupport(context),
            ),
            const SizedBox(height: 32),
            TextButton(
              onPressed: () => controller.showDeleteAccountConfirmation(context),
              style: TextButton.styleFrom(
                backgroundColor: Colors.red.shade50,
                foregroundColor: Colors.red,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text('Delete Account'),
            ),
            const SizedBox(height: 32),
            TextButton(
              onPressed: () => {
                AuthService().signOut(),
                Navigator.of(context).pushReplacementNamed('/auth')
              },
              style: TextButton.styleFrom(
                backgroundColor: Colors.blue.shade50,
                foregroundColor: Colors.blue,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text('Sign Out'),
            ),
          ],
        ),
      ),
    );
  }
}