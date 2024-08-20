import 'package:flutter/material.dart';
import 'package:story_app/data/api/stories_service.dart';
import 'package:story_app/data/db/auth_repository.dart';
import 'package:story_app/model/story.dart';

class StoryProvider extends ChangeNotifier {
  final StoriesService storiesService;
  final String id;

  StoryProvider(this.storiesService, this.id) {
    getStoryById();
  }

  Story? story;
  bool isLoadingStory = false;

  Future<bool> getStoryById() async {
    isLoadingStory = true;
    notifyListeners();

    final String token = await AuthRepository.getToken();
    story = await storiesService.getStoryById(token, id);

    if (story == null) {
      isLoadingStory = false;
      notifyListeners();
      return false;
    }

    isLoadingStory = false;
    notifyListeners();

    return true;
  }
}
