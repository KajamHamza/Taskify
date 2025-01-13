import 'package:cloud_firestore/cloud_firestore.dart';

class ChatMessage {
  final String id;
  final String senderId;
  final String content;
  final DateTime timestamp;
  final bool isRead;

  ChatMessage({
    required this.id,
    required this.senderId,
    required this.content,
    required this.timestamp,
    this.isRead = false,
  });

  factory ChatMessage.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return ChatMessage(
      id: doc.id,
      senderId: data['senderId'],
      content: data['content'],
      timestamp: (data['timestamp'] as Timestamp).toDate(),
      isRead: data['isRead'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'senderId': senderId,
      'content': content,
      'timestamp': Timestamp.fromDate(timestamp),
      'isRead': isRead,
    };
  }
}

class ChatRoom {
  final String id;
  final String serviceId;
  final String clientId;
  final String providerId;
  final DateTime createdAt;
  final DateTime? lastMessageAt;
  final String? lastMessage;

  ChatRoom({
    required this.id,
    required this.serviceId,
    required this.clientId,
    required this.providerId,
    required this.createdAt,
    this.lastMessageAt,
    this.lastMessage,
  });

  factory ChatRoom.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return ChatRoom(
      id: doc.id,
      serviceId: data['serviceId'],
      clientId: data['clientId'],
      providerId: data['providerId'],
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      lastMessageAt: data['lastMessageAt'] != null
          ? (data['lastMessageAt'] as Timestamp).toDate()
          : null,
      lastMessage: data['lastMessage'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'requestId': serviceId,
      'clientId': clientId,
      'providerId': providerId,
      'createdAt': Timestamp.fromDate(createdAt),
      'lastMessageAt': lastMessageAt != null
          ? Timestamp.fromDate(lastMessageAt!)
          : null,
      'lastMessage': lastMessage,
    };
  }
}