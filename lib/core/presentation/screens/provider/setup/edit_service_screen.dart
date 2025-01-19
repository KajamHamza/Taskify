import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import '../../../../models/category_model.dart';
import '../../../../models/service_model.dart';
import '../../../../services/auth_service.dart';
import '../../../../services/provider_service.dart';
import '../../../widgets/custom_text_field.dart';
import 'widgets/service_image_picker.dart';
import 'service_success_screen.dart';

class EditServiceScreen extends StatefulWidget {
  final ServiceModel service;

  const EditServiceScreen({Key? key, required this.service}) : super(key: key);

  @override
  State<EditServiceScreen> createState() => _EditServiceScreen();
}

class _EditServiceScreen extends State<EditServiceScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _addressController = TextEditingController();

  List<String> _selectedImages = [];
  bool _useCurrentLocation = false;
  bool _acceptedTerms = false;
  bool _isLoading = false;
  List<CategoryModel> _categories = [];
  CategoryModel? _selectedCategory;

  @override
  void initState() {
    super.initState();
    _titleController.text = widget.service.title;
    _descriptionController.text = widget.service.description;
    _priceController.text = widget.service.price.toString();
    _addressController.text = widget.service.location.toString();
    _selectedImages = widget.service.images;
    _selectedCategory = widget.service.category;

    log('Service Category: ${widget.service.category}');
    log('Selected Category: $_selectedCategory');

    _fetchCategories();
  }

  Future<void> _fetchCategories() async {
    _categories = await ProviderService().getCategories();
    _categories = _categories.toSet().toList(); // Remove duplicates

    log('Fetched Categories: $_categories');
    log('Initial Selected Category: $_selectedCategory');

    // Match the _selectedCategory with the fetched categories
    if (_selectedCategory != null) {
      _selectedCategory = _categories.firstWhere(
            (category) => category.id == _selectedCategory!.id,
        orElse: () => _selectedCategory!, // Fallback to the original if not found
      );
    }

    // Check for invalid _selectedCategory
    if (_selectedCategory != null && _selectedCategory!.id.isEmpty) {
      _selectedCategory = null; // Reset to null if invalid
    }

    log('Updated Selected Category: $_selectedCategory');
    setState(() {});
  }


  Future<GeoPoint> _getLocationFromAddress(String address) async {
    // Implement the logic to convert address to GeoPoint
    // This might involve using a geocoding API
    // For example, using the Geocoding package
    List<Location> locations = await locationFromAddress(address);
    if (locations.isNotEmpty) {
      return GeoPoint(locations.first.latitude, locations.first.longitude);
    } else {
      throw Exception('Address not found');
    }
  }

  Future<GeoPoint> _getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    return GeoPoint(position.latitude, position.longitude);
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedImages.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please add at least one image')),
      );
      return;
    }
    if (!_acceptedTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please accept the terms and conditions')),
      );
      return;
    }

    setState(() => _isLoading = true);
    if (_categories.isEmpty) {
      _categories = await ProviderService().getCategories();
    }

    try {
      final providerId = AuthService().currentUser!.uid;
      final title = _titleController.text;
      final description = _descriptionController.text;
      final price = double.parse(_priceController.text);
      final category = _selectedCategory!;
      final images = _selectedImages;
      final location = _useCurrentLocation
          ? await _getCurrentLocation()
          : await _getLocationFromAddress(_addressController.text);
      final createdAt = DateTime.now();

      final serviceId = await ProviderService().updateService(
        serviceId: widget.service.id,
        title: title,
        description: description,
        images: images,
        price: price,
        category: category,
        location: location,
      );

      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => ServiceSuccessScreen(serviceId: serviceId),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit a Task'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            CustomTextField(
              label: 'Task Title',
              controller: _titleController,
              validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
            ),
            const SizedBox(height: 16),
            CustomTextField(
              label: 'Description',
              controller: _descriptionController,
              validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<CategoryModel>(
                    decoration: InputDecoration(labelText: 'Category'),
                    value: _selectedCategory,
                    items: _categories.map((category) {
                      return DropdownMenuItem<CategoryModel>(
                        value: category,
                        child: Text(category.name),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedCategory = value;
                      });
                    },
                    validator: (value) => value == null ? 'Required' : null,
                  ),
                ),
                const SizedBox(width: 18),
                Expanded(
                  child: CustomTextField(
                    label: 'Price',
                    controller: _priceController,
                    keyboardType: TextInputType.number,
                    prefix: const Text('\$'),
                    validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            CustomTextField(
              label: 'Address',
              controller: _addressController,
              validator: (value) => _useCurrentLocation ? null : (value?.isEmpty ?? true ? 'Required' : null),
            ),
            CheckboxListTile(
              value: _useCurrentLocation,
              onChanged: (value) {
                setState(() {
                  _useCurrentLocation = value!;
                  if (_useCurrentLocation) {
                    _addressController.clear();
                  }
                });
              },
              title: const Text('Use the same location'),
              controlAffinity: ListTileControlAffinity.leading,
              contentPadding: EdgeInsets.zero,
            ),
            const SizedBox(height: 16),
            ServiceImagePicker(
              images: _selectedImages,
              onImagesChanged: (images) => setState(() => _selectedImages = images),
            ),
            const SizedBox(height: 24),
            CheckboxListTile(
              value: _acceptedTerms,
              onChanged: (value) => setState(() => _acceptedTerms = value!),
              title: const Text('I agree to the terms and conditions'),
              controlAffinity: ListTileControlAffinity.leading,
              contentPadding: EdgeInsets.zero,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _isLoading ? null : _handleSubmit,
              child: _isLoading
                  ? const CircularProgressIndicator()
                  : const Text('Edit'),
            ),
          ],
        ),
      ),
    );
  }
}