import 'package:collection/collection.dart';
import 'package:dmp3s/common/api/relay/pool.dart';
import 'package:dmp3s/common/model/challenge.dart';
import 'package:dmp3s/common/widget/challenge.dart';
import 'package:flutter/material.dart';
import 'package:flutter_boxicons/flutter_boxicons.dart';
import 'package:nostr/nostr.dart';

/// The discover page of the application
class DiscoverPage extends StatefulWidget {
  const DiscoverPage({
    super.key,
    required this.getTheme,
    required this.keychain,
  });

  /// The function to get the current theme of the application.
  final ThemeMode Function() getTheme;

  /// The keychain of the user.
  final Keychain keychain;

  @override
  State<DiscoverPage> createState() => _DiscoverPageState();
}

/// The state of the [DiscoverPage] of the application.
class _DiscoverPageState extends State<DiscoverPage> {
  /// The challenges to display.
  final List<Challenge> _challenges = [];

  /// The conrtoller for the search bar.
  final SearchController _searchController = SearchController();

  /// Load the challenges from the relay.
  void _loadChallenges() {
    RelayPool.instance.listen(
      request: Challenge.getChallengesRequest(
        search: _searchController.text.isEmpty ? null : _searchController.text,
      ),
      onEvent: (event) {
        /// Check if the challenge is already in the list.
        if (_challenges.firstWhereOrNull((e) => e.id == event.id) != null) return;

        /// Check if the widget is mounted. (because of async)
        if (!mounted) return;

        /// Add the challenge to the list.
        setState(() => _challenges.add(Challenge.fromEvent(event)));
      },
    );
  }

  @override
  void initState() {
    _loadChallenges();
    super.initState();
  }

  /// Builds the clear button of the search bar. see [_buildSearchBar]
  Widget _buildSearchClearButton(BuildContext context) {
    return IconButton(
      onPressed: () {
        setState(() {
          _searchController.clear();
          _challenges.clear();
        });
        _loadChallenges();
      },
      icon: Icon(
        Boxicons.bx_x,
        color: widget.getTheme() == ThemeMode.dark ? const Color(0xFFEEEEEE) : const Color(0xFF1A1A1A),
      ),
    );
  }

  /// Builds the search bar of the discover page.
  Widget _buildSearchBar(BuildContext context) {
    return SizedBox(
      height: 45.0,
      child: SearchAnchor(
        isFullScreen: false,
        builder: (ctx, controller) => SearchBarTheme(
          data: SearchBarThemeData(
            backgroundColor: WidgetStateColor.resolveWith(
              (states) => widget.getTheme() == ThemeMode.dark ? const Color(0xFF1A1A1A) : const Color(0xFFEEEEEE),
            ),
            shape: WidgetStateProperty.resolveWith(
              (states) => RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
            ),
            elevation: WidgetStateProperty.resolveWith(
              (states) => 0.0,
            ),
            padding: WidgetStateProperty.resolveWith(
              (states) => const EdgeInsets.only(
                left: 12.0,
              ),
            ),
            hintStyle: WidgetStateProperty.resolveWith(
              (states) => TextStyle(
                color: widget.getTheme() == ThemeMode.dark ? const Color(0xFFEEEEEE) : const Color(0xFF1A1A1A),
                fontSize: 18.0,
                fontWeight: FontWeight.w400,
              ),
            ),
            textStyle: WidgetStateProperty.resolveWith(
              (states) => TextStyle(
                color: widget.getTheme() == ThemeMode.dark ? const Color(0xFFEEEEEE) : const Color(0xFF1A1A1A),
                fontSize: 18.0,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          child: SearchBar(
            controller: controller,
            leading: Icon(
              Boxicons.bx_search,
              color: widget.getTheme() == ThemeMode.dark ? const Color(0xFFEEEEEE) : const Color(0xFF1A1A1A),
            ),
            trailing: [_buildSearchClearButton(context)],
            hintText: "Search",
            onSubmitted: (_) {
              setState(() {
                _challenges.clear();
              });
              _loadChallenges();
            },
          ),
        ),
        searchController: _searchController,
        suggestionsBuilder: (ctx, controller) => [],
      ),
    );
  }

  Widget _buildChallenge(BuildContext context, Challenge challenge) {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: ChallengeCard(
        keychain: widget.keychain,
        getTheme: widget.getTheme,
        challenge: challenge,
      ),
    );
  }

  Iterable<Widget> _buildChallenges(BuildContext context) {
    return _challenges.map((challenge) => _buildChallenge(context, challenge));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: FractionallySizedBox(
        widthFactor: 0.9,
        child: ListView(
          children: [
            const SizedBox(height: 10.0),
            _buildSearchBar(context),
            ..._buildChallenges(context),
          ],
        ),
      ),
    );
  }
}
