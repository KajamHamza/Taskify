import 'package:flutter/material.dart';

import '../../../../models/chat_model.dart';
import '../../../../models/user_model.dart';
import '../../../../services/firestore_service.dart';
import '../../../../utils/date_formatter.dart';
import '../chat_screen.dart';

class ChatListItem extends StatelessWidget {
  final ChatRoom chatRoom;
  final String currentUserId;

  const ChatListItem({
    Key? key,
    required this.chatRoom,
    required this.currentUserId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final otherUserId = chatRoom.clientId == currentUserId
        ? chatRoom.providerId
        : chatRoom.clientId;

    return ListTile(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatScreen(chatRoom: chatRoom),
          ),
        );
      },
      leading: StreamBuilder<UserModel>(
        stream: FirestoreService().getUserStream(otherUserId),
        builder: (context, snapshot) {
          return CircleAvatar(
            backgroundImage: snapshot.data?.photoUrl != null
                ? NetworkImage(snapshot.data!.photoUrl!)
                : null,
            child: snapshot.data?.photoUrl == null
                ? const Icon(Icons.person)
                : null,
          );
        },
      ),
      title: StreamBuilder<UserModel>(
        stream: FirestoreService().getUserStream(otherUserId),
        builder: (context, snapshot) {
          return Text(snapshot.data?.name ?? 'Loading...');
        },
      ),
      subtitle: Text(
        chatRoom.lastMessage ?? 'No messages yet',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: Text(
        chatRoom.lastMessageAt != null
            ? DateFormatter.getTimeAgo(chatRoom.lastMessageAt!)
            : '',
        style: Theme.of(context).textTheme.bodySmall,
      ),
    );
  }
}