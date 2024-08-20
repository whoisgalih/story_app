import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:story_app/data/api/auth_service.dart';
import 'package:story_app/data/api/stories_service.dart';
import 'package:story_app/provider/auth_provider.dart';
import 'package:story_app/provider/stories_provider.dart';
import 'package:story_app/routes/router_delegate.dart';

import 'package:http/http.dart' as http;
import 'package:story_app/themes/colors.dart';

import 'dart:io';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

void main() {
  HttpOverrides.global = MyHttpOverrides();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

final http.Client client = http.Client();

final AuthService authService = AuthService(client: client);
final StoriesService storiesService = StoriesService(client: client);

class _MyAppState extends State<MyApp> {
  /// todo 6: add variable for create instance
  late MyRouterDelegate myRouterDelegate;
  // late AuthProvider authProvider;

  @override
  void initState() {
    super.initState();
    // final authRepository = AuthRepository();

    // authProvider = AuthProvider(authRepository, authService);

    /// todo 7: inject auth to router delegate
    myRouterDelegate = MyRouterDelegate();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => StoriesProvider(
            storiesService,
          ),
        ),
        ChangeNotifierProvider(
          create: (context) => AuthProvider(
            authService,
          ),
        ),
      ],
      child: MaterialApp(
        title: 'Story App',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSwatch(
            primarySwatch: primaryColor,
            accentColor: accentColor,
            brightness: Brightness.light,
          ),
          scaffoldBackgroundColor: primaryColor[50],
          visualDensity: VisualDensity.adaptivePlatformDensity,
          progressIndicatorTheme: const ProgressIndicatorThemeData(
            color: accentColor,
          ),
          appBarTheme: const AppBarTheme(elevation: 0),
          textSelectionTheme: TextSelectionThemeData(
            cursorColor: primaryColor[300],
          ),
          floatingActionButtonTheme: const FloatingActionButtonThemeData(
            elevation: 0,
          ),
          inputDecorationTheme: InputDecorationTheme(
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(width: 1, color: primaryColor[300]!),
              borderRadius: const BorderRadius.all(Radius.circular(10)),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(width: 1, color: primaryColor[300]!),
              borderRadius: const BorderRadius.all(Radius.circular(10)),
            ),
            errorBorder: OutlineInputBorder(
              borderSide: BorderSide(width: 1, color: primaryColor[300]!),
              borderRadius: const BorderRadius.all(Radius.circular(10)),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderSide: BorderSide(width: 1, color: primaryColor[300]!),
              borderRadius: const BorderRadius.all(Radius.circular(10)),
            ),
            contentPadding: const EdgeInsets.all(12),
            prefixIconColor: primaryColor,
          ),
        ),
        home: Router(
          routerDelegate: myRouterDelegate,
          backButtonDispatcher: RootBackButtonDispatcher(),
        ),
      ),
    );
  }
}
