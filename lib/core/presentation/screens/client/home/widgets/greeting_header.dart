import 'package:flutter/material.dart';
import '../../../../../../core/models/user_model.dart';
import '../../../../../../core/services/firestore_service.dart';
import '../../../../../../core/services/auth_service.dart';

class GreetingHeader extends StatelessWidget {
  const GreetingHeader({Key? key}) : super(key: key);

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning!';
    if (hour < 17) return 'Good afternoon!';
    return 'Good evening!';
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: StreamBuilder<UserModel>(
            stream: FirestoreService().getUserStream(
              AuthService().currentUser?.uid ?? '',
            ),
            builder: (context, snapshot) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _getGreeting(),
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    snapshot.data?.name ?? 'Guest',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              );
            },
          ),
        ),
        IconButton(
          icon: const Icon(Icons.chat_bubble_outline),
          onPressed: () => Navigator.pushNamed(context, '/chat'),
        ),
        IconButton(
          icon: const Icon(Icons.notifications_outlined),
          onPressed: () => Navigator.pushNamed(context, '/notifications'),
        ),
        CircleAvatar(
          backgroundImage: NetworkImage(
            AuthService().currentUser?.photoURL ?? '',
          ),
          child: AuthService().currentUser?.photoURL == null
              ? const Icon(Icons.person)
              : null,
        ),
      ],
    );
  }
}