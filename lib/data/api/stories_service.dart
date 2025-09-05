import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:story_app/commons/request_exception_error.dart';
import 'package:story_app/model/story.dart';

import 'api_service.dart';

class StoriesService extends APIService {
  StoriesService({required super.client});

  Future<List<Story>> getStories(String token, String page, String size) async {
    final http.Response response = await client.get(
      Uri.https('story-api.dicoding.dev', '/v1/stories', {
        'page': page,
        'size': size,
      }),
      headers: {HttpHeaders.authorizationHeader: 'Bearer $token'},
    );

    final Map<String, dynamic> responseJson = jsonDecode(response.body);

    if (responseJson['error']) {
      throw RequestException(responseJson['message'], response.statusCode);
    }

    final List<Story> stories = responseJson['listStory'].map<Story>((story) {
      return Story.fromMap(story);
    }).toList();

    return stories;
  }

  Future<Story> getStoryById(String token, String id) async {
    final http.Response response = await client.get(
      Uri.parse('${APIService.baseUrl}/stories/$id'),
      headers: {HttpHeaders.authorizationHeader: 'Bearer $token'},
    );

    final Map<String, dynamic> responseJson = jsonDecode(response.body);

    if (responseJson['error']) {
      throw RequestException(responseJson['message'], response.statusCode);
    }

    final Story story = Story.fromMap(responseJson['story']);

    return story;
  }

  Future<void> addStory(String token, Story story) async {
    final http.MultipartRequest request = http.MultipartRequest(
      "POST",
      Uri.parse('${APIService.baseUrl}/stories'),
    );

    request.headers[HttpHeaders.authorizationHeader] = 'Bearer $token';

    request.fields['description'] = story.description;

    if (story.lat != null && story.lon != null) {
      request.fields['lat'] = story.lat!.toString();
      request.fields['lon'] = story.lon!.toString();
    }

    request.files.add(
      await http.MultipartFile.fromPath('photo', story.photoUrl),
    );

    final http.StreamedResponse response = await client.send(request);

    final String responseString = await response.stream.bytesToString();

    final Map<String, dynamic> responseJson = jsonDecode(responseString);

    if (responseJson['error']) {
      throw RequestException(responseJson['message'], response.statusCode);
    }

    return;
  }
}
