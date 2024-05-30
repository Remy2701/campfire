import 'package:dmp3s/core/discover/page.dart';
import 'package:dmp3s/core/favorite/page.dart';
import 'package:dmp3s/core/my_challenges/page.dart';
import 'package:dmp3s/core/profile/page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_boxicons/flutter_boxicons.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:nostr/nostr.dart';

class CorePage extends StatefulWidget {
  const CorePage({
    super.key,
    required this.onLogOut,
    required this.keychain,
    required this.getTheme,
    required this.changeTheme,
  });

  final void Function() onLogOut;
  final Keychain keychain;
  final ThemeMode Function() getTheme;
  final void Function() changeTheme;

  @override
  State<CorePage> createState() => _CorePageState();
}

class _CorePageState extends State<CorePage> {
  int _currentIndex = 0;
  final PageController _pageController = PageController();

  /// The callback executed when the user request to log out.
  void _onLogOut() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.remove('nostr-private-key');
    widget.onLogOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
            _pageController.animateToPage(
              index,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            );
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Boxicons.bx_compass),
            activeIcon: Icon(Boxicons.bxs_compass),
            label: "",
          ),
          BottomNavigationBarItem(
            icon: Icon(Boxicons.bx_heart),
            activeIcon: Icon(Boxicons.bxs_heart),
            label: "",
          ),
          BottomNavigationBarItem(
            icon: Icon(Boxicons.bx_trophy),
            activeIcon: Icon(Boxicons.bxs_trophy),
            label: "",
          ),
          BottomNavigationBarItem(
            icon: Icon(Boxicons.bx_user),
            activeIcon: Icon(Boxicons.bxs_user),
            label: "",
          ),
        ],
      ),
      body: PageView.builder(
        itemCount: 4,
        onPageChanged: (value) {
          setState(() => _currentIndex = value);
        },
        controller: _pageController,
        itemBuilder: (ctx, index) => switch (index) {
          0 => DiscoverPage(
              getTheme: widget.getTheme,
              keychain: widget.keychain,
            ),
          1 => FavoritePage(
              keychain: widget.keychain,
              getTheme: widget.getTheme,
            ),
          2 => MyChallengePage(
              keychain: widget.keychain,
              getTheme: widget.getTheme,
            ),
          _ => MyProfilePage(
              keychain: widget.keychain,
              onLogOut: _onLogOut,
              pageController: _pageController,
              getTheme: widget.getTheme,
              changeTheme: widget.changeTheme,
            ),
        },
      ),
    );
  }
}
