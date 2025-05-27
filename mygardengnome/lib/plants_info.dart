import 'package:flutter/material.dart';
import 'package:mygardengnome/background.dart';
import 'package:mygardengnome/models/plant.dart';

class PlantInfoScreen extends StatelessWidget {
  final Plant plant;

  const PlantInfoScreen({Key? key, required this.plant}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BackgroundScaffold(
      title: plant.commonName ?? 'Unknown Plant',
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            Center(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: plant.imageUrl != null && plant.imageUrl!.isNotEmpty
                      ? Image.network(
                          plant.imageUrl!,
                          height: 200,
                          width: double.infinity,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) => const SizedBox(
                            height: 200,
                            child: Center(
                              child: Icon(Icons.error_outline, size: 60, color: Colors.grey),
                            ),
                          ),
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return const SizedBox(
                              height: 200,
                              child: Center(child: CircularProgressIndicator()),
                            );
                          },
                        )
                      : const SizedBox(
                          height: 200,
                          child: Center(
                            child: Icon(Icons.local_florist, size: 60, color: Colors.grey),
                          ),
                        ),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // General Information
            _buildSectionCard(
              title: 'General Information',
              children: [
                _buildInfoRow('Common Name', plant.commonName ?? 'Unknown'),
                _buildInfoRow('Scientific Name', plant.scientificName ?? 'Unknown', isItalic: true),
                _buildInfoRow('Family', plant.family ?? 'Unknown'),
                _buildInfoRow('Other Names', plant.otherName?.join(', ') ?? 'None'),
                _buildInfoRow('Origin', plant.origin?.join(', ') ?? 'Unknown'),
              ],
            ),
            const SizedBox(height: 24),

            // Growth Details
            _buildSectionCard(
              title: 'Growth Details',
              children: [
                _buildInfoRow('Cycle', plant.cycle ?? 'Unknown'),
                _buildInfoRow('Dimension', plant.dimension ?? 'Unknown'),
              ],
            ),
            const SizedBox(height: 24),

            // Care Instructions
            _buildSectionCard(
              title: 'Care Instructions',
              children: [
                _buildInfoRow('Watering', plant.watering ?? 'Unknown'),
                _buildInfoRow('Sunlight', plant.sunlight?.join(', ') ?? 'Unknown'),
                _buildInfoRow('Care Level', plant.careLevel ?? 'Unknown'),
              ],
            ),
            const SizedBox(height: 24),

            // Description
            _buildSectionCard(
              title: 'Description',
              children: [
                Text(
                  plant.description ?? 'No description available.',
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black87,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionCard({required String title, required List<Widget> children}) {
    return Card(
      elevation: 3,
      color: Colors.white.withOpacity(0.9),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 12),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, {bool isItalic = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 16,
                color: Colors.black87,
                fontStyle: isItalic ? FontStyle.italic : FontStyle.normal,
              ),
            ),
          ),
        ],
      ),
    );
  }
}