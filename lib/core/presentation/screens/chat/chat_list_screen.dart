import 'package:flutter/material.dart';
import 'package:Taskify/core/presentation/screens/chat/widgets/chat_list_item.dart';
import '../../../models/chat_model.dart';
import '../../../services/auth_service.dart';
import '../../../services/chat_service.dart';

class ChatListScreen extends StatelessWidget {
  const ChatListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currentUserId = AuthService().currentUser!.uid;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Messages',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // Add search functionality here
            },
          ),
        ],
      ),
      body: StreamBuilder<List<ChatRoom>>(
        stream: ChatService().getUserChats(currentUserId),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.red.shade700,
                ),
              ),
            );
          }

          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
              ),
            );
          }

          final chatRooms = snapshot.data!;

          if (chatRooms.isEmpty) {
            return Center(
              child: Text(
                'No messages yet',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey.shade600,
                ),
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: chatRooms.length,
            itemBuilder: (context, index) {
              return ChatListItem(
                chatRoom: chatRooms[index],
                currentUserId: currentUserId,
              );
            },
            separatorBuilder: (context, index) {
              return const Divider(
                height: 1,
                thickness: 1,
                color: Colors.grey,
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add functionality to start a new chat
        },
        backgroundColor: Colors.blue,
        child: const Icon(
          Icons.message,
          color: Colors.white,
        ),
      ),
    );
  }
}