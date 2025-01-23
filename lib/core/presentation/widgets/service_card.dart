import 'package:flutter/material.dart';
import '../../../core/models/service_model.dart';
import '../../../core/utils/price_formatter.dart';

class ServiceCard extends StatelessWidget {
  final ServiceModel service;
  final VoidCallback onTap;

  const ServiceCard({
    Key? key,
    required this.service,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4, // Add a subtle shadow
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12), // Rounded corners
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12), // Match card's rounded corners
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Service Image
            AspectRatio(
              aspectRatio: 16 / 9,
              child: Image.network(
                service.images.first,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Container(
                    color: Colors.grey[200],
                    child: Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                            loadingProgress.expectedTotalBytes!
                            : null,
                      ),
                    ),
                  );
                },
                errorBuilder: (context, error, stackTrace) => Container(
                  color: Colors.grey[300],
                  child: const Center(
                    child: Icon(
                      Icons.error_outline,
                      color: Colors.red,
                    ),
                  ),
                ),
              ),
            ),
            // Service Details
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Service Title
                  Text(
                    service.title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8), // Spacing
                  // Service Description
                  Text(
                    service.description,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey[600],
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 12), // Spacing
                  // Price and Rating
                  Row(
                    children: [
                      // Price
                      Text(
                        PriceFormatter.formatPrice(service.price),
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      // Rating
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.amber.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.star,
                              size: 16,
                              color: Colors.amber[700],
                            ),
                            const SizedBox(width: 4),
                            Text(
                              service.rating.toStringAsFixed(1),
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '(${service.reviewCount})',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}