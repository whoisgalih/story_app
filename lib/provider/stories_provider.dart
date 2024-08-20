import 'package:flutter/material.dart';
import 'package:story_app/data/api/stories_service.dart';
import 'package:story_app/data/db/auth_repository.dart';
import 'package:story_app/model/story.dart';

class StoriesProvider extends ChangeNotifier {
  final StoriesService storiesService;

  StoriesProvider(this.storiesService) {
    getStories();
  }

  List<Story> stories = [];
  bool isLoadingStories = false;

  Future<bool> getStories() async {
    isLoadingStories = true;
    notifyListeners();

    final String token = await AuthRepository.getToken();
    stories = await storiesService.getStories(token);
    notifyListeners();

    isLoadingStories = false;
    notifyListeners();

    return true;
  }
}
