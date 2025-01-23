import 'package:flutter/material.dart';

import '../../../../../models/user_model.dart';
import '../../../../../services/auth_service.dart';
import '../../../../../services/firestore_service.dart';
import '../../../client/Coming_soon_page.dart';
import '../Settings.dart';
import '../Support.dart';
import '../edit_profile_page.dart';


class ProfileController extends ChangeNotifier {
  final _authService = AuthService();
  final _firestoreService = FirestoreService();
  UserModel? _currentUser;

  UserModel? get currentUser => _currentUser;

  ProfileController() {
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final userId = _authService.currentUser?.uid;
    if (userId != null) {
      _currentUser = await _firestoreService.getUser(userId);
      notifyListeners();
    }
  }

void navigateToEditProfile(BuildContext context) {
  if (_currentUser != null) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EditProfilePage(user: _currentUser!)),
    );
  } else {
    // Handle the case when _currentUser is null
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('User data is not available')),
    );
  }
}

  void navigateToPayments(BuildContext context) {
    if (_currentUser != null) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ComingSoonPage()),
      );
    } else {
      // Handle the case when _currentUser is null
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User data is not available')),
      );
    }
  }

  void navigateToPromos(BuildContext context) {
    if (_currentUser != null) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ComingSoonPage()),
      );
    } else {
      // Handle the case when _currentUser is null
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User data is not available')),
      );
    }
  }

  void navigateToSettings(BuildContext context) {
    if (_currentUser != null) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => SettingsPage()),
      );
    } else {
      // Handle the case when _currentUser is null
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User data is not available')),
      );
    }
  }

  void navigateToSupport(BuildContext context) {
    if (_currentUser != null) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => SupportPage()),
      );
    } else {
      // Handle the case when _currentUser is null
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User data is not available')),
      );
    }
  }

  Future<void> showDeleteAccountConfirmation(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Account'),
        content: const Text(
          'Are you sure you want to delete your account? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await deleteAccount();
      if (context.mounted) {
        Navigator.pushReplacementNamed(context, '/auth');
      }
    }
  }

  Future<void> deleteAccount() async {
    try {
      final userId = _authService.currentUser?.uid;
      if (userId != null) {
        await _firestoreService.deleteUser(userId);
        await _authService.deleteAccount();
      }
    } catch (e) {
      rethrow;
    }
  }
}