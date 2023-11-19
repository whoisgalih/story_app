import 'package:http/http.dart' as http;

abstract class APIService {
  final http.Client client;

  APIService({
    required this.client,
  });

  static const String baseUrl = 'https://story-api.dicoding.dev/v1';
}
