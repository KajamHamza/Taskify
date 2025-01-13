import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/chat_model.dart';
import '../utils/constants.dart';

class ChatService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Create a new chat room
  Future<String> createChatRoom(ChatRoom chatRoom) async {
    try {
      DocumentReference ref = await _db
          .collection(AppConstants.chatsCollection)
          .add(chatRoom.toMap());
      return ref.id;
    } catch (e) {
      throw Exception('Failed to create chat room: $e');
    }
  }

  // Send a message
  Future<void> sendMessage(String roomId, ChatMessage message) async {
    try {
      await _db
          .collection(AppConstants.chatsCollection)
          .doc(roomId)
          .collection('messages')
          .add(message.toMap());

      // Update chat room with last message
      await _db.collection(AppConstants.chatsCollection).doc(roomId).update({
        'lastMessage': message.content,
        'lastMessageAt': Timestamp.fromDate(message.timestamp),
      });
    } catch (e) {
      throw Exception('Failed to send message: $e');
    }
  }

  // Get messages stream for a chat room
  Stream<List<ChatMessage>> getMessages(String roomId) {
    return _db
        .collection(AppConstants.chatsCollection)
        .doc(roomId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => ChatMessage.fromFirestore(doc)).toList());
  }

  // Get chat rooms for a user
  Stream<List<ChatRoom>> getChatRooms(String userId) {
    return _db
        .collection(AppConstants.chatsCollection)
        .where(Filter.or(
          Filter('clientId', isEqualTo: userId),
          Filter('providerId', isEqualTo: userId),
        ))
        .orderBy('lastMessageAt', descending: true)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => ChatRoom.fromFirestore(doc)).toList());
  }

  // Mark messages as read
  Future<void> markMessagesAsRead(String roomId, String userId) async {
    try {
      WriteBatch batch = _db.batch();

      QuerySnapshot unreadMessages = await _db
          .collection(AppConstants.chatsCollection)
          .doc(roomId)
          .collection('messages')
          .where('isRead', isEqualTo: false)
          .where('senderId', isNotEqualTo: userId)
          .get();

      for (var doc in unreadMessages.docs) {
        batch.update(doc.reference, {'isRead': true});
      }

      await batch.commit();
    } catch (e) {
      throw Exception('Failed to mark messages as read: $e');
    }
  }

  Stream<List<ChatRoom>> getUserChats(String userId) {
    return _db
        .collection(AppConstants.chatsCollection)
        .where(Filter.or(
      Filter('clientId', isEqualTo: userId),
      Filter('providerId', isEqualTo: userId),
    ))
        .orderBy('lastMessageAt', descending: true)
        .snapshots()
        .map((snapshot) =>
        snapshot.docs.map((doc) => ChatRoom.fromFirestore(doc)).toList());
  }

  Future<ChatRoom?> findChatRoom({required String clientId, required String providerId}) async {
  try {
    final querySnapshot = await _db
        .collection(AppConstants.chatsCollection)
        .where('clientId', isEqualTo: clientId)
        .where('providerId', isEqualTo: providerId)
        .limit(1)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      return ChatRoom.fromFirestore(querySnapshot.docs.first);
    } else {
      return null;
    }
  } catch (e) {
    throw Exception('Failed to find chat room: $e');
  }
}

}