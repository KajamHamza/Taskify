import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateTimePicker extends StatelessWidget {
  final DateTime? selectedDate;
  final TimeOfDay? selectedTime;
  final Function(DateTime) onDateSelected;
  final Function(TimeOfDay) onTimeSelected;

  const DateTimePicker({
    Key? key,
    this.selectedDate,
    this.selectedTime,
    required this.onDateSelected,
    required this.onTimeSelected,
  }) : super(key: key);

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 30)),
    );
    if (picked != null) {
      onDateSelected(picked);
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime ?? TimeOfDay.now(),
    );
    if (picked != null) {
      onTimeSelected(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select Date & Time',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildDateTimeButton(
                icon: Icons.calendar_today,
                label: selectedDate != null
                    ? DateFormat('MMM dd, yyyy').format(selectedDate!)
                    : 'Select Date',
                onPressed: () => _selectDate(context),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildDateTimeButton(
                icon: Icons.access_time,
                label: selectedTime != null
                    ? selectedTime!.format(context)
                    : 'Select Time',
                onPressed: () => _selectTime(context),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDateTimeButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onPressed,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  size: 20,
                  color: Colors.blue.shade700,
                ),
                const SizedBox(width: 8),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}