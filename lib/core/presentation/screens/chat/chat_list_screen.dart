import 'package:Taskify/core/presentation/screens/chat/widgets/chat_list_item.dart';
import 'package:flutter/material.dart';

import '../../../models/chat_model.dart';
import '../../../services/auth_service.dart';
import '../../../services/chat_service.dart';


class ChatListScreen extends StatelessWidget {
  const ChatListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currentUserId = AuthService().currentUser!.uid;

    return Scaffold(
      appBar: AppBar(title: const Text('Messages')),
      body: StreamBuilder<List<ChatRoom>>(
        stream: ChatService().getUserChats(currentUserId),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final chatRooms = snapshot.data!;

          if (chatRooms.isEmpty) {
            return const Center(child: Text('No messages yet'));
          }

          return ListView.builder(
            itemCount: chatRooms.length,
            itemBuilder: (context, index) {
              return ChatListItem(
                chatRoom: chatRooms[index],
                currentUserId: currentUserId,
              );
            },
          );
        },
      ),
    );
  }
}