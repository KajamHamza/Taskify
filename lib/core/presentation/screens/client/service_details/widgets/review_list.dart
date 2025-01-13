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
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Reviews',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            TextButton(
              onPressed: () {
                // Show all reviews
              },
              child: const Text('See All'),
            ),
          ],
        ),
        StreamBuilder<List<ReviewModel>>(
          stream: FirestoreService().getServiceReviews(serviceId),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }

            final reviews = snapshot.data!;

            if (reviews.isEmpty) {
              return const Center(
                child: Text('No reviews yet'),
              );
            }

            return ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: reviews.length > 3 ? 3 : reviews.length,
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