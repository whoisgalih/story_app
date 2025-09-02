{{#enableJsonAnnotation}}
import 'package:json_annotation/json_annotation.dart';
{{/enableJsonAnnotation}}

abstract class BaseModel {
  const BaseModel();
  
  {{#enableJsonAnnotation}}
  Map<String, dynamic> toJson();
  {{/enableJsonAnnotation}}
  {{^enableJsonAnnotation}}
  Map<String, dynamic> toMap();
  String toJson();
  {{/enableJsonAnnotation}}
  
  @override
  bool operator ==(Object other);
  
  @override
  int get hashCode;
  
  @override
  String toString();
}