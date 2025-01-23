import 'package:Taskify/core/services/firestore_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../../../../../models/review_model.dart';
import '../../../../../utils/date_formatter.dart';

class ReviewItem extends StatelessWidget {
  final ReviewModel review;

  const ReviewItem({
    Key? key,
    required this.review,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2, // Subtle shadow
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12), // Rounded corners
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User Info and Rating
            Row(
              children: [
                // User Avatar
                CircleAvatar(
                  radius: 20, // Slightly larger avatar
                  backgroundImage: review.userPhotoUrl != null
                      ? NetworkImage(review.userPhotoUrl!)
                      : null,
                  child: review.userPhotoUrl == null
                      ? const Icon(Icons.person, size: 20)
                      : null,
                ),
                const SizedBox(width: 12), // Spacing between avatar and text
                // User Name and Date
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Use FutureBuilder to fetch userName
                      FutureBuilder<String?>(
                        future: FirestoreService.getUserName(review.userId),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.grey),
                            );
                          } else if (snapshot.hasError) {
                            return Text(
                              'Error loading name',
                              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.red,
                              ),
                            );
                          } else {
                            return Text(
                              snapshot.data ?? 'Unknown',
                              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            );
                          }
                        },
                      ),
                      Text(
                        DateFormatter.getTimeAgo(review.createdAt),
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                // Rating
                RatingBarIndicator(
                  rating: review.rating,
                  itemBuilder: (context, _) => const Icon(
                    Icons.star,
                    color: Colors.amber,
                  ),
                  itemSize: 16,
                ),
              ],
            ),
            const SizedBox(height: 12), // Spacing between sections
            // Review Comment
            Text(
              review.comment,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            // Review Images (if available)
            if (review.images != null && review.images!.isNotEmpty) ...[
              const SizedBox(height: 12),
              SizedBox(
                height: 80, // Increased height for images
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: review.images!.length,
                  separatorBuilder: (context, index) => const SizedBox(width: 8),
                  itemBuilder: (context, index) {
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(12), // Rounded corners for images
                      child: Image.network(
                        review.images![index],
                        width: 80, // Larger image size
                        height: 80,
                        fit: BoxFit.cover,
                      ),
                    );
                  },
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}