import 'package:flutter/material.dart';
import '../../../../../core/models/service_request_model.dart';
import '../../../../services/auth_service.dart';
import '../../../../services/firestore_service.dart';
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
            _RequestsList(status: RequestStatus.inProgress),
            _RequestsList(status: RequestStatus.completed),
            _RequestsList(status: RequestStatus.cancelled),
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
    return StreamBuilder<List<ServiceRequestModel>>(
      stream: FirestoreService().getServiceRequests(
        providerId: AuthService().currentUser?.uid,
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
              onAccept: () {
                // Handle accept request
              },
              onReject: () {
                // Handle reject request
              },
              onComplete: () {
                // Handle complete request
              },
            );
          },
        );
      },
    );
  }
}