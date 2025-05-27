import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class BackgroundScaffold extends StatelessWidget {
  final String title;
  final Widget child;
  final bool showUserName;

  const BackgroundScaffold({
    Key? key,
    required this.title,
    required this.child,
    this.showUserName = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final displayName = user?.displayName ?? user?.email ?? '';

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/images/background.jpg', // ili tvoja pozadina
            fit: BoxFit.cover,
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  if (showUserName && displayName.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: Text(
                        'Logged in as: $displayName',
                        style: const TextStyle(color: Colors.white70, fontSize: 14),
                      ),
                    ),
                  const SizedBox(height: 20),
                  Expanded(child: child),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}