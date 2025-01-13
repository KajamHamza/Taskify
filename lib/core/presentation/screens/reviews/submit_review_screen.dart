import 'package:flutter/material.dart';
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
        images: _images, userId: '',
      );// to check !!

      if (mounted) {
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
    } finally {
      setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Write Review')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            widget.serviceName,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 24),
          RatingSelector(
            initialRating: _rating,
            onRatingChanged: (rating) => setState(() => _rating = rating),
          ),
          const SizedBox(height: 24),
          TextField(
            controller: _commentController,
            maxLines: 4,
            decoration: const InputDecoration(
              hintText: 'Write your review...',
              alignLabelWithHint: true,
            ),
          ),
          const SizedBox(height: 24),
          ReviewImagePicker(
            images: _images,
            onImagesChanged: (images) => setState(() => _images = images),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: FilledButton(
            onPressed: _isSubmitting ? null : _submitReview,
            child: _isSubmitting
                ? const CircularProgressIndicator()
                : const Text('Submit Review'),
          ),
        ),
      ),
    );
  }
}