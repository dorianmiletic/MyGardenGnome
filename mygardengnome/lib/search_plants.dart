import 'dart:async';
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
  final String apiKey = 'sk-66pW68361bf2b6b4210697';
  List<Plant> plants = [];
  bool isLoading = false;
  String errorMessage = '';
  String query = '';
  Timer? _debounce;
  int currentPage = 1;
  bool hasMore = true;
  final int maxPlants = 50;

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  Future<void> fetchPlants(String query, {bool loadMore = false}) async {
    if (query.isEmpty) {
      setState(() {
        plants = [];
        errorMessage = '';
        currentPage = 1;
        hasMore = true;
      });
      return;
    }

    if (!loadMore) {
      setState(() {
        plants = [];
        currentPage = 1;
        hasMore = true;
      });
    }

    if (plants.length >= maxPlants) {
      setState(() {
        hasMore = false;
      });
      return;
    }

    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    try {
      final encodedQuery = Uri.encodeQueryComponent(query);
      final url = Uri.parse(
        'https://perenual.com/api/species-list?key=$apiKey&q=$encodedQuery&page=$currentPage',
      );
      print('Request URL: $url');

      final response = await http.get(url);

      print('Status code: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(response.body);
        final List<dynamic> data = jsonData['data'] ?? [];
        final int total = jsonData['total'] ?? 0;

        print('Fetched ${data.length} plants from API, Total: $total');

        List<Plant> fetchedPlants = data.map((json) {
          // Debug field types
          print('Scientific name type: ${json['scientific_name'].runtimeType}');
          print('Other name type: ${json['other_name']?.runtimeType}');
          print('Sunlight type: ${json['sunlight']?.runtimeType}');
          print('Origin type: ${json['origin']?.runtimeType}');
          
          return Plant.fromJson({
            'id': json['id'],
            'common_name': json['common_name'],
            'scientific_name': json['scientific_name'],
            'image_url': json['default_image']?['original_url'],
            'family': json['family'],
            'other_name': json['other_name'],
            'cycle': json['cycle'],
            'watering': json['watering'],
            'sunlight': json['sunlight'],
            'care_level': json['care_level'],
            'description': json['description'],
            'dimension': json['dimension'],
            'origin': json['origin'],
          });
        }).toList();

        setState(() {
          plants.addAll(fetchedPlants);
          isLoading = false;
          if (fetchedPlants.isEmpty || plants.length >= total || plants.length >= maxPlants) {
            hasMore = false;
          }
          if (plants.isEmpty) {
            final mockData = [
              {
                'id': 1,
                'common_name': 'Coconut Palm',
                'scientific_name': 'Cocos nucifera',
                'image_url': 'https://example.com/coconut.jpg',
                'family': 'Arecaceae',
                'other_name': ['Coco', 'Coconut Tree'],
                'cycle': 'Perennial',
                'watering': 'Moderate',
                'sunlight': ['Full sun'],
                'care_level': 'Moderate',
                'description': 'A tropical palm producing coconuts.',
                'dimension': 'Up to 100 ft tall',
                'origin': ['Southeast Asia'],
              },
              {
                'id': 2,
                'common_name': 'Cocoa Tree',
                'scientific_name': 'Theobroma cacao',
                'image_url': 'https://example.com/cocoa.jpg',
                'family': 'Malvaceae',
                'other_name': ['Cacao'],
                'cycle': 'Perennial',
                'watering': 'Frequent',
                'sunlight': ['Partial shade'],
                'care_level': 'High',
                'description': 'A small tree producing cocoa beans.',
                'dimension': 'Up to 25 ft tall',
                'origin': ['South America'],
              },
              {
                'id': 3,
                'common_name': 'Coco Yam',
                'scientific_name': 'Colocasia esculenta',
                'image_url': 'https://example.com/cocoyam.jpg',
                'family': 'Araceae',
                'other_name': ['Taro'],
                'cycle': 'Perennial',
                'watering': 'Frequent',
                'sunlight': ['Partial sun'],
                'care_level': 'Moderate',
                'description': 'A tropical plant with edible roots.',
                'dimension': 'Up to 6 ft tall',
                'origin': ['Asia'],
              },
              {
                'id': 4,
                'common_name': 'Black-eyed Susan',
                'scientific_name': 'Rudbeckia hirta',
                'image_url': 'https://example.com/blackeyedsusan.jpg',
                'family': 'Asteraceae',
                'other_name': ['Gloriosa Daisy'],
                'cycle': 'Biennial',
                'watering': 'Average',
                'sunlight': ['Full sun'],
                'care_level': 'Low',
                'description': 'A vibrant wildflower with yellow petals.',
                'dimension': 'Up to 3 ft tall',
                'origin': ['North America'],
              },
              {
                'id': 5,
                'common_name': 'Rose',
                'scientific_name': 'Rosa spp.',
                'image_url': 'https://example.com/rose.jpg',
                'family': 'Rosaceae',
                'other_name': ['Garden Rose'],
                'cycle': 'Perennial',
                'watering': 'Average',
                'sunlight': ['Full sun'],
                'care_level': 'Moderate',
                'description': 'A classic flowering shrub.',
                'dimension': 'Up to 6 ft tall',
                'origin': ['Europe', 'Asia'],
              },
            ];
            plants = mockData.map((json) => Plant.fromJson(json)).toList().take(maxPlants).toList();
            errorMessage = 'No plants found for "$query". Showing sample data.';
          }
        });
      } else {
        print('Falling back to mock data due to ${response.statusCode} error');
        final mockData = [
          {
            'id': 1,
            'common_name': 'Coconut Palm',
            'scientific_name': 'Cocos nucifera',
            'image_url': 'https://example.com/coconut.jpg',
            'family': 'Arecaceae',
            'other_name': ['Coco', 'Coconut Tree'],
            'cycle': 'Perennial',
            'watering': 'Moderate',
            'sunlight': ['Full sun'],
            'care_level': 'Moderate',
            'description': 'A tropical palm producing coconuts.',
            'dimension': 'Up to 100 ft tall',
            'origin': ['Southeast Asia'],
          },
          {
            'id': 2,
            'common_name': 'Cocoa Tree',
            'scientific_name': 'Theobroma cacao',
            'image_url': 'https://example.com/cocoa.jpg',
            'family': 'Malvaceae',
            'other_name': ['Cacao'],
            'cycle': 'Perennial',
            'watering': 'Frequent',
            'sunlight': ['Partial shade'],
            'care_level': 'High',
            'description': 'A small tree producing cocoa beans.',
            'dimension': 'Up to 25 ft tall',
            'origin': ['South America'],
          },
          {
            'id': 3,
            'common_name': 'Coco Yam',
            'scientific_name': 'Colocasia esculenta',
            'image_url': 'https://example.com/cocoyam.jpg',
            'family': 'Araceae',
            'other_name': ['Taro'],
            'cycle': 'Perennial',
            'watering': 'Frequent',
            'sunlight': ['Partial sun'],
            'care_level': 'Moderate',
            'description': 'A tropical plant with edible roots.',
            'dimension': 'Up to 6 ft tall',
            'origin': ['Asia'],
          },
          {
            'id': 4,
            'common_name': 'Black-eyed Susan',
            'scientific_name': 'Rudbeckia hirta',
            'image_url': 'https://example.com/blackeyedsusan.jpg',
            'family': 'Asteraceae',
            'other_name': ['Gloriosa Daisy'],
            'cycle': 'Biennial',
            'watering': 'Average',
            'sunlight': ['Full sun'],
            'care_level': 'Low',
            'description': 'A vibrant wildflower with yellow petals.',
            'dimension': 'Up to 3 ft tall',
            'origin': ['North America'],
          },
          {
            'id': 5,
            'common_name': 'Rose',
            'scientific_name': 'Rosa spp.',
            'image_url': 'https://example.com/rose.jpg',
            'family': 'Rosaceae',
            'other_name': ['Garden Rose'],
            'cycle': 'Perennial',
            'watering': 'Average',
            'sunlight': ['Full sun'],
            'care_level': 'Moderate',
            'description': 'A classic flowering shrub.',
            'dimension': 'Up to 6 ft tall',
            'origin': ['Europe', 'Asia'],
          },
        ];
        setState(() {
          plants = mockData.map((json) => Plant.fromJson(json)).toList().take(maxPlants).toList();
          errorMessage = 'API error (${response.statusCode}). Showing sample data.';
          isLoading = false;
          hasMore = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Error fetching plants: $e';
        isLoading = false;
      });
      print('Error: $e');
    }
  }

  void _onSearchChanged(String value) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      query = value;
      fetchPlants(query);
    });
  }

  void _loadMore() {
    if (!isLoading && hasMore) {
      setState(() {
        currentPage++;
      });
      fetchPlants(query, loadMore: true);
    }
  }

  void _retry() {
    if (query.isNotEmpty) {
      fetchPlants(query);
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
                hintText: 'Search plants (e.g., coconut, black-eyed susan, rose)...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.white70,
              ),
              onChanged: _onSearchChanged,
            ),
            const SizedBox(height: 20),
            if (isLoading)
              const Center(child: CircularProgressIndicator())
            else if (errorMessage.isNotEmpty)
              Center(
                child: Column(
                  children: [
                    Text(
                      errorMessage,
                      style: const TextStyle(color: Colors.red, fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: _retry,
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              )
            else if (plants.isEmpty)
              const Center(
                child: Text(
                  'Start typing to search plants.',
                  style: TextStyle(fontSize: 16, color: Colors.black54,backgroundColor: Colors.white70),
                ),
              )
            else
              Expanded(
                child: ListView.builder(
                  itemCount: plants.length + (hasMore ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index == plants.length && hasMore) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                          onPressed: _loadMore,
                          child: const Text('Load More'),
                        ),
                      );
                    }
                    final plant = plants[index];
                    print('Building plant: ${plant.commonName}');
                    return Card(
                      color: Colors.white70,
                      child: ListTile(
                        leading: plant.imageUrl != null && plant.imageUrl!.isNotEmpty
                            ? Image.network(
                                plant.imageUrl!,
                                width: 50,
                                height: 50,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    const Icon(Icons.error),
                              )
                            : const Icon(Icons.image_not_supported),
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