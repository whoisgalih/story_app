import 'package:flutter/material.dart';
import 'package:story_app/data/api/stories_service.dart';
import 'package:story_app/data/db/auth_repository.dart';
import 'package:story_app/model/story.dart';

class StoriesProvider extends ChangeNotifier {
  final StoriesService storiesService;

  StoriesProvider({required this.storiesService});

  List<Story> stories = [];
  bool isLoadingStories = false;

  int? page = 1;
  int sizeItems = 10;

  Future<bool> getStories() async {
    isLoadingStories = true;
    notifyListeners();

    final String token = await AuthRepository.getToken();
    List<Story> result = await storiesService.getStories(
      token,
      page.toString(),
      sizeItems.toString(),
    );

    if (result.length < sizeItems) {
      page = null;
    } else {
      page = page! + 1;
    }

    if (result.isEmpty) {
      isLoadingStories = false;
      notifyListeners();
      return false;
    }

    stories.addAll(result);
    notifyListeners();

    isLoadingStories = false;
    notifyListeners();

    return true;
  }

  Future<void> refreshStories() async {
    page = 1;
    stories = [];
    await getStories();
  }
}
