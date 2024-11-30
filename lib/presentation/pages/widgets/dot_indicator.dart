import 'package:flutter/material.dart';

class DotIndicator extends StatelessWidget {
  final bool isActive;

  const DotIndicator({
    Key? key,
    required this.isActive,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 4, // Reduced height for a more rectangular look
      width: isActive ? 20 : 10, // Adjusted width for active and inactive states
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(2), // Smaller radius for more rectangular look
        color: isActive ? const Color(0xFF0080FF) : Colors.grey.shade300,
      ),
    );
  }
}