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
                  // Confirmation Icon
                  const Icon(
                    Icons.check_circle_outline,
                    size: 100,
                    color: Colors.green,
                  ),
                  const SizedBox(height: 24),
                  // Confirmation Title
                  Text(
                    'Booking Confirmed!',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  // Confirmation Subtitle
                  Text(
                    'Your request has been sent to the service provider',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Colors.black54,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  // Booking Details Card
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.blue.shade50,
                          Colors.blue.shade100,
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(16), // Rounded corners
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        _buildInfoRow(
                          context,
                          'Status',
                          request.status.toString().split('.').last.toUpperCase(),
                          Colors.blue.shade800,
                        ),
                        const SizedBox(height: 16),
                        const Divider(height: 1, color: Colors.black12),
                        const SizedBox(height: 16),
                        _buildInfoRow(
                          context,
                          'Created',
                          DateFormatter.formatDateTime(request.createdAt),
                          Colors.blue.shade800,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  // View My Requests Button
                  FilledButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, '/client/requests');
                    },
                    style: FilledButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12), // Rounded corners
                      ),
                    ),
                    child: const Text(
                      'View My Requests',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Back to Home Button
                  OutlinedButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, '/client/home');
                    },
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12), // Rounded corners
                      ),
                      side: BorderSide(
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    child: Text(
                      'Back to Home',
                      style: TextStyle(
                        fontSize: 16,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context, String label, String value, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: color.withOpacity(0.8),
          ),
        ),
        Text(
          value,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }
}