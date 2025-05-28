import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart'; // auto-generirano s flutterfire configure
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'weather_service.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  WidgetsFlutterBinding.ensureInitialized();
  // Inicijaliziraj notifikacije i zatraži dozvolu
  await WeatherService.initNotifications();
   
  await WeatherService.requestPermission();

   FirebaseFirestore.instance.collection('test').add({'ping': 'pong'}).then(
    (docRef) => print("Firestore test OK: ${docRef.id}"),
  ).catchError((e) => print("❌ Firestore test error: $e"));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MyGardenGnome',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomeScreen(),
    );
  }
}