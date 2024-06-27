import 'package:dmp3s/auth/page.dart';
import 'package:dmp3s/common/api/relay/pool.dart';
import 'package:dmp3s/core/page.dart';
import 'package:flutter/services.dart';
import 'package:nostr/nostr.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  // Initialize the relay pool
  RelayPool.instance;

  // Run the app
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<StatefulWidget> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Keychain? _keychain;
  ThemeMode _themeMode = ThemeMode.light;

  Future<void> _retrieveKey() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    if (sharedPreferences.containsKey('nostr-private-key')) {
      setState(() => _keychain = Keychain(sharedPreferences.getString('nostr-private-key') ?? ""));
    }

    if (sharedPreferences.containsKey('theme')) {
      setState(() => _themeMode = sharedPreferences.getBool('theme')! ? ThemeMode.dark : ThemeMode.light);
    }
  }

  void _changeTheme() {
    setState(() => _themeMode = _themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark);

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: _themeMode == ThemeMode.light ? Brightness.dark : Brightness.light,
    ));

    SharedPreferences.getInstance().then((sharedPreferences) {
      sharedPreferences.setBool('theme', _themeMode == ThemeMode.dark);
    });
  }

  @override
  void initState() {
    _retrieveKey().then((_) {
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: _themeMode == ThemeMode.light ? Brightness.dark : Brightness.light,
      ));
    });

    super.initState();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        final FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
          currentFocus.focusedChild!.unfocus();
        }
      },
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFFF7349)),
          useMaterial3: true,
          scaffoldBackgroundColor: const Color(0xFFFFFFFF),
          bottomSheetTheme: BottomSheetThemeData(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14.0),
            ),
          ),
          bottomNavigationBarTheme: const BottomNavigationBarThemeData(
            backgroundColor: Color(0xFFFFFFFF),
            selectedIconTheme: IconThemeData(
              color: Color(0xFF1A1A1A),
              size: 24.0,
            ),
            unselectedIconTheme: IconThemeData(
              color: Color(0xFF1A1A1A),
              size: 24.0,
            ),
            showSelectedLabels: false,
            showUnselectedLabels: false,
            type: BottomNavigationBarType.fixed,
          ),
          textSelectionTheme: TextSelectionThemeData(
            cursorColor: const Color(0xFFFF7349),
            selectionColor: const Color(0xFFFF7349).withOpacity(0.2),
            selectionHandleColor: const Color(0xFFFF7349),
          ),
        ),
        darkTheme: ThemeData.dark(useMaterial3: true).copyWith(
          colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFFF7349)),
          scaffoldBackgroundColor: const Color(0xFF000000),
          bottomSheetTheme: BottomSheetThemeData(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14.0),
            ),
          ),
          bottomNavigationBarTheme: const BottomNavigationBarThemeData(
            backgroundColor: Color(0xFF000000),
            selectedIconTheme: IconThemeData(
              color: Color(0xFFEEEEEE),
              size: 24.0,
            ),
            unselectedIconTheme: IconThemeData(
              color: Color(0xFFEEEEEE),
              size: 24.0,
            ),
            showSelectedLabels: false,
            showUnselectedLabels: false,
            type: BottomNavigationBarType.fixed,
          ),
          textSelectionTheme: TextSelectionThemeData(
            cursorColor: const Color(0xFFFF7349),
            selectionColor: const Color(0xFFFF7349).withOpacity(0.2),
            selectionHandleColor: const Color(0xFFFF7349),
          ),
        ),
        themeMode: _themeMode,
        home: _keychain == null
            ? AuthPage(
                onLogIn: (keychain) => setState(() => _keychain = keychain),
                getTheme: () => _themeMode,
              )
            : CorePage(
                onLogOut: () => setState(() => _keychain = null),
                getTheme: () => _themeMode,
                changeTheme: _changeTheme,
                keychain: _keychain!,
              ),
      ),
    );
  }
}
