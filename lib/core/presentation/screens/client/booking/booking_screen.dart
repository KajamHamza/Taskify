import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../models/service_model.dart';
import '../../../../services/auth_service.dart';
import 'booking_confirmation_screen.dart';
import 'booking_controller.dart';
import 'widgets/booking_summary.dart';
import 'widgets/date_time_picker.dart';
import 'widgets/location_picker.dart';

class BookingScreen extends StatefulWidget {
  final ServiceModel service;

  const BookingScreen({
    Key? key,
    required this.service,
  }) : super(key: key);

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  final _bookingController = BookingController();
  final _authService = AuthService();

  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  GeoPoint? _selectedLocation;
  bool _isLoading = false;
  String _paymentMethod = 'online'; // Default payment method

  Future<void> _handleBooking() async {
    if (_selectedDate == null || _selectedTime == null || _selectedLocation == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final currentUserId = _authService.currentUser?.uid;
      if (currentUserId == null) {
        throw Exception('Please login to book a service');
      }

      final DateTime bookingDateTime = DateTime(
        _selectedDate!.year,
        _selectedDate!.month,
        _selectedDate!.day,
        _selectedTime!.hour,
        _selectedTime!.minute,
      );

      final bookingId = await _bookingController.createBooking(
        service: widget.service,
        clientId: currentUserId,
        bookingDateTime: bookingDateTime,
        location: _selectedLocation!,
        paymentMethod: _paymentMethod,
      );

      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => BookingConfirmationScreen(
              requestId: bookingId,
            ),
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
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Book Service',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Service Card
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        widget.service.images.first,
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.service.title,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '\$${widget.service.price}/hr',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.blue.shade700,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Date & Time Picker
            _buildSectionCard(
              child: DateTimePicker(
                selectedDate: _selectedDate,
                selectedTime: _selectedTime,
                onDateSelected: (date) => setState(() => _selectedDate = date),
                onTimeSelected: (time) => setState(() => _selectedTime = time),
              ),
            ),
            const SizedBox(height: 24),

            // Location Picker
            _buildSectionCard(
              child: LocationPicker(
                initialLocation: _selectedLocation,
                onLocationSelected: (location) => setState(() => _selectedLocation = location),
              ),
            ),
            const SizedBox(height: 24),

            // Payment Method Selector
            _buildSectionCard(
              child: _buildPaymentMethodSelector(),
            ),

            const SizedBox(height: 24),
            // Booking Summary
            _buildSectionCard(
                child: BookingSummary(
                  service: widget.service,
                  selectedDate: _selectedDate,
                  selectedTime: _selectedTime,
                  paymentMethod: _paymentMethod,
                )
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: FilledButton(
              onPressed: _isLoading ? null : _handleBooking,
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                backgroundColor: Colors.blue,
              ),
              child: _isLoading
                  ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                ),
              )
                  : Text(
                'Confirm Booking',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionCard({required Widget child}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: child,
      ),
    );
  }

  Widget _buildPaymentMethodSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select Payment Method',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildPaymentMethodCard(
                icon: Icons.credit_card,
                label: 'Pay Online',
                isSelected: _paymentMethod == 'online',
                onTap: () {
                  setState(() {
                    _paymentMethod = 'online';
                  });
                },
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildPaymentMethodCard(
                icon: Icons.money,
                label: 'Pay in Cash',
                isSelected: _paymentMethod == 'cash',
                onTap: () {
                  setState(() {
                    _paymentMethod = 'cash';
                  });
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPaymentMethodCard({
    required IconData icon,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue.shade100 : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? Colors.blue.shade700 : Colors.grey.shade300,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 6,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Icon(
                icon,
                size: 32,
                color: isSelected ? Colors.blue.shade700 : Colors.grey.shade700,
              ),
              const SizedBox(height: 8),
              Text(
                label,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: isSelected ? Colors.blue.shade700 : Colors.grey.shade700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}