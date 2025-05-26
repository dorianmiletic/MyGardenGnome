import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mygardengnome/background.dart';
import 'package:mygardengnome/models/plant.dart';
import 'package:mygardengnome/plants_info.dart';

class SearchPlantsScreen extends StatefulWidget {
  const SearchPlantsScreen({Key? key}) : super(key: key);

  @override
  State<SearchPlantsScreen> createState() => _SearchPlantsScreenState();
}

class _SearchPlantsScreenState extends State<SearchPlantsScreen> {
  final String apiKey = '1xO1vrAtD19b-ZVsPXxvJ1J6Ow5bqWx5MH7C8btzGGM';
  List<Plant> plants = [];
  bool isLoading = false;
  String errorMessage = '';
  String query = '';

  Future<void> fetchPlants(String query) async {
    if (query.isEmpty) {
      setState(() {
        plants = [];
        errorMessage = '';
      });
      return;
    }
    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    try {
      final url = Uri.parse(
          'https://trefle.io/api/v1/plants?token=$apiKey&q=$query');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(response.body);
        final List<dynamic> data = jsonData['data'];

        List<Plant> allPlants = data.map((json) => Plant.fromJson(json)).toList();

        // Lokalno filtriranje po imenu (commonName ili scientificName)
        final lowerQuery = query.toLowerCase();
        List<Plant> filteredPlants = allPlants.where((plant) {
          final common = plant.commonName?.toLowerCase() ?? '';
          final scientific = plant.scientificName?.toLowerCase() ?? '';
          return common.contains(lowerQuery) || scientific.contains(lowerQuery);
        }).toList();

        setState(() {
          plants = filteredPlants;
          isLoading = false;
          if (plants.isEmpty) {
            errorMessage = 'No plants found for "$query".';
          }
        });
      } else {
        setState(() {
          errorMessage = 'Failed to load plants: ${response.statusCode}';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Error fetching plants: $e';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BackgroundScaffold(
      title: 'MyGardenGnome',
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                hintText: 'Search plants...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.white70,
              ),
              onChanged: (value) {
                query = value;
                fetchPlants(query);
              },
            ),
            const SizedBox(height: 20),
            if (isLoading)
              const Center(child: CircularProgressIndicator())
            else if (errorMessage.isNotEmpty)
              Center(
                child: Text(
                  errorMessage,
                  style: const TextStyle(color: Colors.red, fontSize: 16),
                ),
              )
            else if (plants.isEmpty)
              const Center(
                child: Text(
                  'Start typing to search plants.',
                  style: TextStyle(fontSize: 16, color: Colors.black54),
                ),
              )
            else
              Expanded(
                child: ListView.builder(
                  itemCount: plants.length,
                  itemBuilder: (context, index) {
                    final plant = plants[index];
                    return Card(
                      color: Colors.white70,
                      child: ListTile(
                        title: Text(plant.commonName ?? 'No common name'),
                        subtitle: Text(plant.scientificName ?? 'No scientific name'),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PlantInfoScreen(plant: plant),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
