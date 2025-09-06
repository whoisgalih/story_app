import 'package:provider/provider.dart';
import 'package:story_app/main.dart';
import 'package:story_app/provider/add_story_provider.dart';
import 'package:story_app/provider/stories_provider.dart';
import 'package:story_app/provider/story_provider.dart';
import 'package:flutter/material.dart';

import 'package:story_app/data/db/auth_repository.dart';
import 'package:story_app/views/screen/add_story_screen.dart';
import 'package:story_app/views/screen/login_screen.dart';
import 'package:story_app/views/screen/register_screen.dart';
import 'package:story_app/views/screen/splash_screen.dart';
import 'package:story_app/views/screen/story_detail_screen.dart';
import 'package:story_app/views/screen/story_list_screen.dart';

class MyRouterDelegate extends RouterDelegate
    with ChangeNotifier, PopNavigatorRouterDelegateMixin {
  final GlobalKey<NavigatorState> _navigatorKey;

  MyRouterDelegate() : _navigatorKey = GlobalKey<NavigatorState>() {
    _init();
  }

  _init() async {
    isLoggedIn = await AuthRepository.isLoggedIn();

    notifyListeners();
  }

  @override
  GlobalKey<NavigatorState> get navigatorKey => _navigatorKey;

  String? selectedStory;

  List<Page> historyStack = [];
  bool? isLoggedIn;
  bool isRegister = false;
  bool isAddStory = false;

  @override
  Widget build(BuildContext context) {
    if (isLoggedIn == null) {
      historyStack = _splashStack;
    } else if (isLoggedIn == true) {
      historyStack = _loggedInStack(context);
    } else {
      historyStack = _loggedOutStack;
    }
    return Navigator(
      key: navigatorKey,

      pages: historyStack,
      onDidRemovePage: (page) {
        isRegister = false;
        selectedStory = null;
        isAddStory = false;
        notifyListeners();
      },
    );
  }

  @override
  Future<void> setNewRoutePath(configuration) async {
    /* Do Nothing */
  }

  List<Page> get _splashStack => const [
    MaterialPage(key: ValueKey("SplashScreen"), child: SplashScreen()),
  ];

  List<Page> get _loggedOutStack => [
    MaterialPage(
      key: const ValueKey("LoginPage"),
      child: LoginScreen(
        onLogin: () {
          isLoggedIn = true;
          notifyListeners();
        },
        onRegister: () {
          isRegister = true;
          notifyListeners();
        },
      ),
    ),
    if (isRegister == true)
      MaterialPage(
        key: const ValueKey("RegisterPage"),
        child: RegisterScreen(
          onRegister: () {
            isRegister = false;
            notifyListeners();
          },
          onLogin: () {
            isRegister = false;
            notifyListeners();
          },
        ),
      ),
  ];

  List<Page> _loggedInStack(BuildContext context) => [
    MaterialPage(
      key: const ValueKey("StoryListPage"),
      child: StoryListScreen(
        onTapped: (String quoteId) {
          selectedStory = quoteId;
          notifyListeners();
        },

        onLogout: () {
          isLoggedIn = false;
          notifyListeners();
        },

        onAddStory: () {
          isAddStory = true;
          notifyListeners();
        },
      ),
    ),
    if (selectedStory != null)
      MaterialPage(
        key: ValueKey(selectedStory),
        child: ChangeNotifierProvider(
          create: (context) => StoryProvider(storiesService, selectedStory!),
          child: const StoryDetailsScreen(),
        ),
      ),
    if (isAddStory)
      MaterialPage(
        key: const ValueKey("AddStoryPage"),
        child: ChangeNotifierProvider(
          create: (context) => AddStoryProvider(storiesService: storiesService),
          child: AddStoryScreen(
            onAddStory: () async {
              isAddStory = false;
              StoriesProvider storiesProvider = context.read<StoriesProvider>();
              await storiesProvider.refreshStories();
              notifyListeners();
            },
          ),
        ),
      ),
  ];
}
