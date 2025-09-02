import 'dart:convert';
{{#enableJsonAnnotation}}
import 'package:json_annotation/json_annotation.dart';
import 'base_model.dart';

part 'user.g.dart';

@JsonSerializable()
class User extends BaseModel {
{{/enableJsonAnnotation}}
{{^enableJsonAnnotation}}
import 'base_model.dart';

class User extends BaseModel {
{{/enableJsonAnnotation}}
  {{#enableJsonAnnotation}}
  @JsonKey(name: 'name')
  {{/enableJsonAnnotation}}
  final String? name;
  
  {{#enableJsonAnnotation}}
  @JsonKey(name: 'email')
  {{/enableJsonAnnotation}}
  final String? email;
  
  {{#enableJsonAnnotation}}
  @JsonKey(name: 'password')
  {{/enableJsonAnnotation}}
  final String? password;

  const User({
    this.name,
    this.email,
    this.password,
  });

  const User.register({
    required this.name,
    required this.email,
    required this.password,
  });

  const User.login({
    required this.email,
    required this.password,
  }) : name = null;

  {{#enableJsonAnnotation}}
  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  
  @override
  Map<String, dynamic> toJson() => _$UserToJson(this);
  {{/enableJsonAnnotation}}
  {{^enableJsonAnnotation}}
  @override
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'password': password,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User.register(
      name: map['name'],
      email: map['email'],
      password: map['password'],
    );
  }

  @override
  String toJson() => json.encode(toMap());
  factory User.fromJson(String source) => User.fromMap(json.decode(source));
  {{/enableJsonAnnotation}}

  @override
  String toString() => 'User(name: $name, email: $email)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is User && 
           other.name == name && 
           other.email == email && 
           other.password == password;
  }

  @override
  int get hashCode => Object.hash(name, email, password);

  // Copy with method for immutability
  User copyWith({
    String? name,
    String? email,
    String? password,
  }) {
    return User(
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
    );
  }
}