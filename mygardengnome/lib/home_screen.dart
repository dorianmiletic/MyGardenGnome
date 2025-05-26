import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mygardengnome/my_plants.dart';
import 'package:mygardengnome/search_plants.dart';
import 'package:mygardengnome/login_screen.dart';
import 'package:mygardengnome/register_screen.dart';
import 'package:mygardengnome/add_plant.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image
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
            child: Column(
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'MyGardenGnome',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(width: 10),
                    Image.asset(
                      'assets/images/gnome.jpg',
                      width: 40,
                      height: 40,
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const LoginScreen()),
                        );
                      },
                      child: Text('Login'),
                    ),
                    SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const RegisterScreen()),
                        );
                      },
                      child: Text('Register'),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Button 1 - Search
          Positioned(
            top: 200,
            left: 20,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => SearchPlantsScreen()),
                );
              },
              child: Row(
                children: [
                  Icon(Icons.search, color: Colors.red),
                  SizedBox(width: 8),
                  Text('Search for plants', style: TextStyle(color: Colors.black)),
                ],
              ),
            ),
          ),

          // Button 2 - My Plants
          Positioned(
            top: 200,
            right: 20,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => MyPlantsScreen()),
                );
              },
              child: Row(
                children: [
                  Image.asset(
                    'assets/images/flower.jpg',
                    width: 24,
                    height: 24,
                    color: Colors.purple,
                  ),
                  SizedBox(width: 8),
                  Text('My plants', style: TextStyle(color: Colors.black)),
                ],
              ),
            ),
          ),

          // Button 3 - Add Plant
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => AddPlantScreen()),
                );
              },
              child: Row(
                children: [
                  Icon(Icons.add, color: Colors.blue),
                  SizedBox(width: 8),
                  Text('Add your plant', style: TextStyle(color: Colors.black)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
