import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../../../services/location_service.dart';
import '../../../../../models/service_model.dart';

class MapController extends ChangeNotifier {
  final LocationService _locationService = LocationService();
  LatLng? currentLocation;
  Set<Marker> markers = {};
  List<ServiceModel> nearbyServices = [];
  bool isLoading = false;

  Future<void> getCurrentLocation() async {
    isLoading = true;
    notifyListeners();

    try {
      final position = await _locationService.getCurrentLocation();
      currentLocation = LatLng(position.latitude, position.longitude);
      await loadNearbyServices();
    } catch (e) {
      debugPrint('Error getting location: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadNearbyServices() async {
    if (currentLocation == null) return;

    try {
      final services = await _locationService.getNearbyServices(
        currentLocation!,
        5.0, // 5km radius
      );

      markers = services.map((service) {
        return Marker(
          markerId: MarkerId(service['id']),
          position: LatLng(
            service['location']['latitude'],
            service['location']['longitude'],
          ),
          infoWindow: InfoWindow(
            title: service['title'],
            snippet: '${service['price']}\$',
          ),
        );
      }).toSet();

      nearbyServices = services.map((service) => ServiceModel.fromMap(service)).toList();
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading services: $e');
    }
  }
}