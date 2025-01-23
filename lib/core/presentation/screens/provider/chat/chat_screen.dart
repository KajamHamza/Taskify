import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../../../../models/chat_model.dart';
import '../../../../models/user_model.dart';
import '../../../../services/auth_service.dart';
import '../../../../services/chat_service.dart';
import '../../../../services/firestore_service.dart';
import 'widgets/message_bubble.dart';

class ChatScreen extends StatefulWidget {
  final ChatRoom chatRoom;

  const ChatScreen({
    Key? key,
    required this.chatRoom,
  }) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _textController = TextEditingController();

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    final text = _textController.text.trim();
    if (text.isNotEmpty) {
      ChatService().sendMessage(
        widget.chatRoom.id,
        ChatMessage(
          id: Uuid().v4(),
          senderId: AuthService().currentUser!.uid,
          content: text,
          timestamp: DateTime.now(),
        ),
      );
      _textController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentUserId = AuthService().currentUser!.uid;
    final otherUserId = widget.chatRoom.providerId == currentUserId
        ? widget.chatRoom.clientId
        : widget.chatRoom.providerId;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: StreamBuilder<UserModel>(
          stream: FirestoreService().getUserStream(otherUserId),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return const SizedBox();
            return Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundImage: snapshot.data!.photoUrl != null
                      ? NetworkImage(snapshot.data!.photoUrl!)
                      : null,
                  child: snapshot.data!.photoUrl == null
                      ? const Icon(Icons.person)
                      : null,
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      snapshot.data!.name,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Row(
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: Colors.green,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Online',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<List<ChatMessage>>(
              stream: ChatService().getMessages(widget.chatRoom.id),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                return ListView.builder(
                  reverse: true,
                  padding: const EdgeInsets.all(16),
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    final message = snapshot.data![index];
                    return MessageBubble(
                      message: message,
                      isMe: message.senderId == currentUserId,
                    );
                  },
                );
              },
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                ),
              ],
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: TextField(
                          controller: _textController,
                          decoration: const InputDecoration(
                            hintText: 'Type a message...',
                            border: InputBorder.none,
                          ),
                          onSubmitted: (text) => _sendMessage(),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.send, color: Colors.white),
                        onPressed: _sendMessage,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}