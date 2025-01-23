import 'package:flutter/material.dart';

import '../../../../../models/service_model.dart';
import '../../../../../utils/price_formatter.dart';

class BookingSummary extends StatelessWidget {
  final ServiceModel service;
  final DateTime? selectedDate;
  final TimeOfDay? selectedTime;
  final String paymentMethod;

  const BookingSummary({
    Key? key,
    required this.service,
    this.selectedDate,
    this.selectedTime,
    this.paymentMethod = 'online',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      color: Colors.white, // White background for the card
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Service Image and Title
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    service.images.first,
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        service.title,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        PriceFormatter.formatPrice(service.price),
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue.shade700,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Divider
            Divider(
              color: Colors.grey.shade300,
              thickness: 1,
            ),
            const SizedBox(height: 16),

            // Booking Details
            _buildDetailRow(
              icon: Icons.calendar_today,
              label: 'Date',
              value: selectedDate != null
                  ? '${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}'
                  : 'Not selected',
            ),
            const SizedBox(height: 12),
            _buildDetailRow(
              icon: Icons.access_time,
              label: 'Time',
              value: selectedTime != null
                  ? '${selectedTime!.hour}:${selectedTime!.minute.toString().padLeft(2, '0')}'
                  : 'Not selected',
            ),
            const SizedBox(height: 12),
            _buildDetailRow(
              icon: Icons.payment,
              label: 'Payment',
              value: paymentMethod == 'online' ? 'Pay Online' : 'Pay in Cash',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          size: 20,
          color: Colors.blue.shade700,
        ),
        const SizedBox(width: 12),
        Text(
          label,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        const Spacer(),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.blue.shade100, // Light blue background for the value
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black54,
            ),
          ),
        ),
      ],
    );
  }
}