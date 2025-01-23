import 'package:flutter/material.dart';

import '../../../../../models/chat_model.dart';
import '../../../../../services/auth_service.dart';
import '../../../../../services/chat_service.dart';




class MessageInput extends StatefulWidget {
  final String chatRoomId;

  const MessageInput({
    Key? key,
    required this.chatRoomId,
  }) : super(key: key);

  @override
  State<MessageInput> createState() => _MessageInputState();
}

class _MessageInputState extends State<MessageInput> {
  final _controller = TextEditingController();
  bool _isLoading = false;

  Future<void> _sendMessage() async {
    if (_controller.text.trim().isEmpty) return;

    setState(() => _isLoading = true);

    try {
      final message = ChatMessage(
        id: '',
        senderId: AuthService().currentUser!.uid,
        content: _controller.text.trim(),
        timestamp: DateTime.now(),
      );

      await ChatService().sendMessage(widget.chatRoomId, message);
      _controller.clear();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: const InputDecoration(
                hintText: 'Type a message...',
                border: InputBorder.none,
              ),
              textCapitalization: TextCapitalization.sentences,
              maxLines: null,
            ),
          ),
          IconButton(
            icon: _isLoading
                ? const SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
                : const Icon(Icons.send),
            onPressed: _isLoading ? null : _sendMessage,
          ),
        ],
      ),
    );
  }
}