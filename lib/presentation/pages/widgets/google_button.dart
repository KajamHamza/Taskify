import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';  // Import the flutter_svg package

class GoogleButton extends StatelessWidget {
  const GoogleButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: OutlinedButton(
        onPressed: () {
          // Handle Google sign in
        },
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: Colors.grey),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisSize: MainAxisSize.min, // Ensures the Row takes up only necessary space
            children: [
              // Use SvgPicture.asset to load the local SVG image
              SvgPicture.asset(
                'lib/assets/images/logo_google_g_icon.svg', // Path to your local SVG
                height: 24,
                width: 24,
              ),
              const SizedBox(width: 12),
              // Use Flexible instead of Expanded to allow some flexibility without forcing a max width
              Flexible(
                child: const Text(
                  'Log In with Google',
                  overflow: TextOverflow.ellipsis, // Truncate long text
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
