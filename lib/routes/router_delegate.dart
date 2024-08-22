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
  // final AuthRepository authRepository;

  // late StoriesProvider storiesProvider;

  MyRouterDelegate(
      // this.authRepository,
      )
      : _navigatorKey = GlobalKey<NavigatorState>() {
    /// todo 9: create initial function to check user logged in.
    _init();
    // storiesProvider = StoriesProvider(
    //   authRepository,
    //   storiesService,
    // );
  }

  _init() async {
    isLoggedIn = await AuthRepository.isLoggedIn();

    notifyListeners();
  }

  @override
  GlobalKey<NavigatorState> get navigatorKey => _navigatorKey;

  String? selectedStory;

  /// todo 8: add historyStack variable to maintaining the stack
  List<Page> historyStack = [];
  bool? isLoggedIn;
  bool isRegister = false;
  bool isAddStory = false;

  @override
  Widget build(BuildContext context) {
    /// todo 11: create conditional statement to declare historyStack based on  user logged in.
    if (isLoggedIn == null) {
      historyStack = _splashStack;
    } else if (isLoggedIn == true) {
      historyStack = _loggedInStack(context);
    } else {
      historyStack = _loggedOutStack;
    }
    return Navigator(
      key: navigatorKey,

      /// todo 10: change the list with historyStack
      pages: historyStack,
      onPopPage: (route, result) {
        final didPop = route.didPop(result);
        if (!didPop) {
          return false;
        }

        // if (isLoggedIn == true) {
        //   storiesProvider.getStories();
        // }

        isRegister = false;
        selectedStory = null;
        isAddStory = false;
        notifyListeners();

        return true;
      },
    );
  }

  @override
  Future<void> setNewRoutePath(configuration) async {
    /* Do Nothing */
  }

  /// todo 12: add these variable to support history stack
  List<Page> get _splashStack => const [
        MaterialPage(
          key: ValueKey("SplashScreen"),
          child: SplashScreen(),
        ),
      ];

  List<Page> get _loggedOutStack => [
        MaterialPage(
          key: const ValueKey("LoginPage"),
          child: LoginScreen(
            /// todo 17: add onLogin and onRegister method to update the state
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

            /// todo 21: add onLogout method to update the state and
            /// create a logout button
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
              create: (context) => StoryProvider(
                storiesService,
                selectedStory!,
              ),
              child: const StoryDetailsScreen(),
            ),
          ),
        if (isAddStory)
          MaterialPage(
            key: const ValueKey("AddStoryPage"),
            child: ChangeNotifierProvider(
              create: (context) => AddStoryProvider(
                storiesService: storiesService,
              ),
              child: AddStoryScreen(
                onAddStory: () async {
                  isAddStory = false;
                  StoriesProvider storiesProvider =
                      context.read<StoriesProvider>();
                  await storiesProvider.refreshStories();
                  notifyListeners();
                },
              ),
            ),
          )
      ];
}
