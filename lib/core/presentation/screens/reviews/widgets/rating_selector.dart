import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class RatingSelector extends StatelessWidget {
  final double initialRating;
  final ValueChanged<double> onRatingChanged;

  const RatingSelector({
    Key? key,
    required this.initialRating,
    required this.onRatingChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Rate this service',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 12),
        Center(
          child: RatingBar.builder(
            initialRating: initialRating,
            minRating: 1,
            maxRating: 5,
            direction: Axis.horizontal,
            itemCount: 5,
            itemSize: 40,
            itemPadding: const EdgeInsets.symmetric(horizontal: 8),
            itemBuilder: (context, _) => const Icon(
              Icons.star,
              color: Colors.amber,
            ),
            glowColor: Colors.amber.withOpacity(0.3),
            glowRadius: 2,
            unratedColor: Colors.grey.shade300,
            onRatingUpdate: onRatingChanged,
          ),
        ),
        const SizedBox(height: 8),
        Center(
          child: Text(
            _getRatingText(initialRating),
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.amber.shade700,
            ),
          ),
        ),
      ],
    );
  }

  String _getRatingText(double rating) {
    if (rating >= 4.5) {
      return 'Excellent!';
    } else if (rating >= 3.5) {
      return 'Good';
    } else if (rating >= 2.5) {
      return 'Average';
    } else if (rating >= 1.5) {
      return 'Below Average';
    } else {
      return 'Poor';
    }
  }
}