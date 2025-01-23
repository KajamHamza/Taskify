import 'package:flutter/material.dart';
import '../../../../../models/review_model.dart';
import '../../../../../services/review_service.dart';

class ReviewsScreen extends StatelessWidget {
  final String serviceId;
  final String clientId;

  const ReviewsScreen({
    Key? key,
    required this.serviceId,
    required this.clientId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: StreamBuilder<List<ReviewModel>>(
        stream: ReviewService().getClientServiceReviews(clientId, serviceId),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.red),
              ),
            );
          }

          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final reviews = snapshot.data!;

          return DraggableScrollableSheet(
            initialChildSize: 0.6,
            minChildSize: 0.5,
            maxChildSize: 0.95,
            builder: (context, scrollController) {
              return Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Container(
                      width: 40,
                      height: 4,
                      margin: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        'Reviews (${reviews.length})',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    if (reviews.isEmpty)
                      const Expanded(
                        child: Center(
                          child: Text(
                            'No reviews yet',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                          ),
                        ),
                      )
                    else
                      Expanded(
                        child: ListView.builder(
                          controller: scrollController,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: reviews.length,
                          itemBuilder: (context, index) {
                            final review = reviews[index];
                            return Card(
                              elevation: 4,
                              margin: const EdgeInsets.only(bottom: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        CircleAvatar(
                                          radius: 24,
                                          backgroundImage: review.userPhotoUrl != null
                                              ? NetworkImage(review.userPhotoUrl!)
                                              : null,
                                          child: review.userPhotoUrl == null
                                              ? const Icon(Icons.person)
                                              : null,
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Text(
                                            'Reviewed on ${review.createdAt.toString().split(' ')[0]}',
                                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                              color: Colors.grey[600],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 12),
                                    Row(
                                      children: [
                                        ...List.generate(
                                          5,
                                              (index) => Icon(
                                            index < review.rating ? Icons.star : Icons.star_border,
                                            color: Colors.amber,
                                            size: 20,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          review.rating.toString(),
                                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black54,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 12),
                                    Text(
                                      review.comment,
                                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                        height: 1.5,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}