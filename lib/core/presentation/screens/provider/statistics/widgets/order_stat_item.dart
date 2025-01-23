import 'package:flutter/material.dart';

class OrderStatItem extends StatelessWidget {
  final String label;
  final String value;
  final Color? textColor;

  const OrderStatItem({
    Key? key,
    required this.label,
    required this.value,
    this.textColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Colors.black87,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: textColor ?? Colors.black87,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}