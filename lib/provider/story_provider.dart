import 'package:flutter/material.dart';
import 'package:story_app/data/api/stories_service.dart';
import 'package:story_app/data/db/auth_repository.dart';
import 'package:story_app/model/story.dart';

class StoryProvider extends ChangeNotifier {
  final AuthRepository authRepository;
  final StoriesService storiesService;
  final String id;

  StoryProvider(this.authRepository, this.storiesService, this.id) {
    getStoryById();
  }

  Story? story;
  bool isLoadingStory = false;

  Future<bool> getStoryById() async {
    isLoadingStory = true;
    notifyListeners();

    final String token = await authRepository.getToken();
    story = await storiesService.getStoryById(token, id);

    isLoadingStory = false;
    notifyListeners();

    return true;
  }
}
