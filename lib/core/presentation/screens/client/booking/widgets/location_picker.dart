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
          SnackBar(content: Text(e.toString())),
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
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 200,
          child: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: GoogleMap(
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
                ),
        ),
      ],
    );
  }
}