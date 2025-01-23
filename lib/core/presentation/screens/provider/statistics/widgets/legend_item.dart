import 'package:flutter/material.dart';

class LegendItem extends StatelessWidget {
  final Color color;
  final String label;
  final bool isLight;
  final bool isLighter;

  const LegendItem({
    Key? key,
    required this.color,
    required this.label,
    this.isLight = false,
    this.isLighter = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isLighter
                ? color.withOpacity(0.3)
                : isLight
                ? color.withOpacity(0.6)
                : color,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
}