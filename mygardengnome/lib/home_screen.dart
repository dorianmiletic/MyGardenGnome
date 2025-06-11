import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mygardengnome/my_plants.dart';
import 'package:mygardengnome/search_plants.dart';
import 'package:mygardengnome/login_screen.dart';
import 'package:mygardengnome/register_screen.dart';
import 'package:mygardengnome/add_plant.dart';
import 'package:mygardengnome/weather_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _weatherStatus = '';

  @override
  void initState() {
    super.initState();
    WeatherService.initNotifications();
    
  }

  

  Future<void> _simulateRain() async {
    try {
      await WeatherService.simulateRainNotification();
      setState(() {
        _weatherStatus = 'Test notifikacija poslana!';
      });
    } catch (e) {
      setState(() {
        _weatherStatus = 'Greška prilikom slanja test notifikacije: $e';
      });
    }
  }

  Future<void> _checkRain() async {
    try {
      await WeatherService.checkRainAndNotify();
      setState(() {
        _weatherStatus = 'Provjera vremena izvršena (ako pada kiša, dobit ćete notifikaciju)';
      });
    } catch (e) {
      setState(() {
        _weatherStatus = 'Greška prilikom provjere vremena: $e';
      });
    }
  }

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

          // Title, Gnome, and Auth Buttons or Welcome Text
          Positioned(
            top: 50,
            left: 0,
            right: 0,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'MyGardenGnome',
                      style: TextStyle(
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
                const SizedBox(height: 16),
                StreamBuilder<User?>(
                  stream: FirebaseAuth.instance.authStateChanges(),
                  builder: (context, snapshot) {
                    final user = snapshot.data;
                    if (user == null) {
                      // Only Login button shown if not logged in (no Register button)
                      return ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const LoginScreen()),
                          );
                        },
                        child: const Text('Login'),
                      );
                    } else {
                      return Text(
                        'Welcome, ${user.displayName ?? user.email ?? 'User'}!',
                        style: const TextStyle(
                          color: Colors.black87,
                          fontSize: 16,
                        ),
                      );
                    }
                  },
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
                  MaterialPageRoute(builder: (_) => const SearchPlantsScreen()),
                );
              },
              child: Row(
                children: const [
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
                  MaterialPageRoute(builder: (_) => const MyPlantsScreen()),
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
                  const SizedBox(width: 8),
                  const Text('My plants', style: TextStyle(color: Colors.black)),
                ],
              ),
            ),
          ),

          // Centered Test and Check buttons + status text
          Center(
  child: Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      ElevatedButton(
        onPressed: _simulateRain,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
        child: const Text(
          'Testiraj API (Simuliraj kišu)',
          style: TextStyle(color: Colors.black),
        ),
      ),
      const SizedBox(height: 12),
      ElevatedButton(
        onPressed: _checkRain,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
        child: const Text(
          'Provjeri kišu',
          style: TextStyle(color: Colors.black),
        ),
      ),
      const SizedBox(height: 20),
      if (_weatherStatus.isNotEmpty)
  Container(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    decoration: BoxDecoration(
      color: Colors.black.withOpacity(0.6),
      borderRadius: BorderRadius.circular(8),
    ),
    child: Text(
      _weatherStatus,
      style: const TextStyle(color: Colors.white, fontSize: 14),
      textAlign: TextAlign.center,
    ),
  ),
    ],
  ),
),

          // Bottom buttons - Add Plant and Logout (if logged in)
          Positioned(
            bottom: 60,
            left: 20,
            right: 20,
            child: StreamBuilder<User?>(
              stream: FirebaseAuth.instance.authStateChanges(),
              builder: (context, snapshot) {
                final user = snapshot.data;
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => const AddPlantScreen()),
                            );
                          },
                          child: Row(
                            children: const [
                              Icon(Icons.add, color: Colors.blue),
                              SizedBox(width: 8),
                              Text('Add your plant', style: TextStyle(color: Colors.black)),
                            ],
                          ),
                        ),
                        if (user != null)
                          ElevatedButton(
                            onPressed: () async {
                              await FirebaseAuth.instance.signOut();
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Logged out')),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red[700],
                            ),
                            child: const Text('Logout'),
                          ),
                      ],
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
