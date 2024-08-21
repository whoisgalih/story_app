import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:story_app/commons/request_exception_error.dart';
import 'package:story_app/provider/auth_provider.dart';
import 'package:story_app/provider/stories_provider.dart';
import 'package:story_app/themes/colors.dart';
import 'package:story_app/views/widgets/story_card.dart';

class StoryListScreen extends StatefulWidget {
  final Function(String) onTapped;
  final Function() onLogout;
  final Function() onAddStory;

  const StoryListScreen({
    Key? key,
    required this.onTapped,
    required this.onLogout,
    required this.onAddStory,
  }) : super(key: key);

  @override
  State<StoryListScreen> createState() => _StoryListScreenState();
}

class _StoryListScreenState extends State<StoryListScreen> {
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(
      () {
        if (_scrollController.position.pixels >=
                _scrollController.position.maxScrollExtent &&
            context.read<StoriesProvider>().page != null) {
          getStories();
        }
      },
    );

    Future.microtask(() async => await getStories());
  }

  Future<void> getStories() async {
    try {
      await context.read<StoriesProvider>().getStories();
    } on RequestException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.message),
        ),
      );
    }
  }

  // refresh stories
  Future<void> refreshStories() async {
    try {
      await context.read<StoriesProvider>().refreshStories();
    } on RequestException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authWatch = context.watch<AuthProvider>();
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.story),
        actions: [
          IconButton(
            onPressed: () async {
              final result = await authWatch.logout();
              if (result) widget.onLogout();
            },
            tooltip: AppLocalizations.of(context)!.logout,
            icon: authWatch.isLoadingLogout
                ? const CircularProgressIndicator(
                    color: Colors.white,
                  )
                : const Icon(Icons.logout),
          ),
        ],
      ),
      body: Consumer(
        builder: (BuildContext context, StoriesProvider storiesProvider, _) {
          return RefreshIndicator(
            color: accentColor,
            onRefresh: () async {
              await refreshStories();
            },
            child: ListView.builder(
              controller: _scrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: storiesProvider.stories.length +
                  (storiesProvider.page != null ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == storiesProvider.stories.length &&
                    storiesProvider.page != null) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: CircularProgressIndicator(),
                    ),
                  );
                }

                return GestureDetector(
                  onTap: () =>
                      widget.onTapped(storiesProvider.stories[index].id!),
                  child: StoryCard(
                    story: storiesProvider.stories[index],
                  ),
                );
              },
            ),
          );
        },
      ),

      /// todo 18: add FAB and update the UI when button is tapped.
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          widget.onAddStory();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
