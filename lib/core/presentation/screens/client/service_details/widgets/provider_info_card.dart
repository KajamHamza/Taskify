import 'package:flutter/material.dart';
import '../../../../../models/user_model.dart';
import '../../../../../services/firestore_service.dart'; // Import the profile screen

class ProviderInfoCard extends StatelessWidget {
  final String providerId;
  final VoidCallback onChatPressed;

  const ProviderInfoCard({
    Key? key,
    required this.providerId,
    required this.onChatPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<UserModel>(
      future: FirestoreService().getUser(providerId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data == null) {
          return const Center(child: Text('Provider information not available'));
        }

        final provider = snapshot.data!;

        return Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                // Clickable Provider Avatar
                InkWell(
                  onTap: () {
                    // Navigate to the provider's profile page
                    //Navigator.push(
                      //context,
                      //MaterialPageRoute(
                        //builder: (context) => ProviderProfileScreen(provider: provider),
                      //),
                    //);
                  },
                  borderRadius: BorderRadius.circular(24), // Match the avatar's radius
                  child: CircleAvatar(
                    radius: 24,
                    backgroundImage: provider.photoUrl != null
                        ? NetworkImage(provider.photoUrl!)
                        : null,
                    child: provider.photoUrl == null
                        ? const Icon(Icons.person, size: 24)
                        : null,
                  ),
                ),
                const SizedBox(width: 16),
                // Provider Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        provider.name,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (provider.isVerified)
                        Row(
                          children: [
                            const Icon(Icons.verified, size: 16, color: Colors.blue),
                            const SizedBox(width: 4),
                            Text(
                              'Verified Provider',
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Colors.blue,
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
                // Chat Button
                IconButton(
                  icon: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.chat_bubble_outline,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  onPressed: onChatPressed,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}