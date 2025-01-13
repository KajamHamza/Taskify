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
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Add Photos',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 100,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: images.length + (images.length < maxImages ? 1 : 0),
            itemBuilder: (context, index) {
              if (index == images.length) {
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: InkWell(
                    onTap: () => _pickImage(context),
                    child: Container(
                      width: 100,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.add_photo_alternate),
                    ),
                  ),
                );
              }

              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
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
                      child: IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () {
                          final updatedImages = List<String>.from(images)
                            ..removeAt(index);
                          onImagesChanged(updatedImages);
                        },
                        style: IconButton.styleFrom(
                          backgroundColor: Colors.black54,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}