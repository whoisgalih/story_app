import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:story_app/provider/story_provider.dart';
import 'package:story_app/l10n/app_localizations.dart';
import 'package:story_app/views/widgets/map_widget.dart';

class StoryDetailsScreen extends StatelessWidget {
  const StoryDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final StoryProvider storyProvider = context.watch<StoryProvider>();
    return Scaffold(
      appBar: AppBar(
        title: Text(
          storyProvider.isLoadingStory
              ? AppLocalizations.of(context)!.loading
              : storyProvider.story!.name!,
        ),
      ),
      body: !storyProvider.isLoadingStory && storyProvider.story == null
          ? _buildErrorStory(context)
          : storyProvider.isLoadingStory
          ? _buildLoadingStory(context)
          : _buildStoryDetails(context, storyProvider),
    );
  }

  Widget _buildErrorStory(BuildContext context) {
    return Center(child: Text(AppLocalizations.of(context)!.error));
  }

  Widget _buildLoadingStory(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.all(16),
      child: const CircularProgressIndicator(),
    );
  }

  Widget _buildStoryDetails(BuildContext context, StoryProvider storyProvider) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
              child: Image.network(
                storyProvider.story!.photoUrl,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: double.infinity,
                    height: 200,
                    color: Colors.grey[300],
                    child: const Icon(
                      Icons.broken_image,
                      size: 64,
                      color: Colors.grey,
                    ),
                  );
                },
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Container(
                    width: double.infinity,
                    height: 200,
                    color: Colors.grey[200],
                    child: const Center(child: CircularProgressIndicator()),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            Text(
              storyProvider.story!.name!,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              storyProvider.story!.description,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            // Map
            MapWidget(story: storyProvider.story!),
          ],
        ),
      ),
    );
  }
}
