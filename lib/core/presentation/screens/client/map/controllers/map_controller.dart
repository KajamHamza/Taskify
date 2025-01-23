import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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

  ServiceModel? get service => selectedService;

  Future<void> getCurrentLocation() async {
    isLoading = true;
    notifyListeners();

    try {
      final position = await _locationService.getCurrentLocation();
      currentLocation = LatLng(position.latitude, position.longitude);
      await loadNearbyServices();
    } catch (e) {
      debugPrint('Error getting current location: $e');
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

      // Load custom bubble marker icons
      final BitmapDescriptor bubbleIcon = await _createBubbleIcon('${services.first['title']}' , 10);

      markers = services.map((service) {
        final location = service['location'] as GeoPoint; // Cast to GeoPoint
        final markerId = MarkerId(service['id']);

        // Add the service to the markerToServiceMap
        markerToServiceMap[markerId] = ServiceModel.fromMap(service);

        return Marker(
          markerId: markerId,
          position: LatLng(
              location.latitude,
              location.longitude
          ), // Access latitude and longitude directly
          icon: bubbleIcon, // Use custom bubble icon
          onTap: () {
            // Set the selected service when the marker is tapped
            selectedService = markerToServiceMap[markerId];
            notifyListeners(); // Notify listeners to update the UI
          },
        );
      }).toSet();
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

  // Helper method to create a custom bubble marker icon
  Future<BitmapDescriptor> _createBubbleIcon(String text, double zoomLevel) async {
    double bubbleRadius = 40.0 + (zoomLevel * 5); // Adjust size based on zoom level
    double textSize = 20.0 + (zoomLevel * 2); // Adjust text size based on zoom level

    final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);

    final Paint bubblePaint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.fill;

    canvas.drawCircle(
      Offset(bubbleRadius, bubbleRadius),
      bubbleRadius,
      bubblePaint,
    );

    final TextPainter textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          color: Colors.white,
          fontSize: textSize,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    );

    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(
        bubbleRadius - textPainter.width / 2,
        bubbleRadius - textPainter.height / 2,
      ),
    );

    final ui.Image image = await pictureRecorder.endRecording().toImage(
      (bubbleRadius * 2).toInt(),
      (bubbleRadius * 2).toInt(),
    );

    final ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    if (byteData == null) {
      throw Exception('Failed to create bubble icon');
    }

    return BitmapDescriptor.fromBytes(byteData.buffer.asUint8List());
  }
}