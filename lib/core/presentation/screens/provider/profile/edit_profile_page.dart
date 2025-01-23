import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../models/user_model.dart';
import '../../../../services/auth_service.dart';
import '../../../../services/firestore_service.dart';
import '../../../../services/storage_service.dart';

class EditProfilePage extends StatefulWidget {
  final UserModel user;

  const EditProfilePage({Key? key, required this.user}) : super(key: key);

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  late String _name;
  late String _email;
  late String _photoUrl;
  final _authService = AuthService();
  final _firestoreService = FirestoreService();

  @override
  void initState() {
    super.initState();
    _name = widget.user.name;
    _email = widget.user.email;
    _photoUrl = widget.user.photoUrl ?? '';
  }

  void _saveProfile() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      try {
        // Update user details in Firestore
        await _firestoreService.updateUserProfile(
          userId: widget.user.id,
          name: _name,
          email: _email,
          photoUrl: _photoUrl,
        );

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile updated successfully!')),
        );

        // Navigate back
        Navigator.pop(context);
      } catch (e) {
        // Show error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update profile: $e')),
        );
      }
    }
  }

  void _changePhoto() async {
    try {
      final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        final storageService = StorageService();
        String uploadedPhotoUrl = await storageService.uploadImage(File(pickedFile.path), 'photos');

        setState(() {
          _photoUrl = uploadedPhotoUrl;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Photo updated successfully!')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No photo selected.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to change photo: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              CircleAvatar(
                radius: 50,
                backgroundImage: _photoUrl.isNotEmpty
                    ? NetworkImage(_photoUrl)
                    : null,
                child: _photoUrl.isEmpty
                    ? const Icon(Icons.person, size: 50)
                    : null,
              ),
              TextButton(
                onPressed: _changePhoto,
                child: const Text('Change Photo'),
              ),
              const SizedBox(height: 20),
              TextFormField(
                initialValue: _name,
                decoration: const InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
                onSaved: (value) {
                  _name = value!;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                initialValue: _email,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  if (!RegExp(r'^\S+@\S+\.\S+$').hasMatch(value)) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
                onSaved: (value) {
                  _email = value!;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveProfile,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'Save Changes',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
