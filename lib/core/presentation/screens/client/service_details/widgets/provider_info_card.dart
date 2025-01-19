import 'package:flutter/material.dart';

import '../../../../../models/user_model.dart';
import '../../../../../services/firestore_service.dart';

class ProviderInfoCard extends StatelessWidget {
  final String providerId;
  final VoidCallback onChatPressed; // Store the callback as a property

  const ProviderInfoCard({
    Key? key,
    required this.providerId,
    required this.onChatPressed, // Assign the callback to the property
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<UserModel>(
      future: FirestoreService().getUser(providerId),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final provider = snapshot.data!;

        return Card(
          child: ListTile(
            leading: CircleAvatar(
              backgroundImage: provider.photoUrl != null
                  ? NetworkImage(provider.photoUrl!)
                  : null,
              child: provider.photoUrl == null
                  ? const Icon(Icons.person)
                  : null,
            ),
            title: Text(provider.name),
            subtitle: provider.isVerified
                ? const Row(
              children: [
                Icon(Icons.verified, size: 16, color: Colors.blue),
                SizedBox(width: 4),
                Text('Verified Provider'),
              ],
            )
                : null,
            trailing: IconButton(
              icon: const Icon(Icons.chat_bubble_outline),
              onPressed: onChatPressed, // Use the stored callback
            ),
          ),
        );
      },
    );
  }
}