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
          if (controller.currentLocation != null)
            GoogleMap(
              initialCameraPosition: CameraPosition(
                target: controller.currentLocation!,
                zoom: 14,
              ),
              markers: controller.markers,
              myLocationEnabled: true,
              myLocationButtonEnabled: false,
              mapType: MapType.normal,
              zoomControlsEnabled: false,
              onTap: (markerId) {
                final service = controller.nearbyServices.firstWhere(
                      (s) => s.id == markerId,
                );
                showModalBottomSheet(
                  context: context,
                  builder: (_) => ServicePreviewCard(service: service),
                );
              },
            )
          else
            const Center(child: CircularProgressIndicator()),
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    'Map',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    'Where does the task start?',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                LocationSearchBar(
                  onSearch: (query) {},
                  currentRadius: 5.0,
                ),
                const Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    'Your current location',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}