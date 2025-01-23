import 'package:flutter/material.dart';
import '../../../../../../core/models/service_request_model.dart';
import '../../../../../../core/utils/date_formatter.dart';
import '../../../../../../core/utils/price_formatter.dart';
import '../../../../../services/firestore_service.dart';
import '../../../../../services/chat_service.dart';

class RequestListItem extends StatelessWidget {
  final ServiceRequestModel request;
  final VoidCallback? onAccept;
  final VoidCallback? onReject;
  final VoidCallback? onComplete;
  final VoidCallback? onViewReviews;
  final VoidCallback? onChat;
  final FirestoreService firestoreService;

  const RequestListItem({
    Key? key,
    required this.request,
    this.onAccept,
    this.onReject,
    this.onComplete,
    this.onViewReviews,
    this.onChat,
    required this.firestoreService,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<String?>>(
      future: Future.wait([
        _safeGetServiceName(),
        _safeGetClientName(),
      ]),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: CircularProgressIndicator(),
            ),
          );
        }

        final serviceName = snapshot.data?[0] ?? "Unknown Service";
        final clientName = snapshot.data?[1] ?? "Unknown Client";

        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            serviceName,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Client: $clientName',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (onChat != null) ...[
                      IconButton(
                        icon: const Icon(Icons.chat_bubble_outline),
                        onPressed: onChat,
                        tooltip: 'Open Chat',
                      ),
                    ],
                    const SizedBox(width: 8),
                    _buildStatusChip(context),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  PriceFormatter.formatPrice(request.proposedPrice),
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Created ${DateFormatter.getTimeAgo(request.createdAt)}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                if (_shouldShowActions()) ...[
                  const Divider(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: _buildActionButtons(context),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  Future<String?> _safeGetServiceName() async {
    if (request.serviceId == null || request.serviceId.isEmpty) {
      return "Unknown Service";
    }
    try {
      return await firestoreService.getServiceName(request.serviceId);
    } catch (e) {
      debugPrint('Error getting service name: $e');
      return "Unknown Service";
    }
  }

  Future<String?> _safeGetClientName() async {
    if (request.clientId == null || request.clientId.isEmpty) {
      return "Unknown Client";
    }
    try {
      debugPrint('Client ID: ${request.clientId}');
      return await firestoreService.getClientNamebyID(request.clientId);
    } catch (e) {
      debugPrint('Error getting client name: $e');
      return "Unknown Client";
    }
  }


  Widget _buildStatusChip(BuildContext context) {
    Color color;
    switch (request.status) {
      case RequestStatus.pending:
        color = Colors.orange;
        break;
      case RequestStatus.accepted:
      case RequestStatus.inProgress:
        color = Colors.blue;
        break;
      case RequestStatus.completed:
        color = Colors.green;
        break;
      case RequestStatus.cancelled:
        color = Colors.red;
        break;
      case RequestStatus.rejected:
        color = Colors.red;
        break;
      case RequestStatus.paid:
        color = Colors.purple;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        request.status.toString().split('.').last.toUpperCase(),
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  bool _shouldShowActions() {
    return request.status == RequestStatus.pending ||
        request.status == RequestStatus.accepted ||
        request.status == RequestStatus.inProgress ||
        request.status == RequestStatus.completed;
  }

  List<Widget> _buildActionButtons(BuildContext context) {
    switch (request.status) {
      case RequestStatus.pending:
        return [
          OutlinedButton(
            onPressed: onReject,
            child: const Text('Reject'),
          ),
          const SizedBox(width: 8),
          FilledButton(
            onPressed: onAccept,
            child: const Text('Accept'),
          ),
        ];
      case RequestStatus.accepted:
        return [
          FilledButton(
            onPressed: onComplete,
            child: const Text('Completed'),
          ),
          const SizedBox(width: 8),
          FilledButton(
            onPressed: onReject,
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.red),
            ),
            child: const Text('Cancel Request'),
          ),
        ];
      case RequestStatus.completed:
        return [
          FilledButton(
            onPressed: onViewReviews,
            child: const Text('View Reviews'),
          ),
        ];
      default:
        return [];
    }
  }
}