import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
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
  LatLng? latLng;

  AddStoryProvider({required this.storiesService});

  // toggle loading
  bool get isLoading => _isLoading;

  void setImagePath(String? value) {
    imagePath = value;
    notifyListeners();
  }

  void setImageFile(XFile? value) {
    imageFile = value;
    notifyListeners();
  }

  void setLatLng(LatLng value) {
    latLng = value;
    notifyListeners();
  }

  String? imageValidator({
    required String mustBeSelected,
    required String mustBeLessThan1Mb,
  }) {
    if (imagePath == null) {
      return mustBeSelected;
    }

    File imageFile = File(imagePath!);
    if (imageFile.lengthSync() > 1000000) {
      return mustBeLessThan1Mb;
    }

    return null;
  }

  String? descriptionValidator({required String mustBeFilled}) {
    if (descriptionController.text.isEmpty) {
      return mustBeFilled;
    }

    return null;
  }

  Future<void> addStory() async {
    if (addStoryGlobalKey.currentState!.validate()) {
      addStoryGlobalKey.currentState!.save();

      _isLoading = true;
      notifyListeners();

      final story = Story(
        description: descriptionController.text,
        photoUrl: imagePath!,
        lat: latLng?.latitude,
        lon: latLng?.longitude,
      );

      // get token from repo
      final token = await AuthRepository.getToken();

      await storiesService.addStory(token, story);

      _isLoading = false;
      notifyListeners();
    }
  }
}
