import 'package:story_app/model/user.dart';
import 'package:story_app/provider/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:story_app/themes/colors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

/// todo 14: create LoginScreen
class LoginScreen extends StatefulWidget {
  final Function() onLogin;
  final Function() onRegister;

  const LoginScreen({
    super.key,
    required this.onLogin,
    required this.onRegister,
  });

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();

  final passwordController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    AuthProvider authProvider = context.watch<AuthProvider>();
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.login),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 300),

          /// todo 16: add Form widget to handle form component, and
          /// add component key
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                /// todo 15: add component like TextFormField and Button,
                /// add component like controller, hint, obscureText, and onPressed,
                /// dispose that controller, and
                /// add validation to validate the text.
                TextFormField(
                  controller: emailController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return AppLocalizations.of(context)!.pleaseEnterYourEmail;
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    hintText: AppLocalizations.of(context)!.email,
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: AppLocalizations.of(context)!.password,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return AppLocalizations.of(context)!
                          .pleaseEnterYourPassword;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 8),

                authProvider.isLoadingLogin
                    ? const Center(child: CircularProgressIndicator())
                    : ElevatedButton(
                        onPressed: () async {
                          if (formKey.currentState!.validate()) {
                            final scaffoldMessenger =
                                ScaffoldMessenger.of(context);
                            final User user = User(
                              email: emailController.text,
                              password: passwordController.text,
                            );

                            final result = await authProvider.login(user);

                            if (result) {
                              widget.onLogin();
                            }

                            if (authProvider.loginMessage.isNotEmpty) {
                              scaffoldMessenger.showSnackBar(
                                SnackBar(
                                  content: Text(authProvider.loginMessage == ""
                                      ? AppLocalizations.of(context)!
                                          .loginSuccess
                                      : authProvider.loginMessage),
                                ),
                              );
                            }
                          }
                        },
                        child: Text(
                          AppLocalizations.of(context)!.login,
                        ),
                      ),

                const SizedBox(height: 8),

                /// todo 19: update the function when button is tapped.
                OutlinedButton(
                  onPressed: () => widget.onRegister(),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: primaryColor[950],
                  ),
                  child: Text(
                    AppLocalizations.of(context)!.register,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
