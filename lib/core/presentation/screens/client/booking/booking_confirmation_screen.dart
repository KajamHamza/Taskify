import 'package:flutter/material.dart';

import '../../../../models/service_request_model.dart';
import '../../../../services/firestore_service.dart';
import '../../../../utils/date_formatter.dart';

class BookingConfirmationScreen extends StatelessWidget {
  final String requestId;

  const BookingConfirmationScreen({
    Key? key,
    required this.requestId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<ServiceRequestModel>(
        stream: FirestoreService().getServiceRequest(requestId),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final request = snapshot.data!;

          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.check_circle_outline,
                    size: 80,
                    color: Colors.green,
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Booking Confirmed!',
                    style: Theme.of(context).textTheme.headlineMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Your request has been sent to the service provider',
                    style: Theme.of(context).textTheme.bodyLarge,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          // Removed Booking ID row
                          _buildInfoRow(
                            context,
                            'Status',
                            request.status.toString().split('.').last.toUpperCase(),
                          ),
                          const Divider(height: 24),
                          _buildInfoRow(
                            context,
                            'Created',
                            DateFormatter.formatDateTime(request.createdAt),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  FilledButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, '/client/requests');
                    },
                    child: const Text('View My Requests'),
                  ),
                  const SizedBox(height: 16),
                  OutlinedButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, '/client/home');
                    },
                    child: const Text('Back to Home'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context, String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        Text(
          value,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}