import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:story_app/commons/request_exception_error.dart';
import 'package:story_app/provider/add_story_provider.dart';
import 'package:story_app/themes/colors.dart';

class AddStoryScreen extends StatefulWidget {
  final Function() onAddStory;

  const AddStoryScreen({super.key, required this.onAddStory});

  @override
  State<AddStoryScreen> createState() => _AddStoryScreenState();
}

class _AddStoryScreenState extends State<AddStoryScreen> {
  @override
  Widget build(BuildContext context) {
    AddStoryProvider addStoryProvider = context.watch<AddStoryProvider>();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Story"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Form(
            key: addStoryProvider.addStoryGlobalKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FormField<XFile>(
                  validator: (value) => addStoryProvider.imageValidator(),
                  builder: (formFieldState) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          clipBehavior: Clip.antiAlias,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: primaryColor[100],
                          ),
                          height: 500,
                          width: double.infinity,
                          child: addStoryProvider.imagePath == null
                              ? const Align(
                                  alignment: Alignment.center,
                                  child: Icon(
                                    Icons.image,
                                    size: 100,
                                  ),
                                )
                              : _showImage(),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Expanded(
                              child: Material(
                                color: primaryColor[100],
                                borderRadius: BorderRadius.circular(10),
                                child: InkWell(
                                  onTap: () => _onGalleryView(),
                                  customBorder: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8)),
                                  child: Container(
                                    alignment: Alignment.center,
                                    padding: const EdgeInsets.all(32),
                                    child: const Text("Gallery"),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 16,
                            ),
                            Expanded(
                              child: Material(
                                color: primaryColor[100],
                                borderRadius: BorderRadius.circular(10),
                                child: InkWell(
                                  onTap: () => _onCameraView(),
                                  customBorder: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8)),
                                  child: Container(
                                    alignment: Alignment.center,
                                    padding: const EdgeInsets.all(32),
                                    child: const Text("Camera"),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        if (formFieldState.hasError)
                          Padding(
                            padding: const EdgeInsets.only(left: 8, top: 16),
                            child: Text(
                              formFieldState.errorText!,
                              style: TextStyle(
                                  fontStyle: FontStyle.normal,
                                  fontSize: 13,
                                  color: Colors.red[700],
                                  height: 0.5),
                            ),
                          )
                      ],
                    );
                  },
                ),
                const SizedBox(
                  height: 16,
                ),
                TextFormField(
                  controller: addStoryProvider.descriptionController,
                  keyboardType: TextInputType.multiline,
                  minLines: 5,
                  maxLines: 10,
                  decoration: const InputDecoration(
                    hintText: "Description",
                  ),
                  validator: (value) => addStoryProvider.descriptionValidator(),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          try {
            addStoryProvider.addStory();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Story added"),
              ),
            );
            widget.onAddStory();
          } on RequestException catch (e) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(e.message),
              ),
            );
          }
        },
        child: const Icon(Icons.upload),
      ),
    );
  }

  _onGalleryView() async {
    final provider = context.read<AddStoryProvider>();

    final isMacOS = defaultTargetPlatform == TargetPlatform.macOS;
    final isLinux = defaultTargetPlatform == TargetPlatform.linux;
    if (isMacOS || isLinux) return;

    final picker = ImagePicker();

    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
    );

    if (pickedFile != null) {
      provider.setImageFile(pickedFile);
      provider.setImagePath(pickedFile.path);
    }
  }

  _onCameraView() async {
    final provider = context.read<AddStoryProvider>();

    final isAndroid = defaultTargetPlatform == TargetPlatform.android;
    final isiOS = defaultTargetPlatform == TargetPlatform.iOS;
    final isNotMobile = !(isAndroid || isiOS);
    if (isNotMobile) return;

    final picker = ImagePicker();

    final pickedFile = await picker.pickImage(
      source: ImageSource.camera,
    );

    if (pickedFile != null) {
      provider.setImageFile(pickedFile);
      provider.setImagePath(pickedFile.path);
    }
  }

  Widget _showImage() {
    final imagePath = context.read<AddStoryProvider>().imagePath;
    return kIsWeb
        ? Image.network(
            imagePath.toString(),
            fit: BoxFit.cover,
          )
        : Image.file(
            File(imagePath.toString()),
            fit: BoxFit.cover,
          );
  }
}
