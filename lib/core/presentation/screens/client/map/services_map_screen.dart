import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'controllers/map_controller.dart';
import 'widgets/location_search_bar.dart';
import 'widgets/service_preview_card.dart';

class MapScreen extends StatelessWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => MapController()..getCurrentLocation(),
      child: const _MapScreenContent(),
    );
  }
}

class _MapScreenContent extends StatelessWidget {
  const _MapScreenContent();

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<MapController>();

    return Scaffold(
      body: Stack(
        children: [
          // Google Map with Rounded Corners
          if (controller.currentLocation != null)
            ClipRRect(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
              child: GoogleMap(
                key: ValueKey(controller.markers.length), // Rebuild when markers change
                initialCameraPosition: CameraPosition(
                  target: controller.currentLocation!,
                  zoom: 14,
                ),
                markers: controller.markers,
                myLocationEnabled: true,
                myLocationButtonEnabled: false,
                mapType: MapType.normal,
                zoomControlsEnabled: false,
                onTap: (_) {
                  // Clear the selected service when tapping on the map
                  controller.clearSelectedService();
                },
              ),
            )
          else
            const Center(child: CircularProgressIndicator()),
          // Top Content
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title and Subtitle
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Map',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Where does the task start?',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ),
                // Search Bar
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: LocationSearchBar(
                    onSearch: (query) {},
                    currentRadius: 5.0,
                  ),
                ),
                const SizedBox(height: 16),
                // Current Location Label
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    'Your current location',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.black54,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Service Preview Card
          if (controller.selectedService != null)
            Positioned(
              bottom: 80, // Adjusted to avoid overlapping with the navigation bar
              left: 16,
              right: 16,
              child: ServicePreviewCard(service: controller.selectedService!),
            ),
        ],
      ),
    );
  }
}