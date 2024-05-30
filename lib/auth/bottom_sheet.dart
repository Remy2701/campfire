import 'package:dmp3s/auth/step.dart';
import 'package:dmp3s/common/api/relay/pool.dart';
import 'package:dmp3s/common/model/user_info.dart';
import 'package:dmp3s/common/style/button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_boxicons/flutter_boxicons.dart';
import 'package:nostr/nostr.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthPageBottomSheet extends StatefulWidget {
  const AuthPageBottomSheet({
    super.key,
    required this.step,
    required this.getTheme,
  });

  final AuthStep step;
  final ThemeMode Function() getTheme;

  Future<Keychain?> show(BuildContext context) async {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: getTheme() == ThemeMode.dark ? const Color(0xFF1A1A1A) : const Color(0xFFFFFFFF),
      builder: (ctx) => this,
    );
  }

  @override
  State<StatefulWidget> createState() => _AuthPageBottomSheetState();
}

class _AuthPageBottomSheetState extends State<AuthPageBottomSheet> {
  bool _anonymous = false;
  final TextEditingController _firstNameController = TextEditingController();
  final FocusNode _firstNameFocusNode = FocusNode();
  final TextEditingController _lastNameController = TextEditingController();
  final FocusNode _lastNameFocusNode = FocusNode();
  final TextEditingController _privateKeyController = TextEditingController();
  final FocusNode _privateKeyFocusNode = FocusNode();
  final WidgetStatesController _signUpButtonState = WidgetStatesController({WidgetState.disabled});
  final WidgetStatesController _logInButtonState = WidgetStatesController();

  late AuthStep _step = widget.step;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((duration) {
      _signUpButtonState.update(
        WidgetState.disabled,
        !_anonymous && (_firstNameController.text.isEmpty || _lastNameController.text.isEmpty),
      );
      _logInButtonState.update(
        WidgetState.disabled,
        _privateKeyController.text.length != 64,
      );
    });
  }

  void _onSignUp() async {
    if (_signUpButtonState.value.contains(WidgetState.disabled)) {
      return;
    }
    final keychain = Keychain.generate();
    final sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setString('nostr-private-key', keychain.private);

    if (!_anonymous) {
      await RelayPool.instance.sendEvent(
        UserInfo(
          firstName: _firstNameController.text,
          lastName: _lastNameController.text,
        ).toEvent(keychain),
      );
    } else {
      await RelayPool.instance.sendEvent(
        const UserInfo(
          anonymous: true,
        ).toEvent(keychain),
      );
    }

    // ignore: use_build_context_synchronously
    Navigator.pop(context, keychain);
  }

  void _onLogIn() async {
    if (_logInButtonState.value.contains(WidgetState.disabled)) {
      return;
    }
    final keychain = Keychain(_privateKeyController.text);
    final sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setString('nostr-private-key', keychain.private);
    // ignore: use_build_context_synchronously
    Navigator.pop(context, keychain);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: DraggableScrollableSheet(
        minChildSize: 0.5,
        initialChildSize: 0.5,
        expand: false,
        builder: (context, controller) => ListView(
          controller: controller,
          physics: const BouncingScrollPhysics(),
          children: [
            const SizedBox(height: 8.0),
            SizedBox(
              height: 40.0,
              child: Stack(
                children: [
                  Center(
                    child: Text(
                      _step.toText(),
                      style: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.w500,
                        color: widget.getTheme() == ThemeMode.dark ? const Color(0xFFFFFFFF) : const Color(0xFF1A1A1A),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 10,
                    top: 0,
                    child: Visibility(
                      visible: widget.step != _step,
                      child: SizedBox(
                        width: 32.0,
                        height: 32.0,
                        child: IconButton(
                          onPressed: () {
                            setState(() {
                              _step = widget.step;
                            });
                          },
                          padding: const EdgeInsets.all(0.0),
                          iconSize: 24.0,
                          highlightColor: const Color(0xFFFF7349).withOpacity(0.2),
                          color:
                              widget.getTheme() == ThemeMode.dark ? const Color(0xFFFFFFFF) : const Color(0xFF1A1A1A),
                          icon: const Icon(Boxicons.bxs_chevron_left),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24.0),
            ...switch (_step) {
              AuthStep.signUp => [
                  FractionallySizedBox(
                    widthFactor: 0.9,
                    child: SizedBox(
                      height: 55.0,
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _firstNameController,
                              focusNode: _firstNameFocusNode,
                              onChanged: (value) {
                                _signUpButtonState.update(
                                  WidgetState.disabled,
                                  !_anonymous && (value.isEmpty || _lastNameController.text.isEmpty),
                                );
                              },
                              decoration: defaultTextField(
                                labelText: "First name",
                                position: Position.startLeft,
                                theme: widget.getTheme(),
                              ),
                              cursorColor: const Color(0xFFFF7349),
                            ),
                          ),
                          const SizedBox(width: 4.0),
                          Expanded(
                            child: TextField(
                              controller: _lastNameController,
                              focusNode: _lastNameFocusNode,
                              onChanged: (value) {
                                _signUpButtonState.update(
                                  WidgetState.disabled,
                                  !_anonymous && (_firstNameController.text.isEmpty || value.isEmpty),
                                );
                              },
                              decoration: defaultTextField(
                                labelText: "Last name",
                                position: Position.startRight,
                                theme: widget.getTheme(),
                              ),
                              cursorColor: const Color(0xFFFF7349),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 4.0),
                  FractionallySizedBox(
                    widthFactor: 0.9,
                    child: SizedBox(
                      height: 55.0,
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12.0),
                            height: double.infinity,
                            decoration: BoxDecoration(
                              color: widget.getTheme() == ThemeMode.dark
                                  ? const Color(0xFF000000)
                                  : const Color(0xFFEEEEEE),
                              borderRadius: const BorderRadius.only(
                                bottomLeft: Radius.circular(8.0),
                              ),
                            ),
                            child: Theme(
                              data: ThemeData(
                                switchTheme: SwitchThemeData(
                                  thumbColor: WidgetStateColor.resolveWith(
                                    (states) {
                                      if (states.contains(WidgetState.selected)) {
                                        return const Color(0xFFFF7349);
                                      } else {
                                        if (widget.getTheme() == ThemeMode.dark) {
                                          return const Color(0xFFD9D9D9);
                                        } else {
                                          return const Color(0xFF9D9D9D);
                                        }
                                      }
                                    },
                                  ),
                                  trackColor: WidgetStateColor.resolveWith(
                                    (states) {
                                      if (states.contains(WidgetState.selected)) {
                                        return const Color(0xFFFF7349).withOpacity(0.2);
                                      } else {
                                        if (widget.getTheme() == ThemeMode.dark) {
                                          return const Color(0xFFD9D9D9).withOpacity(0.1);
                                        } else {
                                          return const Color(0xFF9D9D9D).withOpacity(0.1);
                                        }
                                      }
                                    },
                                  ),
                                  thumbIcon: WidgetStateProperty.resolveWith(
                                    (states) {
                                      if (states.contains(WidgetState.selected)) {
                                        return const Icon(
                                          Boxicons.bx_check,
                                          color: Color(0xFFFFFFFF),
                                        );
                                      } else {
                                        return Icon(
                                          Boxicons.bx_x,
                                          color: widget.getTheme() == ThemeMode.dark
                                              ? const Color(0xFF000000)
                                              : const Color(0xFFFFFFFF),
                                        );
                                      }
                                    },
                                  ),
                                  trackOutlineColor: WidgetStateColor.resolveWith(
                                    (states) {
                                      if (states.contains(WidgetState.selected)) {
                                        return const Color(0xFFFF7349);
                                      } else {
                                        if (widget.getTheme() == ThemeMode.dark) {
                                          return const Color(0xFFD9D9D9);
                                        } else {
                                          return const Color(0xFF9D9D9D);
                                        }
                                      }
                                    },
                                  ),
                                ),
                              ),
                              child: Switch(
                                value: _anonymous,
                                onChanged: (value) {
                                  _signUpButtonState.update(
                                    WidgetState.disabled,
                                    !value && (_firstNameController.text.isEmpty || _lastNameController.text.isEmpty),
                                  );
                                  setState(() => _anonymous = value);
                                },
                              ),
                            ),
                          ),
                          const SizedBox(width: 4.0),
                          Expanded(
                            child: Container(
                              height: double.infinity,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12.0,
                              ),
                              decoration: BoxDecoration(
                                color: widget.getTheme() == ThemeMode.dark
                                    ? const Color(0xFF000000)
                                    : const Color(0xFFEEEEEE),
                                borderRadius: const BorderRadius.only(
                                  bottomRight: Radius.circular(8.0),
                                ),
                              ),
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Sign up as anonymous",
                                style: TextStyle(
                                  color: widget.getTheme() == ThemeMode.dark
                                      ? const Color(0xFFEEEEEE)
                                      : const Color(0xFF1A1A1A),
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 32.0),
                  Center(
                    child: SizedBox(
                      height: 55.0,
                      width: 220.0,
                      child: FilledButton(
                        onPressed: _onSignUp,
                        statesController: _signUpButtonState,
                        style: widget.getTheme() == ThemeMode.dark ? accentButtonStyleDark : accentButtonStyle,
                        child: const Text(
                          "Sign up",
                          style: TextStyle(
                            fontSize: 22.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Center(
                    child: Theme(
                      data: ThemeData(
                        textButtonTheme: TextButtonThemeData(
                          style: ButtonStyle(
                            overlayColor: WidgetStateColor.resolveWith(
                              (states) => const Color(0x0FE27857),
                            ),
                            shape: WidgetStateProperty.resolveWith(
                              (states) => RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                            ),
                          ),
                        ),
                      ),
                      child: TextButton(
                        onPressed: () {
                          setState(() => _step = AuthStep.logIn);
                        },
                        child: Text(
                          "Already have an account? Log in",
                          style: TextStyle(
                            color:
                                widget.getTheme() == ThemeMode.dark ? const Color(0xFFFFFFFF) : const Color(0xFF1A1A1A),
                            fontSize: 16.0,
                            fontWeight: FontWeight.w500,
                            decoration: TextDecoration.underline,
                            decorationColor:
                                widget.getTheme() == ThemeMode.dark ? const Color(0xFFFFFFFF) : const Color(0xFF1A1A1A),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              AuthStep.logIn => [
                  FractionallySizedBox(
                    widthFactor: 0.9,
                    child: SizedBox(
                      height: 55.0,
                      child: TextField(
                        controller: _privateKeyController,
                        focusNode: _privateKeyFocusNode,
                        onChanged: (value) {
                          _logInButtonState.update(
                            WidgetState.disabled,
                            _privateKeyController.text.length != 64,
                          );
                        },
                        decoration: defaultTextField(
                          labelText: "Private key (nsec...)",
                          position: Position.single,
                          theme: widget.getTheme(),
                        ),
                        cursorColor: const Color(0xFFFF7349),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32.0),
                  Center(
                    child: SizedBox(
                      height: 55.0,
                      width: 180.0,
                      child: FilledButton(
                        onPressed: _onLogIn,
                        statesController: _logInButtonState,
                        style: widget.getTheme() == ThemeMode.dark ? accentButtonStyleDark : accentButtonStyle,
                        child: const Text(
                          "Log in",
                          style: TextStyle(
                            fontSize: 22.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
            },
          ],
        ),
      ),
    );
  }
}
