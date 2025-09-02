{{#enableJsonAnnotation}}
import 'package:json_annotation/json_annotation.dart';

part 'api_response.g.dart';

@JsonSerializable(genericArgumentFactories: true)
class ApiResponse<T> {
  @JsonKey(name: 'error')
  final bool error;
  
  @JsonKey(name: 'message')
  final String message;
  
  @JsonKey(name: 'loginResult', includeIfNull: false)
  final T? data;

  const ApiResponse({
    required this.error,
    required this.message,
    this.data,
  });

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) => _$ApiResponseFromJson(json, fromJsonT);

  Map<String, dynamic> toJson(Object Function(T value) toJsonT) =>
      _$ApiResponseToJson(this, toJsonT);
}
{{/enableJsonAnnotation}}
{{^enableJsonAnnotation}}
class ApiResponse<T> {
  final bool error;
  final String message;
  final T? data;

  const ApiResponse({
    required this.error,
    required this.message,
    this.data,
  });

  factory ApiResponse.fromMap(Map<String, dynamic> map, T Function(Map<String, dynamic>) fromMap) {
    return ApiResponse<T>(
      error: map['error'] ?? false,
      message: map['message'] ?? '',
      data: map['loginResult'] != null ? fromMap(map['loginResult']) : null,
    );
  }

  Map<String, dynamic> toMap(Map<String, dynamic> Function(T) toMap) {
    return {
      'error': error,
      'message': message,
      if (data != null) 'loginResult': toMap(data as T),
    };
  }
}
{{/enableJsonAnnotation}}