import 'package:dmp3s/auth/bottom_sheet.dart';
import 'package:dmp3s/auth/step.dart';
import 'package:dmp3s/common/style/button.dart';
import 'package:flutter/material.dart';
import 'package:nostr/nostr.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key, required this.onLogIn, required this.getTheme});

  final void Function(Keychain) onLogIn;
  final ThemeMode Function() getTheme;

  @override
  State<StatefulWidget> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: FractionallySizedBox(
            widthFactor: 0.8,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FractionallySizedBox(
                  widthFactor: 0.6,
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 256.0),
                    child: AspectRatio(
                      aspectRatio: 1.0,
                      child: Image.asset(
                        "res/images/campfire.png",
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 80.0),
                SizedBox(
                  width: double.infinity,
                  height: 60.0,
                  child: FilledButton(
                    onPressed: () async {
                      final keychain = await AuthPageBottomSheet(
                        step: AuthStep.signUp,
                        getTheme: widget.getTheme,
                      ).show(context);
                      if (keychain != null) widget.onLogIn(keychain);
                    },
                    style: accentButtonStyle,
                    child: Text(
                      "Sign up",
                      style: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                        color: widget.getTheme() == ThemeMode.dark ? Colors.black : Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20.0),
                SizedBox(
                  width: double.infinity,
                  height: 60.0,
                  child: FilledButton(
                    onPressed: () async {
                      final keychain = await AuthPageBottomSheet(
                        step: AuthStep.logIn,
                        getTheme: widget.getTheme,
                      ).show(context);
                      if (keychain != null) widget.onLogIn(keychain);
                    },
                    style: widget.getTheme() == ThemeMode.dark ? defaultButtonStyleDark : defaultButtonStyle,
                    child: Text(
                      "Log in",
                      style: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                        color: widget.getTheme() == ThemeMode.dark ? Colors.white : Colors.white,
                      ),
                    ),
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
