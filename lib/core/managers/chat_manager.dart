import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import '../models/chat_model.dart';
import '../services/chat_service.dart';
import '../services/notification_service.dart';

class ChatManager {
  final ChatService _chatService;
  final NotificationService _notificationService;

  ChatManager({
    ChatService? chatService,
    NotificationService? notificationService,
  }) : _chatService = chatService ?? ChatService(),
        _notificationService = notificationService ?? NotificationService();

  Future<Object> getOrCreateChatRoom({
    required String clientId,
    required String providerId,
    required String serviceId,
  }) async {
    try {
      // Check for existing chat room
      final existingRoom = await _chatService.findChatRoom(
        clientId: clientId,
        providerId: providerId,
      );

      if (existingRoom != null) {
        return existingRoom;
      }

      // Create new chat room
      return await _chatService.createChatRoom(
        ChatRoom(
          id: Uuid().v4(),
          clientId: clientId,
          providerId: providerId,
          serviceId: serviceId,
          createdAt: DateTime.now(),
        ),
      );
    } catch (e) {
      throw Exception('Failed to create chat room: $e');
    }
  }

  Future<void> sendMessage({
    required String roomId,
    required String senderId,
    required String content,
    required String recipientId,
  }) async {
    try {
      await _chatService.sendMessage(
        roomId,
        ChatMessage(
          senderId: senderId,
          content: content,
          timestamp: DateTime.now(), id: Uuid().v4(),
        ),
      );

      // Send push notification
      await _notificationService.sendNotification(
        userId: recipientId,
        title: 'New Message',
        body: content,
        data: {'chatRoomId': roomId},
      );
    } catch (e) {
      throw Exception('Failed to send message: $e');
    }
  }

  Future<void> markMessagesAsRead(String roomId, String userId) async {
    await _chatService.markMessagesAsRead(roomId, userId);
  }
}