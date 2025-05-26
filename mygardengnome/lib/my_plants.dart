import 'package:flutter/material.dart';
import 'package:mygardengnome/background.dart';

class MyPlantsScreen extends StatelessWidget {
  const MyPlantsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BackgroundScaffold(
      title: 'My Plants',
      child: Column(
        children: [
          const SizedBox(height: 30),
          Expanded(
            child: Center(
              child: Text(
                'Your saved plants will appear here.',
                style: TextStyle(fontSize: 18, color: Colors.black54),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }
}