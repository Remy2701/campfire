import 'package:dmp3s/common/api/relay/pool.dart';
import 'package:dmp3s/common/model/challenge.dart';
import 'package:dmp3s/common/widget/challenge.dart';
import 'package:flutter/material.dart';
import 'package:nostr/nostr.dart';

/// The favorite page of the application
class FavoritePage extends StatefulWidget {
  const FavoritePage({
    super.key,
    required this.getTheme,
    required this.keychain,
  });

  /// The function to get the current theme of the application.
  final ThemeMode Function() getTheme;

  /// The keychain of the user.
  final Keychain keychain;

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  final List<Challenge> _challenges = [];

  @override
  void initState() {
    RelayPool.instance.listen(
      request: Challenge.getLikeReactions(author: widget.keychain),
      onEvent: (event) {
        final id = event.tags.firstWhere((tag) => tag[0] == "e").elementAt(1);
        RelayPool.instance.listen(
          request: Challenge.getChallengeWithIdRequest(id: id),
          onEvent: (event) {
            if (!mounted) return;
            setState(() {
              _challenges.add(Challenge.fromEvent(event));
            });
          },
        );
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: FractionallySizedBox(
        widthFactor: 0.9,
        child: ListView(
          children: [
            const SizedBox(height: 10.0),
            Center(
              child: Text(
                "Favorite Challenges",
                style: TextStyle(
                  fontSize: 20.0,
                  color: widget.getTheme() == ThemeMode.dark ? const Color(0xFFEEEEEE) : const Color(0xFF1A1A1A),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            ..._challenges.map(
              (e) => Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: ChallengeCard(
                  keychain: widget.keychain,
                  getTheme: widget.getTheme,
                  challenge: e,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
