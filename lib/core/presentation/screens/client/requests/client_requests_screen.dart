import 'package:flutter/material.dart';
import '../../../../models/service_request_model.dart';
import '../../../../services/auth_service.dart';
import '../../../../services/booking_service.dart';
import 'widgets/request_list_item.dart';

class ClientRequestsScreen extends StatelessWidget {
  final _bookingService = BookingService();
  final _authService = AuthService();

  ClientRequestsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currentUserId = _authService.currentUser?.uid;
    if (currentUserId == null) {
      return const Center(child: Text('Please login to view requests'));
    }

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('My Requests'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Active'),
              Tab(text: 'Completed'),
              Tab(text: 'Cancelled'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _RequestsList(
              clientId: currentUserId,
              statuses: [RequestStatus.pending, RequestStatus.accepted, RequestStatus.inProgress],
            ),
            _RequestsList(
              clientId: currentUserId,
              statuses: [RequestStatus.completed],
            ),
            _RequestsList(
              clientId: currentUserId,
              statuses: [RequestStatus.cancelled, RequestStatus.rejected],
            ),
          ],
        ),
      ),
    );
  }
}

class _RequestsList extends StatelessWidget {
  final String clientId;
  final List<RequestStatus> statuses;
  final _bookingService = BookingService();

  _RequestsList({
    Key? key,
    required this.clientId,
    required this.statuses,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<ServiceRequestModel>>(
      stream: _bookingService.getClientBookings(clientId, null),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final requests = snapshot.data!
            .where((request) => statuses.contains(request.status))
            .toList();

        if (requests.isEmpty) {
          return Center(
            child: Text(
              'No ${statuses.first.toString().split('.').last} requests',
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
              onReject: requests[index].status == RequestStatus.pending
                  ? () async {
                try {
                  await _bookingService.updateBookingStatus(
                    requests[index].id,
                    RequestStatus.cancelled,
                  );
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Request cancelled')),
                    );
                  }
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(e.toString())),
                    );
                  }
                }
              }
                  : null,
            );
          },
        );
      },
    );
  }
}