class Plant {
  final int id;
  final String? commonName;
  final String? scientificName;
  final String? imageUrl;
  final String? family;
  final List<String>? otherName;
  final String? cycle;
  final String? watering;
  final List<String>? sunlight;
  final String? careLevel;
  final String? description;
  final String? dimension;
  final List<String>? origin;

  Plant({
    required this.id,
    this.commonName,
    this.scientificName,
    this.imageUrl,
    this.family,
    this.otherName,
    this.cycle,
    this.watering,
    this.sunlight,
    this.careLevel,
    this.description,
    this.dimension,
    this.origin,
  });

  factory Plant.fromJson(Map<String, dynamic> json) {
    // Normalize list fields
    List<String>? toList(dynamic value) {
      if (value == null) return null;
      if (value is String) return [value];
      if (value is List<dynamic>) return value.cast<String>();
      return null;
    }

    // Normalize scientific_name (String or List)
    String? normalizeScientificName(dynamic value) {
      if (value == null) return null;
      if (value is String) return value;
      if (value is List<dynamic> && value.isNotEmpty) return value[0] as String?;
      return null;
    }

    return Plant(
      id: json['id'] as int,
      commonName: json['common_name'] as String?,
      scientificName: normalizeScientificName(json['scientific_name']),
      imageUrl: json['image_url'] as String?,
      family: json['family'] as String?,
      otherName: toList(json['other_name']),
      cycle: json['cycle'] as String?,
      watering: json['watering'] as String?,
      sunlight: toList(json['sunlight']),
      careLevel: json['care_level'] as String?,
      description: json['description'] as String?,
      dimension: json['dimension'] as String?,
      origin: toList(json['origin']),
    );
  }
}