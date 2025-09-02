{{#enableLocalization}}
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:{{packageName}}/l10n/app_localizations.dart';
{{/enableLocalization}}
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:{{packageName}}/data/api/auth_service.dart';
import 'package:{{packageName}}/data/api/stories_service.dart';
import 'package:{{packageName}}/provider/auth_provider.dart';
import 'package:{{packageName}}/provider/stories_provider.dart';
import 'package:{{packageName}}/routes/router_delegate.dart';
import 'package:http/http.dart' as http;
import 'package:{{packageName}}/themes/colors.dart';
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
  runApp(const {{appName.pascalCase()}}());
}

class {{appName.pascalCase()}} extends StatefulWidget {
  const {{appName.pascalCase()}}({super.key});

  @override
  State<{{appName.pascalCase()}}> createState() => _{{appName.pascalCase()}}State();
}

final http.Client client = http.Client();
final AuthService authService = AuthService(client: client);
final StoriesService storiesService = StoriesService(client: client);

class _{{appName.pascalCase()}}State extends State<{{appName.pascalCase()}}> {
  late MyRouterDelegate myRouterDelegate;

  @override
  void initState() {
    super.initState();
    myRouterDelegate = MyRouterDelegate();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => StoriesProvider(storiesService: storiesService),
        ),
        ChangeNotifierProvider(create: (context) => AuthProvider(authService)),
      ],
      child: MaterialApp(
        title: '{{appName.titleCase()}}',
        {{#enableLocalization}}
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [Locale('id', ''), Locale('en', '')],
        {{/enableLocalization}}
        theme: ThemeData(
          colorScheme: ColorScheme.fromSwatch(
            primarySwatch: primaryColor,
            accentColor: accentColor,
            brightness: Brightness.light,
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(foregroundColor: accentColor),
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
          ),
        ),
        home: Router(
          routerDelegate: myRouterDelegate,
        ),
      ),
    );
  }
}