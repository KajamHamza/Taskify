import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ServiceImageCarousel extends StatefulWidget {
  final List<String> images;

  const ServiceImageCarousel({
    Key? key,
    required this.images,
  }) : super(key: key);

  @override
  State<ServiceImageCarousel> createState() => _ServiceImageCarouselState();
}

class _ServiceImageCarouselState extends State<ServiceImageCarousel> {
  int _currentIndex = 0;
  final PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Image Carousel
        PageView.builder(
          controller: _pageController,
          itemCount: widget.images.length,
          onPageChanged: (index) => setState(() => _currentIndex = index),
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                // Open the image in a full-screen dialog
                showDialog(
                  context: context,
                  builder: (context) => Dialog(
                    insetPadding: const EdgeInsets.all(16),
                    child: InteractiveViewer(
                      panEnabled: true,
                      minScale: 0.5,
                      maxScale: 3,
                      child: CachedNetworkImage(
                        imageUrl: widget.images[index],
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                );
              },
              child: Hero(
                tag: widget.images[index],
                child: CachedNetworkImage(
                  imageUrl: widget.images[index],
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    color: Colors.grey[200],
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
                  errorWidget: (context, url, error) => Container(
                    color: Colors.grey[200],
                    child: const Icon(
                      Icons.error,
                      color: Colors.red,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
        // Gradient Overlay for Indicators
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            height: 80,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [
                  Colors.black.withOpacity(0.7),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),
        // Image Indicators
        Positioned(
          bottom: 16,
          left: 0,
          right: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: widget.images.asMap().entries.map((entry) {
              return GestureDetector(
                onTap: () => _pageController.animateToPage(
                  entry.key,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                ),
                child: Container(
                  width: 10,
                  height: 10,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _currentIndex == entry.key
                        ? Colors.white
                        : Colors.white.withOpacity(0.5),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}