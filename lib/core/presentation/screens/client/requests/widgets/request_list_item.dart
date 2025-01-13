import 'package:flutter/material.dart';
import '../../../../../../core/models/service_request_model.dart';
import '../../../../../../core/utils/date_formatter.dart';
import '../../../../../../core/utils/price_formatter.dart';

class RequestListItem extends StatelessWidget {
  final ServiceRequestModel request;
  final VoidCallback? onAccept;
  final VoidCallback? onReject;
  final VoidCallback? onComplete;

  const RequestListItem({
    Key? key,
    required this.request,
    this.onAccept,
    this.onReject,
    this.onComplete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  '#${request.id.substring(0, 8)}',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const Spacer(),
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
           request.status == RequestStatus.inProgress;
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
      case RequestStatus.inProgress:
        return [
          FilledButton(
            onPressed: onComplete,
            child: const Text('Mark as Complete'),
          ),
        ];
      default:
        return [];
    }
  }
}