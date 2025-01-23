import 'package:flutter/material.dart';
import '../../../../../models/service_model.dart';
import '../../service_details/service_details_screen.dart';

class ServicePreviewCard extends StatelessWidget {
  final ServiceModel service;

  const ServicePreviewCard({
    Key? key,
    required this.service,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ServiceDetailsScreen(service: service),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16), // Rounded corners
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 12, // Increased blur radius
              offset: const Offset(0, 4), // Slightly larger offset
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Service Image and Details
            Row(
              children: [
                // Service Image
                ClipRRect(
                  borderRadius: BorderRadius.circular(12), // Rounded corners
                  child: Image.network(
                    service.images.first,
                    width: 100, // Slightly larger image
                    height: 100,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      width: 100,
                      height: 100,
                      color: Colors.grey[200],
                      child: const Icon(Icons.error_outline, color: Colors.red),
                    ),
                  ),
                ),
                const SizedBox(width: 16), // Spacing
                // Service Title and Price
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        service.title,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold, // Bold title
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8), // Spacing
                      Text(
                        '\$${service.price}',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.bold, // Bold price
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16), // Spacing
            // View Details Button
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8), // Rounded corners
              ),
              child: Center(
                child: Text(
                  'View Service Details',
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
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