import 'package:flutter/material.dart';
import '../../../../../models/service_model.dart';
import '../../../../../utils/price_formatter.dart';
import '../../booking/booking_screen.dart';

class BookingBottomSheet extends StatelessWidget {
  final ServiceModel service;

  const BookingBottomSheet({
    Key? key,
    required this.service,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(20), // Rounded top corners
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 16, // Increased blur radius for a softer shadow
            offset: const Offset(0, -4), // Slightly larger offset for depth
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            // Price Section
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12), // Rounded corners
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Total Price',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 4), // Spacing between text
                  Text(
                    PriceFormatter.formatPrice(service.price),
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16), // Spacing between price and button
            // Book Now Button
            Expanded(
              child: FilledButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BookingScreen(service: service),
                    ),
                  );
                },
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16), // Taller button
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12), // Rounded corners
                  ),
                  backgroundColor: Theme.of(context).colorScheme.primary,
                ),
                child: Text(
                  'Book Now',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}