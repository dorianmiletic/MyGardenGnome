import 'package:flutter/material.dart';
import 'package:mygardengnome/background.dart';
import 'package:mygardengnome/models/plant.dart';



class PlantInfoScreen extends StatelessWidget {
  final Plant plant;

  const PlantInfoScreen({Key? key, required this.plant}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BackgroundScaffold(
      title: plant.commonName,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (plant.imageUrl.isNotEmpty)
              Image.network(
                plant.imageUrl,
                height: 250,
                fit: BoxFit.cover,
              )
            else
              const Icon(Icons.local_florist, size: 150, color: Colors.grey),
            const SizedBox(height: 20),
            Text(
              plant.commonName,
              style: const TextStyle(
                  fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              plant.scientificName,
              style: const TextStyle(
                  fontSize: 20, fontStyle: FontStyle.italic, color: Colors.black54),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),

            // TODO: Ovdje možeš dodati više detalja iz API-ja, npr. family, genus, description...

            const Text(
              'More details coming soon...',
              style: TextStyle(fontSize: 16, color: Colors.black54),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}