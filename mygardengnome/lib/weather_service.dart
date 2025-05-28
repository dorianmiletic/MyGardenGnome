import 'dart:convert';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';

class WeatherService {
  static final _notifications = FlutterLocalNotificationsPlugin();
  static const _apiKey = '3a5d8f7058f98c866bb0cfe1dd159c95'; // <-- zamijeni sa svojim
  static const _baseUrl = 'https://api.openweathermap.org/data/2.5/weather';

  static Future<void> initNotifications() async {
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const settings = InitializationSettings(android: android);
    await _notifications.initialize(settings);
  }

  static Future<void> showNotification(String title, String body) async {
    const androidDetails = AndroidNotificationDetails(
      'weather_channel',
      'Weather Alerts',
      importance: Importance.max,
      priority: Priority.high,
    );
    const details = NotificationDetails(android: androidDetails);
    await _notifications.show(0, title, body, details);
  }

  static Future<void> checkRainAndNotify() async {
    try {
      final position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      final url =
          '$_baseUrl?lat=${position.latitude}&lon=${position.longitude}&appid=$_apiKey&units=metric';
      final response = await http.get(Uri.parse(url));
      final data = json.decode(response.body);

      final weatherList = data['weather'] as List;
      final description = weatherList.first['main'].toString().toLowerCase();

      if (description.contains('rain')) {
        await showNotification("Obavijest", "Danas će biti kiša, nemoj zalijevati 🌧️");
      }
    } catch (e) {
      print("Greška: $e");
    }
  }

  static Future<void> simulateRainNotification() async {
    await showNotification("Test Notifikacija", "Simulacija: Danas pada kiša 🌧️");
  }

  // Traženje dozvole preko permission_handler-a
  static Future<bool> requestPermission() async {
    final status = await Permission.notification.request();
    return status.isGranted;
  }
}
