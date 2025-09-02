import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:story_app/commons/request_exception_error.dart';
import 'package:story_app/model/user.dart';

import 'api_service.dart';

class AuthService extends APIService {
  AuthService({required super.client}) : super();

  Future<Map<String, dynamic>> login(User user) async {
    try {
      final http.Response response = await client.post(
        Uri.parse('${APIService.baseUrl}/login'),
        body: {'email': user.email, 'password': user.password},
      );

      final Map<String, dynamic> responseJson = jsonDecode(response.body);

      if (responseJson['error']) {
        throw RequestException(responseJson['message'], response.statusCode);
      }

      return responseJson;
    } catch (e) {
      if (e.toString().contains('Failed host lookup') ||
          e.toString().contains('No address associated with hostname')) {
        throw RequestException(
          'Network error: Unable to connect to server. Please check your internet connection.',
          0,
        );
      }
      rethrow;
    }
  }

  Future<Map<String, dynamic>> register(User user) async {
    try {
      final http.Response response = await client.post(
        Uri.parse('${APIService.baseUrl}/register'),
        body: {
          'name': user.name,
          'email': user.email,
          'password': user.password,
        },
      );

      final Map<String, dynamic> responseJson = jsonDecode(response.body);

      if (responseJson['error']) {
        throw RequestException(responseJson['message'], response.statusCode);
      }

      return responseJson;
    } catch (e) {
      if (e.toString().contains('Failed host lookup') ||
          e.toString().contains('No address associated with hostname')) {
        throw RequestException(
          'Network error: Unable to connect to server. Please check your internet connection.',
          0,
        );
      }
      rethrow;
    }
  }
}
