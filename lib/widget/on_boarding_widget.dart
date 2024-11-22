import 'package:flutter/material.dart';

class OnboardingWidget extends StatelessWidget {
  final String title;
  final String description;
  final String imagePath;

  const OnboardingWidget({
    super.key,
    required this.title,
    required this.description,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // Background image
        Image.asset(
          imagePath,
          fit: BoxFit.cover, // Ensure the image covers the whole screen
        ),
        // Content on top of the background image
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 380.0),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 28.0,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF6563A5),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10.0),
              Text(
                description,
                style: const TextStyle(
                  fontSize: 18.0,
                  color: Color(0xFF6563A5), // White text for better contrast
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
