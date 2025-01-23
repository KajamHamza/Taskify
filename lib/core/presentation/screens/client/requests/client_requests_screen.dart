import 'package:Taskify/core/services/firestore_service.dart';
import 'package:flutter/material.dart';
import '../../../../models/service_model.dart';
import '../../../../models/service_request_model.dart';
import '../../../../services/auth_service.dart';
import '../../../../services/booking_service.dart';
import '../../reviews/submit_review_screen.dart';
import 'widgets/request_list_item.dart';

class ClientRequestsScreen extends StatelessWidget {
  final _bookingService = BookingService();
  final _authService = AuthService();

  ClientRequestsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: Future.value(_authService.currentUser!.uid),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            backgroundColor: Colors.white,
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (!snapshot.hasData || snapshot.data == null) {
          return Scaffold(
            backgroundColor: Colors.white,
            body: Center(
              child: Text(
                'Please login to view requests',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
          );
        }

        final currentUserId = snapshot.data!;

        return DefaultTabController(
          length: 3,
          child: Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              title: const Text(
                'My Requests',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              backgroundColor: Colors.white,
              elevation: 0,
              bottom: TabBar(
                indicatorColor: Colors.blue.shade700,
                labelColor: Colors.blue.shade700,
                unselectedLabelColor: Colors.grey.shade600,
                tabs: const [
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
      },
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
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
            ),
          );
        }

        if (snapshot.hasError) {
          return Center(
            child: Text(
              'Error: ${snapshot.error}',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.red.shade700,
              ),
            ),
          );
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(
            child: Text(
              'No ${statuses.first.toString().split('.').last} requests',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey.shade600,
              ),
            ),
          );
        }

        final requests = snapshot.data!
            .where((request) => statuses.contains(request.status))
            .toList();

        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: requests.length,
          separatorBuilder: (context, index) => const SizedBox(height: 16),
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
                      const SnackBar(
                        content: Text('Request cancelled'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  }
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(e.toString()),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                }
              }
                  : null,
              onSubmitReview: requests[index].status == RequestStatus.completed
                  ? () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FutureBuilder<ServiceModel?>(
                      future: FirestoreService().getServiceById(requests[index].serviceId),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return Scaffold(
                            body: Center(
                              child: CircularProgressIndicator(),
                            ),
                          );
                        }
                        if (snapshot.hasError || !snapshot.hasData || snapshot.data == null) {
                          return Scaffold(
                            body: Center(
                              child: Text('Error loading service'),
                            ),
                          );
                        }
                        return SubmitReviewScreen(
                          serviceId: requests[index].serviceId,
                          serviceName: snapshot.data!.title,
                        );
                      },
                    ),
                  ),
                );
              }
                  : null,
            );
          },
        );
      },
    );
  }
}