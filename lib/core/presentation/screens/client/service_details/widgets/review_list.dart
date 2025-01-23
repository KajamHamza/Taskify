import 'dart:developer';

import 'package:Taskify/core/services/review_service.dart';
import 'package:flutter/material.dart';
import '../../../../../models/review_model.dart';
import '../../../../../services/firestore_service.dart';
import 'review_item.dart';

class ReviewList extends StatelessWidget {
  final String serviceId;

  const ReviewList({
    Key? key,
    required this.serviceId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Reviews Header
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Reviews',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: () {
                  // Navigate to a full reviews page
                },
                style: TextButton.styleFrom(
                  foregroundColor: Theme.of(context).colorScheme.primary,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text('See All'),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8), // Spacing below the header
        // Reviews List
        StreamBuilder<List<ReviewModel>>(
          stream: ReviewService().getServiceReviews(serviceId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              log('Error fetching reviews: ${snapshot.error}');
              return const Center(child: Text('An error occurred'));
            }

            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Center(
                  child: Text(
                    'No reviews yet',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey[600],
                    ),
                  ),
                ),
              );
            }

            final reviews = snapshot.data!;

            return ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: reviews.length > 3 ? 3 : reviews.length,
              separatorBuilder: (context, index) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                return ReviewItem(review: reviews[index]);
              },
            );
          },
        ),
      ],
    );
  }
}