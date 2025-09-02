import 'package:http/http.dart' as http;

abstract class APIService {
  final http.Client client;

  APIService({required this.client});

  static const String baseUrl = 'https://story-api.dicoding.dev/v1';

  // Alternative URLs in case DNS resolution fails on Android
  static const String baseUrlIP1 = 'https://75.2.21.170/v1';
  static const String baseUrlIP2 = 'https://99.83.220.86/v1';
}
