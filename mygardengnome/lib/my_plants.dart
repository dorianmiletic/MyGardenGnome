import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mygardengnome/background.dart';
import 'package:mygardengnome/plants_detail_screen.dart';

class MyPlantsScreen extends StatelessWidget {
  const MyPlantsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return BackgroundScaffold(
        title: 'My Plants',
        child: const Center(
          child: Text(
            'User not logged in.',
            style: TextStyle(fontSize: 16),
          ),
        ),
      );
    }

    final plantsRef = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('plants')
        .orderBy('createdAt', descending: true);

    return BackgroundScaffold(
      title: 'My Plants',
      child: StreamBuilder<QuerySnapshot>(
        stream: plantsRef.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text(
                'No plants added yet.',
                style: TextStyle(fontSize: 16, color: Colors.black54),
              ),
            );
          }

          final docs = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 16),
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final plant = docs[index].data() as Map<String, dynamic>;
              final plantId = docs[index].id;

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                elevation: 3,
                child: ListTile(
                  leading: plant['imageUrl'] != null && plant['imageUrl'].toString().isNotEmpty
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: Image.network(
                            plant['imageUrl'],
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                          ),
                        )
                      : const Icon(Icons.local_florist, size: 40),
                  title: Text(plant['commonName'] ?? 'Unnamed'),
                  subtitle: Text(plant['scientificName'] ?? ''),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (ctx) => PlantDetailScreen(
                          plantData: plant,
                          plantId: plantId,
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
