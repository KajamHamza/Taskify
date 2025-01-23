import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _darkMode = false;
  bool _notificationsEnabled = true;

  void _toggleDarkMode(bool value) {
    setState(() {
      _darkMode = value;
    });
  }

  void _toggleNotifications(bool value) {
    setState(() {
      _notificationsEnabled = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            SwitchListTile(
              title: const Text('Dark Mode'),
              value: _darkMode,
              onChanged: _toggleDarkMode,
              secondary: const Icon(Icons.dark_mode),
            ),
            SwitchListTile(
              title: const Text('Enable Notifications'),
              value: _notificationsEnabled,
              onChanged: _toggleNotifications,
              secondary: const Icon(Icons.notifications),
            ),
            const Divider(),
            ListTile(
              title: const Text('Change Password'),
              leading: const Icon(Icons.lock),
              onTap: () {
                // Handle change password
              },
            ),
          ],
        ),
      ),
    );
  }
}
