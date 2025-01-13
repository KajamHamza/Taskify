import 'dart:math';

import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LocationService {
  Future<Position> getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Location services are disabled.');
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Location permissions are denied.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception('Location permissions are permanently denied.');
    }

    return await Geolocator.getCurrentPosition();
  }

  Future<List<Map<String, dynamic>>> getNearbyServices(
    LatLng center,
    double radiusInKm,
  ) async {
    try {
      // Convert LatLng to GeoPoint for Firestore
      GeoPoint centerPoint = GeoPoint(center.latitude, center.longitude);

      // Calculate the rough bounding box for the query
      double lat = center.latitude;
      double lon = center.longitude;
      double latChange = radiusInKm / 111.32; // 1 degree = 111.32 km
      double lonChange = radiusInKm / (111.32 * cos(lat * pi / 180));

      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('services')
          .where('location',
              isGreaterThan: GeoPoint(lat - latChange, lon - lonChange))
          .where('location',
              isLessThan: GeoPoint(lat + latChange, lon + lonChange))
          .get();

      List<Map<String, dynamic>> nearbyServices = [];

      for (var doc in snapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        GeoPoint location = data['location'];

        // Calculate actual distance
        double distance = Geolocator.distanceBetween(
          center.latitude,
          center.longitude,
          location.latitude,
          location.longitude,
        );

        // Only include if within actual radius
        if (distance <= radiusInKm * 1000) {
          nearbyServices.add({
            ...data,
            'id': doc.id,
            'distance': distance,
          });
        }
      }

      // Sort by distance
      nearbyServices.sort((a, b) => (a['distance'] as double)
          .compareTo(b['distance'] as double));

      return nearbyServices;
    } catch (e) {
      throw Exception('Failed to get nearby services: $e');
    }
  }

  double calculateDistance(GeoPoint point1, GeoPoint point2) {
    return Geolocator.distanceBetween(
      point1.latitude,
      point1.longitude,
      point2.latitude,
      point2.longitude,
    );
  }
}