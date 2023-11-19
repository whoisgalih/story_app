import 'dart:convert';

class Story {
  String? id;
  final String? name;
  final String description;
  final String photoUrl;
  final String? createdAt;
  final double? lat;
  final double? lon;

  Story({
    this.name,
    required this.description,
    required this.photoUrl,
    this.createdAt,
    this.lat,
    this.lon,
  });

  Story.withId({
    required this.id,
    required this.name,
    required this.description,
    required this.photoUrl,
    required this.createdAt,
    this.lat,
    this.lon,
  });

  // to json
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'photoUrl': photoUrl,
      'createdAt': createdAt,
      'lat': lat,
      'lon': lon,
    };
  }

  // from json
  factory Story.fromMap(Map<String, dynamic> map) {
    return Story.withId(
      id: map['id'],
      name: map['name'],
      description: map['description'],
      photoUrl: map['photoUrl'],
      createdAt: map['createdAt'],
      lat: map['lat'],
      lon: map['lon'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Story.fromJson(String source) => Story.fromMap(json.decode(source));
}
