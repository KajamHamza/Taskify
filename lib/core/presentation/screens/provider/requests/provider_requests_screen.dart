import 'package:Taskify/core/presentation/screens/provider/requests/widgets/reviews_widget.dart';
import 'package:flutter/material.dart';
import '../../../../../core/models/service_request_model.dart';
import '../../../../services/auth_service.dart';
import '../../../../services/chat_service.dart';
import '../../../../services/firestore_service.dart';
import '../../provider/chat/chat_list_screen.dart';
import 'widgets/request_list_item.dart';

class ProviderRequestsScreen extends StatelessWidget {
  const ProviderRequestsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Service Requests'),
          actions: [
            IconButton(
              icon: const Icon(Icons.chat),
              onPressed: () async {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ChatListScreen()),
                );
              },
            ),
          ],
          bottom: const TabBar(
            isScrollable: true,
            tabs: [
              Tab(text: 'Pending'),
              Tab(text: 'Active'),
              Tab(text: 'Completed'),
              Tab(text: 'Cancelled'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _RequestsList(status: RequestStatus.pending),
            _RequestsList(status: RequestStatus.accepted),
            _RequestsList(status: RequestStatus.completed),
            _RequestsList(status: RequestStatus.rejected),
          ],
        ),
      ),
    );
  }
}

class _RequestsList extends StatelessWidget {
  final RequestStatus status;

  const _RequestsList({
    Key? key,
    required this.status,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String? userId = AuthService().currentUser?.uid;

    if (userId == null) {
      return const Center(child: Text('User not logged in'));
    }

    return StreamBuilder<List<ServiceRequestModel>>(
      stream: FirestoreService().getServiceRequests(
        providerId: userId,
        status: status,
      ),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final requests = snapshot.data!;

        if (requests.isEmpty) {
          return Center(
            child: Text(
              'No ${status.toString().split('.').last} requests',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: requests.length,
          itemBuilder: (context, index) {
            return RequestListItem(
              request: requests[index],
              onAccept: () async {
                await FirestoreService().updateRequestStatus(
                  requests[index].id,
                  RequestStatus.accepted,
                  isPaid: false,
                  completedAt: null,
                );
              },
              onReject: () async {
                await FirestoreService().updateRequestStatus(
                  requests[index].id,
                  RequestStatus.rejected,
                  isPaid: false,
                  completedAt: DateTime.now(),
                );
              },
              onComplete: () async {
                await FirestoreService().updateRequestStatus(
                  requests[index].id,
                  RequestStatus.completed,
                  isPaid: true,
                  completedAt: DateTime.now(),
                );
              },
              onViewReviews: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                  ),
                  builder: (context) => Scaffold(
                    backgroundColor: Colors.transparent,
                    body: ReviewsScreen(
                      serviceId: requests[index].serviceId,
                      clientId: requests[index].clientId,
                    ),
                  ),
                );

              },
              firestoreService: FirestoreService(),
            );
          },
        );
      },
    );
  }
}