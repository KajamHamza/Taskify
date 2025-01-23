import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../../services/location_service.dart';

class LocationPicker extends StatefulWidget {
  final GeoPoint? initialLocation;
  final Function(GeoPoint) onLocationSelected;

  const LocationPicker({
    Key? key,
    this.initialLocation,
    required this.onLocationSelected,
  }) : super(key: key);

  @override
  State<LocationPicker> createState() => _LocationPickerState();
}

class _LocationPickerState extends State<LocationPicker> {
  final LocationService _locationService = LocationService();
  GoogleMapController? _mapController;
  LatLng? _selectedLocation;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    setState(() => _isLoading = true);
    try {
      final position = await _locationService.getCurrentLocation();
      setState(() {
        _selectedLocation = LatLng(
          position.latitude,
          position.longitude,
        );
      });
      _mapController?.animateCamera(
        CameraUpdate.newLatLngZoom(_selectedLocation!, 15),
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to get location: ${e.toString()}')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select Location',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          height: 200,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 6,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Stack(
              children: [
                GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: _selectedLocation ?? const LatLng(0, 0),
                    zoom: 15,
                  ),
                  onMapCreated: (controller) => _mapController = controller,
                  markers: _selectedLocation != null
                      ? {
                    Marker(
                      markerId: const MarkerId('selected'),
                      position: _selectedLocation!,
                    ),
                  }
                      : {},
                  onTap: (location) {
                    setState(() => _selectedLocation = location);
                    widget.onLocationSelected(GeoPoint(
                      location.latitude,
                      location.longitude,
                    ));
                  },
                ),
                if (_isLoading)
                  const Center(child: CircularProgressIndicator()),
                Positioned(
                  bottom: 16,
                  right: 16,
                  child: FloatingActionButton(
                    onPressed: _getCurrentLocation,
                    backgroundColor: Colors.blue.shade100,
                    child: Icon(
                      Icons.my_location,
                      color: Colors.blue.shade900,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}