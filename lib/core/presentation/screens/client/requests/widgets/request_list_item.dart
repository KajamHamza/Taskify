import 'package:Taskify/core/models/user_model.dart';
import 'package:flutter/material.dart';
import '../../../../../../core/models/service_request_model.dart';
import '../../../../../../core/services/firestore_service.dart';
import '../../../../../../core/utils/date_formatter.dart';
import '../../../../../../core/utils/price_formatter.dart';
import '../../../../../models/service_model.dart';

class RequestListItem extends StatelessWidget {
  final ServiceRequestModel request;
  final VoidCallback? onReject;
  final VoidCallback? onSubmitReview;

  const RequestListItem({
    Key? key,
    required this.request,
    this.onReject,
    this.onSubmitReview,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2, // Add a subtle shadow
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12), // Rounded corners
      ),
      color: Colors.white, // White background for the card
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Service Name
            FutureBuilder<ServiceModel?>(
              future: FirestoreService().getServiceById(request.serviceId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                  );
                }
                if (snapshot.hasError || !snapshot.hasData) {
                  return Text(
                    'Service not found',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  );
                }
                final service = snapshot.data!;
                return Text(
                  service.title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                );
              },
            ),
            const SizedBox(height: 8),
            // Service Provider Name
            FutureBuilder<UserModel?>(
              future: FirestoreService().getServiceProviderById(request.providerId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                  );
                }
                if (snapshot.hasError || !snapshot.hasData) {
                  return Text(
                    'Provider not found',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    ),
                  );
                }
                final provider = snapshot.data!;
                return Text(
                  'Provider: ${provider.name}',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                  ),
                );
              },
            ),
            const SizedBox(height: 12),
            // Request ID and Status
            Row(
              children: [
                Text(
                  '#${request.id.substring(0, 8)}',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                  ),
                ),
                const Spacer(),
                _buildStatusChip(context),
              ],
            ),
            const SizedBox(height: 12),
            // Proposed Price
            Text(
              PriceFormatter.formatPrice(request.proposedPrice),
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.blue.shade700, // Blue shade accent for price
              ),
            ),
            const SizedBox(height: 8),
            // Created At
            Text(
              'Created ${DateFormatter.getTimeAgo(request.createdAt)}',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade600,
              ),
            ),
            // Reject Button (for pending requests)
            if (request.status == RequestStatus.pending && onReject != null) ...[
              const Divider(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  FilledButton(
                    onPressed: onReject,
                    style: FilledButton.styleFrom(
                      backgroundColor: Colors.red.shade50, // Red background color
                      foregroundColor: Colors.red, // White text color
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8), // Rounded corners
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12), // Button padding
                    ),
                    child: const Text('Cancel Request'),
                  ),
                ],
              ),
            ],
            // Submit Review Button (for completed requests)
            if (request.status == RequestStatus.completed && onSubmitReview != null) ...[
              const Divider(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  FilledButton(
                    onPressed: onSubmitReview,
                    style: FilledButton.styleFrom(
                      backgroundColor: Colors.blue.shade50, // Blue background color
                      foregroundColor: Colors.blue, // White text color
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8), // Rounded corners
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12), // Button padding
                    ),
                    child: const Text('Submit Review'),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildStatusChip(BuildContext context) {
    Color color;
    String statusText;
    switch (request.status) {
      case RequestStatus.pending:
        color = Colors.orange;
        statusText = 'Pending';
        break;
      case RequestStatus.accepted:
        color = Colors.blue;
        statusText = 'Accepted';
        break;
      case RequestStatus.inProgress:
        color = Colors.blue;
        statusText = 'In Progress';
        break;
      case RequestStatus.completed:
        color = Colors.green;
        statusText = 'Completed';
        break;
      case RequestStatus.cancelled:
        color = Colors.red;
        statusText = 'Cancelled';
        break;
      case RequestStatus.rejected:
        color = Colors.red;
        statusText = 'Rejected';
        break;
      case RequestStatus.paid:
        color = Colors.purple;
        statusText = 'Paid';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20), // Rounded corners
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Text(
        statusText,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}