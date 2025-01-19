import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../../../services/location_service.dart';
import '../../../../../models/service_model.dart';

class MapController extends ChangeNotifier {
  final LocationService _locationService = LocationService();
  LatLng? currentLocation;
  Set<Marker> markers = {};
  List<ServiceModel> nearbyServices = [];
  final Map<MarkerId, ServiceModel> markerToServiceMap = {}; // Map MarkerId to ServiceModel
  ServiceModel? selectedService; // Track the selected service
  bool isLoading = false;

  Future<void> getCurrentLocation() async {
    isLoading = true;
    notifyListeners();

    try {
      final position = await _locationService.getCurrentLocation();
      currentLocation = LatLng(position.latitude, position.longitude);
      log('Current Location: $currentLocation'); // Debug print
      await loadNearbyServices();
    } catch (e) {
      log('Error getting location: $e');
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

      log('Number of Services: ${services.length}'); // Debug print

      markers = services.map((service) {
        final location = service['location'] as GeoPoint; // Cast to GeoPoint
        final markerId = MarkerId(service['id']);

        log('Marker Position: ${location.latitude}, ${location.longitude}'); // Debug print

        // Add the service to the markerToServiceMap
        markerToServiceMap[markerId] = ServiceModel.fromMap(service);

        return Marker(
          markerId: markerId,
          position: LatLng(
              location.latitude,
              location.longitude
          ), // Access latitude and longitude directly
          infoWindow: InfoWindow(
            title: service['title'],
            snippet: '${service['price']}\$',
          ),
          onTap: () {
            // Set the selected service when the marker is tapped
            selectedService = markerToServiceMap[markerId];
            notifyListeners(); // Notify listeners to update the UI
          },
        );
      }).toSet();

      log('Number of Markers: ${markers.length}'); // Debug print

      // Update the nearby services list
      nearbyServices = services.map((service) => ServiceModel.fromMap(service)).toList();
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading services: $e');
    }
  }

  // Clear the selected service (optional)
  void clearSelectedService() {
    selectedService = null;
    notifyListeners();
  }
}