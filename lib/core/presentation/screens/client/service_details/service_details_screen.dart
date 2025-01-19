import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../../../../models/chat_model.dart';
import '../../../../models/service_model.dart';
import '../../../../services/auth_service.dart';
import '../../../../services/chat_service.dart';
import '../../chat/chat_screen.dart';
import 'widgets/service_image_carousel.dart';
import 'widgets/provider_info_card.dart';
import 'widgets/review_list.dart';
import 'widgets/booking_bottom_sheet.dart';

class ServiceDetailsScreen extends StatelessWidget {
  final ServiceModel service;
  final _chatService = ChatService();
  final _authService = AuthService();

  ServiceDetailsScreen({
    Key? key,
    required this.service,
  }) : super(key: key);

  Future<void> _startChat(BuildContext context) async {
    log("Starting chat with provider: ${service.providerId}");
    try {
      final currentUserId = _authService.currentUser?.uid;
      log("Current User ID: $currentUserId");
      if (currentUserId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please login to chat')),
        );
        return;
      }

      // Check if chat room exists
      final existingRoom = await _chatService.findChatRoom(
        clientId: currentUserId,
        providerId: service.providerId,
      );
      log("Existing Room: ${existingRoom?.toString() ?? 'null'}");

      final ChatRoom chatRoom;
      if (existingRoom is ChatRoom) {
        chatRoom = existingRoom;
      } else {
        chatRoom = await _chatService.createChatRoom(
          ChatRoom(
            id: Uuid().v4(),
            serviceId: service.id,
            clientId: currentUserId,
            providerId: service.providerId,
            createdAt: DateTime.now(),
          ),
        );
      }
      log("Chat Room: $chatRoom");

      if (context.mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatScreen(chatRoom: chatRoom),
          ),
        );
      } else {
        log("Context is not mounted");
      }
    } catch (e) {
      log("Error: $e");
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: ServiceImageCarousel(images: service.images),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    service.title,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    service.description,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 24),
                  ProviderInfoCard(
                    providerId: service.providerId,
                    onChatPressed: () => _startChat(context),
                  ),
                  const SizedBox(height: 24),
                  ReviewList(serviceId: service.id),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BookingBottomSheet(service: service),
    );
  }
}