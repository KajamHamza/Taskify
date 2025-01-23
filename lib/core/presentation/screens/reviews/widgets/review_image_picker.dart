import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../services/storage_service.dart';

class ReviewImagePicker extends StatelessWidget {
  final List<String> images;
  final ValueChanged<List<String>> onImagesChanged;
  final int maxImages;

  const ReviewImagePicker({
    Key? key,
    required this.images,
    required this.onImagesChanged,
    this.maxImages = 3,
  }) : super(key: key);

  Future<void> _pickImage(BuildContext context) async {
    try {
      final picker = ImagePicker();
      final image = await picker.pickImage(source: ImageSource.gallery);

      if (image != null) {
        final url = await StorageService().uploadImage(
          File(image.path),
          'review_images',
        );

        final updatedImages = List<String>.from(images)..add(url);
        onImagesChanged(updatedImages);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to upload image: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 120,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: images.length + (images.length < maxImages ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == images.length) {
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: GestureDetector(
                onTap: () => _pickImage(context),
                child: Container(
                  width: 100,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.grey.shade400,
                      width: 1,
                    ),
                  ),
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.add_photo_alternate,
                        size: 32,
                        color: Colors.grey,
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Add',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }

          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    images[index],
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  top: 4,
                  right: 4,
                  child: GestureDetector(
                    onTap: () {
                      final updatedImages = List<String>.from(images)
                        ..removeAt(index);
                      onImagesChanged(updatedImages);
                    },
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.6),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.close,
                        size: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}