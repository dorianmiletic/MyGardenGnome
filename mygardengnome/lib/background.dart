import 'package:flutter/material.dart';

class BackgroundScaffold extends StatelessWidget {
  final String title;
  final Widget child;

  const BackgroundScaffold({
    Key? key,
    required this.title,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Positioned.fill(
            child: Image.asset(
              'assets/images/background.jpg',
              fit: BoxFit.cover,
            ),
          ),
          // Title and gnome image
          Positioned(
            top: 50,
            left: 0,
            right: 0,
            child: Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Image.asset(
                    'assets/images/gnome.jpg',
                    width: 40,
                    height: 40,
                  ),
                ],
              ),
            ),
          ),
          // Main content
          Positioned.fill(
            top: 120, // leave space for header
            child: child,
          ),
        ],
      ),
    );
  }
}