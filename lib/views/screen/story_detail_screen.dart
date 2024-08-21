import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:story_app/provider/story_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class StoryDetailsScreen extends StatelessWidget {
  const StoryDetailsScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final StoryProvider storyProvider = context.watch<StoryProvider>();
    return Scaffold(
      appBar: AppBar(
        title: Text(storyProvider.isLoadingStory
            ? AppLocalizations.of(context)!.loading
            : storyProvider.story!.name!),
      ),
      body: !storyProvider.isLoadingStory && storyProvider.story == null
          ? Center(
              child: Text(AppLocalizations.of(context)!.error),
            )
          : storyProvider.isLoadingStory
              ? Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(16),
                  child: const CircularProgressIndicator(),
                )
              : Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          clipBehavior: Clip.antiAlias,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Image.network(
                            storyProvider.story!.photoUrl,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        Text(storyProvider.story!.name!,
                            style: Theme.of(context).textTheme.titleLarge),
                        const SizedBox(
                          height: 8,
                        ),
                        Text(storyProvider.story!.description,
                            style: Theme.of(context).textTheme.titleMedium),
                      ],
                    ),
                  ),
                ),
    );
  }
}
