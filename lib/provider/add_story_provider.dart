import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:story_app/data/api/stories_service.dart';
import 'package:story_app/data/db/auth_repository.dart';
import 'package:story_app/model/story.dart';

class AddStoryProvider extends ChangeNotifier {
  final StoriesService storiesService;

  bool _isLoading = false;

  final GlobalKey<FormState> addStoryGlobalKey = GlobalKey<FormState>();
  final TextEditingController descriptionController = TextEditingController();

  String? imagePath;
  XFile? imageFile;

  AddStoryProvider({
    required this.storiesService,
  });

  // toggle loading
  bool get isLoading => _isLoading;

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void setImagePath(String? value) {
    imagePath = value;
    notifyListeners();
  }

  void setImageFile(XFile? value) {
    imageFile = value;
    notifyListeners();
  }

  // Validators
  String? imageValidator() {
    if (imagePath == null) {
      return "Image must be selected";
    }

    // validate image less than 1mb
    File imageFile = File(imagePath!);
    if (imageFile.lengthSync() > 1000000) {
      return "Image must be less than 1mb";
    }

    return null;
  }

  String? descriptionValidator() {
    if (descriptionController.text.isEmpty) {
      return "Description must be filled";
    }

    return null;
  }

  // API
  Future<void> addStory() async {
    if (addStoryGlobalKey.currentState!.validate()) {
      addStoryGlobalKey.currentState!.save();

      final story = Story(
        description: descriptionController.text,
        photoUrl: imagePath!,
      );

      // get token from repo
      final token = await AuthRepository.getToken();

      await storiesService.addStory(token, story);
    }
  }
}
