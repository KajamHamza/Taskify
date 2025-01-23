import 'package:Taskify/core/models/service_model.dart';
import 'package:flutter/material.dart';
import '../../../../../../core/services/firestore_service.dart';
import '../../../../../models/user_model.dart';
import 'dart:developer';

import '../../../../../utils/price_formatter.dart';
import '../../service_details/service_details_screen.dart';

class TopTaskers extends StatelessWidget {
  const TopTaskers({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            children: [
              Text(
                'Top Services',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'Experts lead you through topics.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        StreamBuilder<List<ServiceModel>>(
          stream: FirestoreService().getTopRatedServicesStream(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('No top services available'));
            }

            return SizedBox(
              height: 260, // Fixed height
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  final service = snapshot.data![index];
                  return TaskerCard(service: service);
                },
              ),
            );
          },
        ),
      ],
    );
  }
}

class TaskerCard extends StatelessWidget {
  final ServiceModel service;

  const TaskerCard({
    Key? key,
    required this.service,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2, // Subtle shadow
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12), // Rounded corners
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ServiceDetailsScreen(service: service),
            ),
          );
        },
        borderRadius: BorderRadius.circular(12), // Match card's rounded corners
        child: SizedBox(
          width: 180, // Increased width for better spacing
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Service Image (Takes more space)
              AspectRatio(
                aspectRatio: 4 / 3, // Wider and taller image
                child: Image.network(
                  service.images.isNotEmpty ? service.images.first : 'https://via.placeholder.com/160x120',
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
              // Service Details (Compact section)
              Padding(
                padding: const EdgeInsets.all(12), // Increased padding for better spacing
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Service Title
                    Text(
                      service.title,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6), // Increased spacing
                    // Service Description
                    Text(
                      service.description,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey[600],
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8), // Increased spacing
                    // Price and Rating
                    Row(
                      children: [
                        // Price
                        Text(
                          PriceFormatter.formatPrice(service.price),
                          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Spacer(),
                        // Rating
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.amber.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.star,
                                size: 14,
                                color: Colors.amber[700],
                              ),
                              const SizedBox(width: 4),
                              Text(
                                service.rating.toStringAsFixed(1),
                                style: Theme.of(context).textTheme.bodySmall,
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
      ),
    );
  }
}