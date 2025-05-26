class Plant {
  final int id;
  final String commonName;
  final String scientificName;
  final String imageUrl;

  Plant({
    required this.id,
    required this.commonName,
    required this.scientificName,
    required this.imageUrl,
  });

  factory Plant.fromJson(Map<String, dynamic> json) {
    return Plant(
      id: json['id'] ?? 0,
      commonName: json['common_name'] ?? '',
      scientificName: json['scientific_name'] ?? '',
      imageUrl: json['image_url'] ?? '',
    );
  }
}
