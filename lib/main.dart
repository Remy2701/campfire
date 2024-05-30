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

// class MyHomePage extends StatefulWidget {
//   const MyHomePage({super.key});

//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   final List<Event> _events = [];

//   Future<void> _listenToEvents() async {
//     // https://nostrocket.org/nr/Nostrocket/problems/0ce1c7fdea4188c066a7f74465b87022e4051464082523f28e1da96525594ea7?tab=discussion
//     Request requestWithFilter = Request(generate64RandomHexChars(), [
//       Filter(
//         kinds: [1971],
//         limit: 15,
//       )
//     ]);

//     WebSocketChannel webSocket = WebSocketChannel.connect(
//       Uri.parse(Relay.URL), // or any nostr relay
//     );

//     await webSocket.ready;

//     webSocket.sink.add(requestWithFilter.serialize());

//     // Listen for events from the WebSocket server
//     await Future.delayed(Duration(seconds: 1));
//     webSocket.stream.listen((event) {
//       final message = Message.deserialize(event);
//       if (message.messageType == MessageType.eose) return;
//       print("Found event!");
//       _events.add(message.message as Event);
//       setState(() {});
//     });

//     // Close the WebSocket connection
//     //print("Connection stopped!");
//     //await webSocket.sink.close();
//   }

//   @override
//   void initState() {
//     super.initState();
//     _listenToEvents();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: ListView.builder(
//           padding: const EdgeInsets.only(top: 10.0),
//           itemCount: _events.length,
//           itemBuilder: (context, index) {
//             final idx0 = _events[index].content.indexOf("[ ");
//             final idx1 = _events[index].content.indexOf(" ]");

//             final List<String> texts = [];
//             for (final tag in _events[index].tags) {
//               if (tag.isEmpty) continue;
//               if (tag[0] != "text") continue;
//               if (tag.length < 2) continue;
//               texts.add(tag[1]);
//             }

//             return GestureDetector(
//               onTap: () {
//                 showModalBottomSheet(
//                   context: context,
//                   builder: (context) => Padding(
//                     padding: const EdgeInsets.symmetric(
//                       horizontal: 8.0,
//                     ),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         const SizedBox(
//                           height: 20.0,
//                         ),
//                         Table(
//                           columnWidths: const {
//                             0: FixedColumnWidth(75),
//                           },
//                           children: [
//                             TableRow(children: [
//                               const Text(
//                                 "id",
//                                 style: TextStyle(
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                               Text(
//                                 _events[index].id,
//                                 style: const TextStyle(
//                                   fontWeight: FontWeight.normal,
//                                 ),
//                               ),
//                             ]),
//                             TableRow(children: [
//                               const Text(
//                                 "created at",
//                                 style: TextStyle(
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                               Text(
//                                 DateTime.fromMillisecondsSinceEpoch(_events[index].createdAt * 1000).toString(),
//                                 style: const TextStyle(
//                                   fontWeight: FontWeight.normal,
//                                 ),
//                               ),
//                             ]),
//                             TableRow(children: [
//                               const Text(
//                                 "kind",
//                                 style: TextStyle(
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                               Text(
//                                 _events[index].kind.toString(),
//                                 style: const TextStyle(
//                                   fontWeight: FontWeight.normal,
//                                 ),
//                               ),
//                             ]),
//                             TableRow(
//                               children: [
//                                 const Text(
//                                   "pubkey",
//                                   style: TextStyle(
//                                     fontWeight: FontWeight.bold,
//                                   ),
//                                 ),
//                                 Text(
//                                   _events[index].pubkey,
//                                   style: const TextStyle(
//                                     fontWeight: FontWeight.normal,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                 );
//               },
//               child: Container(
//                 margin: const EdgeInsets.only(left: 10.0, right: 10.0, bottom: 10.0),
//                 padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 2.0),
//                 decoration: BoxDecoration(
//                   color: Colors.black12,
//                   borderRadius: BorderRadius.circular(4.0),
//                 ),
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       texts.isEmpty ? "" : texts[0],
//                       style: const TextStyle(
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     ...texts.sublist(1).map(
//                           (e) => Text(
//                             e,
//                             textAlign: TextAlign.justify,
//                             style: const TextStyle(
//                               fontWeight: FontWeight.normal,
//                             ),
//                           ),
//                         ),
//                   ],
//                 ),
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }
// }
