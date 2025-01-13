import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../../services/storage_service.dart';


class ServiceImagePicker extends StatelessWidget {
  final List<String> images;
  final Function(List<String>) onImagesChanged;
  final int maxImages;

  const ServiceImagePicker({
    Key? key,
    required this.images,
    required this.onImagesChanged,
    this.maxImages = 5,
  }) : super(key: key);

  Future<void> _pickImage(BuildContext context) async {
  try {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null && image.path.isNotEmpty) {
      final url = await StorageService().uploadImage(
        File(image.path),
        'service_images',
      );

      final updatedImages = List<String>.from(images)..add(url);
      onImagesChanged(updatedImages);
    }
  } on IOException catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Failed to pick image: ${e.toString()}')),
    );
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('An unexpected error occurred: ${e.toString()}')),
    );
  }
}

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.blue,
          style: BorderStyle.none,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          if (images.isEmpty)
            InkWell(
              onTap: () => _pickImage(context),
              child: const Column(
                children: [
                  Icon(Icons.add_photo_alternate, size: 48, color: Colors.blue),
                  SizedBox(height: 8),
                  Text('Upload pictures'),
                ],
              ),
            )
          else
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ...images.map((url) => _ImageTile(
                  url: url,
                  onDelete: () {
                    final updatedImages = List<String>.from(images)
                      ..remove(url);
                    onImagesChanged(updatedImages);
                  },
                )),
                if (images.length < maxImages)
                  InkWell(
                    onTap: () => _pickImage(context),
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.add_photo_alternate),
                    ),
                  ),
              ],
            ),
        ],
      ),
    );
  }
}

class _ImageTile extends StatelessWidget {
  final String url;
  final VoidCallback onDelete;

  const _ImageTile({
    required this.url,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(
            url,
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
            onPressed: onDelete,
            style: IconButton.styleFrom(
              backgroundColor: Colors.black54,
              foregroundColor: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}