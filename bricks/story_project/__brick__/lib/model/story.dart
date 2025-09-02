import 'dart:convert';
{{#enableJsonAnnotation}}
import 'package:json_annotation/json_annotation.dart';
import 'base_model.dart';

part 'story.g.dart';

@JsonSerializable()
class Story extends BaseModel {
{{/enableJsonAnnotation}}
{{^enableJsonAnnotation}}
import 'base_model.dart';

class Story extends BaseModel {
{{/enableJsonAnnotation}}
  {{#enableJsonAnnotation}}
  @JsonKey(name: 'id')
  {{/enableJsonAnnotation}}
  final String? id;
  
  {{#enableJsonAnnotation}}
  @JsonKey(name: 'name')
  {{/enableJsonAnnotation}}
  final String? name;
  
  {{#enableJsonAnnotation}}
  @JsonKey(name: 'description')
  {{/enableJsonAnnotation}}
  final String description;
  
  {{#enableJsonAnnotation}}
  @JsonKey(name: 'photoUrl')
  {{/enableJsonAnnotation}}
  final String photoUrl;
  
  {{#enableJsonAnnotation}}
  @JsonKey(name: 'createdAt')
  {{/enableJsonAnnotation}}
  final String? createdAt;
  
  {{#enableJsonAnnotation}}
  @JsonKey(name: 'lat')
  {{/enableJsonAnnotation}}
  final double? lat;
  
  {{#enableJsonAnnotation}}
  @JsonKey(name: 'lon')
  {{/enableJsonAnnotation}}
  final double? lon;

  const Story({
    this.id,
    this.name,
    required this.description,
    required this.photoUrl,
    this.createdAt,
    this.lat,
    this.lon,
  });

  const Story.withId({
    required this.id,
    required this.name,
    required this.description,
    required this.photoUrl,
    required this.createdAt,
    this.lat,
    this.lon,
  });

  {{#enableJsonAnnotation}}
  factory Story.fromJson(Map<String, dynamic> json) => _$StoryFromJson(json);
  
  @override
  Map<String, dynamic> toJson() => _$StoryToJson(this);
  {{/enableJsonAnnotation}}
  {{^enableJsonAnnotation}}
  @override
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

  factory Story.fromMap(Map<String, dynamic> map) {
    return Story.withId(
      id: map['id'],
      name: map['name'],
      description: map['description'],
      photoUrl: map['photoUrl'],
      createdAt: map['createdAt'],
      lat: map['lat']?.toDouble(),
      lon: map['lon']?.toDouble(),
    );
  }

  @override
  String toJson() => json.encode(toMap());
  factory Story.fromJson(String source) => Story.fromMap(json.decode(source));
  {{/enableJsonAnnotation}}

  @override
  String toString() => 'Story(id: $id, name: $name, description: $description)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Story && 
           other.id == id && 
           other.name == name && 
           other.description == description &&
           other.photoUrl == photoUrl &&
           other.createdAt == createdAt &&
           other.lat == lat &&
           other.lon == lon;
  }

  @override
  int get hashCode => Object.hash(id, name, description, photoUrl, createdAt, lat, lon);

  // Copy with method for immutability
  Story copyWith({
    String? id,
    String? name,
    String? description,
    String? photoUrl,
    String? createdAt,
    double? lat,
    double? lon,
  }) {
    return Story(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      photoUrl: photoUrl ?? this.photoUrl,
      createdAt: createdAt ?? this.createdAt,
      lat: lat ?? this.lat,
      lon: lon ?? this.lon,
    );
  }
}