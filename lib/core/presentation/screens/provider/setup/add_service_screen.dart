import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../../../../models/category_model.dart';
import '../../../../models/service_model.dart';
import '../../../../services/auth_service.dart';
import '../../../../services/provider_service.dart';
import '../../../widgets/custom_text_field.dart';
import 'widgets/service_image_picker.dart';
import 'service_success_screen.dart';

class AddServiceScreen extends StatefulWidget {
  const AddServiceScreen({Key? key}) : super(key: key);

  @override
  State<AddServiceScreen> createState() => _AddServiceScreenState();
}

class _AddServiceScreenState extends State<AddServiceScreen> {
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

        final providerId =  AuthService().currentUser!.uid;
        final title = _titleController.text;
        final description = _descriptionController.text;
        final price = double.parse(_priceController.text);
        final category = _selectedCategory!;
        final images = _selectedImages;
        final location = _useCurrentLocation ? await _getCurrentLocation() : GeoPoint(0, 0);
        final createdAt = DateTime.now();

      final serviceId = await ProviderService().createService(
          providerId: providerId,
          title: title,
          description: description,
          images: images,
          price: price,
          category: category,
          location: location
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
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add a Task'),
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
                const SizedBox(width: 16),
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
              //enabled: !_useCurrentLocation,
              validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
            ),
            CheckboxListTile(
              value: _useCurrentLocation,
              onChanged: (value) => setState(() => _useCurrentLocation = value!),
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
                  : const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}