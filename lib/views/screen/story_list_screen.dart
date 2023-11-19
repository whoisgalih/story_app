import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:story_app/model/story.dart';
import 'package:story_app/provider/auth_provider.dart';
import 'package:story_app/provider/stories_provider.dart';
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
  @override
  Widget build(BuildContext context) {
    final authWatch = context.watch<AuthProvider>();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Story App"),
        actions: [
          IconButton(
            onPressed: () async {
              final result = await authWatch.logout();
              if (result) widget.onLogout();
            },
            tooltip: "Logout",
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
        return ListView(
          children: [
            for (Story story in storiesProvider.stories)
              GestureDetector(
                onTap: () => widget.onTapped(story.id!),
                child: StoryCard(story: story),
              )
          ],
        );
      }),

      /// todo 18: add FAB and update the UI when button is tapped.
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          widget.onAddStory();
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
