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
      senderId: data['senderId'] ?? '', // Handle null senderId
      content: data['content'] ?? '', // Handle null content
      timestamp: (data['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now(), // Handle null timestamp
      isRead: data['isRead'] ?? false, // Handle null isRead
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
      serviceId: data['serviceId'] ?? '', // Handle null serviceId
      clientId: data['clientId'] ?? '', // Handle null clientId
      providerId: data['providerId'] ?? '', // Handle null providerId
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(), // Handle null createdAt
      lastMessageAt: data['lastMessageAt'] != null
          ? (data['lastMessageAt'] as Timestamp).toDate()
          : null, // Handle null lastMessageAt
      lastMessage: data['lastMessage'], // lastMessage can be null
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'serviceId': serviceId,
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