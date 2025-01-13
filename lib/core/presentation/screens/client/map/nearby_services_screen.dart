import 'package:Taskify/core/presentation/screens/client/map/widgets/service_preview_card.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../../models/service_model.dart';
import '../../../../services/location_service.dart';
import 'widgets/service_preview_card.dart';
import 'widgets/location_search_bar.dart';

class NearbyServicesScreen extends StatefulWidget {
  const NearbyServicesScreen({Key? key}) : super(key: key);

  @override
  State<NearbyServicesScreen> createState() => _NearbyServicesScreenState();
}

class _NearbyServicesScreenState extends State<NearbyServicesScreen> {
  final LocationService _locationService = LocationService();
  GoogleMapController? _mapController;
  Set<Marker> _markers = {};
  LatLng? _currentLocation;
  String _selectedCategory = 'All';
  String _searchQuery = '';
  bool _isLoading = false;
  double _searchRadius = 5.0; // 5km default radius

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
        _currentLocation = LatLng(position.latitude, position.longitude);
      });
      await _loadNearbyServices();

      // Animate camera to current location
      _mapController?.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: _currentLocation!,
            zoom: 14,
          ),
        ),
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

  Future<void> _loadNearbyServices() async {
    if (_currentLocation == null) return;

    try {
      final services = await _locationService.getNearbyServices(
        _currentLocation!,
        _searchRadius,
      );

      setState(() {
        _markers = services.map((service) {
          return Marker(
            markerId: MarkerId(service['id']),
            position: LatLng(
              service['location']['latitude'],
              service['location']['longitude'],
            ),
            infoWindow: InfoWindow(
              title: service['title'],
              snippet: '\$${service['price']}',
            ),
            onTap: () => _showServiceDetails(service as ServiceModel),
          );
        }).toSet();
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
    }
  }

  void _showServiceDetails(ServiceModel service) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ServicePreviewCard(service: service),
    );
  }

  void _onSearch(String query) {
    setState(() => _searchQuery = query);
    _loadNearbyServices();
  }

  void _onCategoryChanged(String category) {
    setState(() => _selectedCategory = category);
    _loadNearbyServices();
  }

  void _onRadiusChanged(double radius) {
    setState(() => _searchRadius = radius);
    _loadNearbyServices();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          if (_currentLocation != null)
            GoogleMap(
              initialCameraPosition: CameraPosition(
                target: _currentLocation!,
                zoom: 14,
              ),
              onMapCreated: (controller) => _mapController = controller,
              markers: _markers,
              myLocationEnabled: true,
              myLocationButtonEnabled: false,
              zoomControlsEnabled: false,
            )
          else
            const Center(child: CircularProgressIndicator()),
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: LocationSearchBar(
                    onSearch: _onSearch,
                    currentRadius: _searchRadius,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _getCurrentLocation,
        child: const Icon(Icons.my_location),
      ),
    );
  }
}