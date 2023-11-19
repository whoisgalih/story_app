import 'package:story_app/commons/RequestError.dart';
import 'package:story_app/data/api/auth_service.dart';
import 'package:story_app/data/db/auth_repository.dart';
import 'package:flutter/material.dart';

import '../model/user.dart';

/// todo 5: create Auth Provider to handle auth process
class AuthProvider extends ChangeNotifier {
  final AuthRepository authRepository;
  final AuthService authService;

  AuthProvider(this.authRepository, this.authService);

  bool isLoadingLogin = false;
  bool isLoadingLogout = false;
  bool isLoadingRegister = false;
  bool isLoggedIn = false;
  bool isRegistered = false;

  // Message
  String loginMessage = "";
  String registerMessage = "";

  Future<bool> login(User user) async {
    isLoadingLogin = true;
    notifyListeners();

    try {
      final Map<String, dynamic> responseJson = await authService.login(user);
      await authRepository.setToken(responseJson['loginResult']['token']);
      isLoggedIn = await authRepository.isLoggedIn();
      loginMessage = "Login success";
    } on RequestException catch (e) {
      isLoggedIn = false;
      loginMessage = e.message;
    }

    isLoadingLogin = false;
    notifyListeners();

    return isLoggedIn;
  }

  Future<bool> logout() async {
    isLoadingLogout = true;
    notifyListeners();

    await authRepository.removeToken();
    isLoggedIn = await authRepository.isLoggedIn();

    isLoadingLogout = false;
    notifyListeners();

    return !isLoggedIn;
  }

  Future<bool> register(User user) async {
    isLoadingRegister = true;
    notifyListeners();

    try {
      await authService.register(user);
      isRegistered = true;
      registerMessage = "Register success";
    } on RequestException catch (e) {
      isRegistered = false;
      registerMessage = e.message;
    }

    isLoadingRegister = false;
    notifyListeners();

    return isRegistered;
  }
}
