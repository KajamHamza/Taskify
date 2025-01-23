import 'package:flutter/material.dart';
import '../../../services/auth_service.dart';
import '../../../services/firestore_service.dart';
import 'widgets/rating_selector.dart';
import 'widgets/review_image_picker.dart';

class SubmitReviewScreen extends StatefulWidget {
  final String serviceId;
  final String serviceName;

  const SubmitReviewScreen({
    Key? key,
    required this.serviceId,
    required this.serviceName,
  }) : super(key: key);

  @override
  State<SubmitReviewScreen> createState() => _SubmitReviewScreenState();
}

class _SubmitReviewScreenState extends State<SubmitReviewScreen> {
  final _commentController = TextEditingController();
  double _rating = 0;
  List<String> _images = [];
  bool _isSubmitting = false;

  Future<void> _submitReview() async {
    if (_rating == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a rating')),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      await FirestoreService().addReview(
        serviceId: widget.serviceId,
        rating: _rating,
        comment: _commentController.text,
        images: _images,
        userId: AuthService().getCurrentUserId(), // Add the correct userId here
      );

      if (mounted) {
        // Show the thank you dialog
        _showThankYouDialog(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to submit review: ${e.toString()}')),
        );
      }
    } finally {
      setState(() => _isSubmitting = false);
    }
  }

  void _showThankYouDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          backgroundColor: Colors.white,
          insetPadding: const EdgeInsets.symmetric(horizontal: 40, vertical: 100), // Adjust padding for a larger dialog
          content: SizedBox(
            width: double.maxFinite, // Make the dialog wider
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.check_circle,
                  size: 80, // Larger icon
                  color: Colors.green,
                ),
                const SizedBox(height: 24),
                Text(
                  'Thank you for your honesty!',
                  style: TextStyle(
                    fontSize: 24, // Larger text
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                FilledButton(
                  onPressed: () {
                    Navigator.pop(context); // Close the dialog
                    Navigator.pop(context); // Go back to the home screen
                  },
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32), // Larger button padding
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    backgroundColor: Colors.blue.shade700,
                  ),
                  child: const Text(
                    'Go Back Home',
                    style: TextStyle(
                      fontSize: 18, // Larger text
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // White background
      appBar: AppBar(
        title: const Text(
          'Rating',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        backgroundColor: Colors.white, // White app bar
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black87), // Black back icon
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Text(
              'How was the ${widget.serviceName} service?',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Share your experience working together!',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 24),
            // Rating Selector
            RatingSelector(
              initialRating: _rating,
              onRatingChanged: (rating) => setState(() => _rating = rating),
            ),
            const SizedBox(height: 24),
            // Review Categories
            Text(
              'Other Reviews',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _buildReviewCategory('Professional'),
                _buildReviewCategory('Punctual'),
                _buildReviewCategory('Quality Work'),
                _buildReviewCategory('Good Communication'),
              ],
            ),
            const SizedBox(height: 24),
            // Comment Section
            Text(
              'Comments',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _commentController,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: 'Good guy!',
                alignLabelWithHint: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.blue.shade700),
                ),
                filled: true,
                fillColor: Colors.grey.shade100,
              ),
            ),
            const SizedBox(height: 24),
            // Add Photo Section
            Text(
              'Add Photo',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 12),
            ReviewImagePicker(
              images: _images,
              onImagesChanged: (images) => setState(() => _images = images),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: FilledButton(
            onPressed: _isSubmitting ? null : _submitReview,
            style: FilledButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              backgroundColor: Colors.blue.shade50,
            ),
            child: _isSubmitting
                ? const SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            )
                : const Text(
              'Submit',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildReviewCategory(String category) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        category,
        style: TextStyle(
          fontSize: 14,
          color: Colors.black87,
        ),
      ),
    );
  }
}