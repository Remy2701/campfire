import 'package:dmp3s/common/api/relay/pool.dart';
import 'package:dmp3s/common/model/challenge.dart';
import 'package:dmp3s/common/style/button.dart';
import 'package:dmp3s/common/widget/challenge.dart';
import 'package:dmp3s/core/creation/page.dart';
import 'package:flutter/material.dart';
import 'package:nostr/nostr.dart';

class MyChallengePage extends StatefulWidget {
  const MyChallengePage({
    super.key,
    required this.keychain,
    required this.getTheme,
  });

  final Keychain keychain;
  final ThemeMode Function() getTheme;

  @override
  State<MyChallengePage> createState() => _MyChallengePageState();
}

class _MyChallengePageState extends State<MyChallengePage> with TickerProviderStateMixin {
  late final TabController _controller = TabController(
    length: 2,
    initialIndex: 0,
    vsync: this,
  );

  final List<Challenge> _challenges = [];

  void _loadOwnedChallenged() {
    RelayPool.instance.listen(
      request: Challenge.getOwnedChallengesRequest(widget.keychain.public),
      onEvent: (event) {
        if (!mounted) return;
        setState(() {
          _challenges.add(Challenge.fromEvent(event));
        });
      },
    );
  }

  @override
  void initState() {
    _controller.addListener(() {
      if (_controller.indexIsChanging) return;
      setState(() {
        _challenges.clear();
        if (_controller.index == 1) {
          _loadOwnedChallenged();
        }
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: [
          SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: Column(
              children: [
                TabBar(
                  controller: _controller,
                  tabs: const [
                    Tab(text: "Participating"),
                    Tab(text: "Owned"),
                  ],
                  labelColor: widget.getTheme() == ThemeMode.light ? Colors.black : Colors.white,
                  unselectedLabelColor: widget.getTheme() == ThemeMode.light ? Colors.black54 : Colors.white54,
                  indicatorColor: const Color(0xFFFF7349),
                  dividerColor: Colors.transparent,
                  overlayColor: WidgetStateProperty.all(const Color(0x10FF7349)),
                ),
                Expanded(
                  child: TabBarView(
                    controller: _controller,
                    children: [
                      FractionallySizedBox(
                        widthFactor: 0.9,
                        child: ListView(
                          children: _challenges
                              .map(
                                (e) => Padding(
                                  padding: const EdgeInsets.only(top: 20.0),
                                  child: ChallengeCard(
                                    keychain: widget.keychain,
                                    getTheme: widget.getTheme,
                                    challenge: e,
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                      ),
                      FractionallySizedBox(
                        widthFactor: 0.9,
                        child: ListView(
                          children: _challenges
                              .map(
                                (e) => Padding(
                                  padding: const EdgeInsets.only(top: 20.0),
                                  child: ChallengeCard(
                                    keychain: widget.keychain,
                                    getTheme: widget.getTheme,
                                    challenge: e,
                                    mode: ChallengeCardMode.owned,
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Visibility(
            visible: _controller.index == 1,
            child: Positioned(
              right: 20,
              bottom: 20,
              child: SizedBox(
                width: 48.0,
                height: 48.0,
                child: IconButton.filled(
                  onPressed: () {
                    // final challenge = Challenge(
                    //   title: "Sample Challenge",
                    //   description: "This is the description of the sample challenge!",
                    //   tags: ["sample", "business", "development"],
                    //   rewards: [
                    //     Reward(type: RewardType.bitcoin, amount: 2500),
                    //   ],
                    // );

                    // final event = challenge.toEvent(widget.keychain);
                    // assert(event.isValid());

                    // RelayPool.instance.sendEvent(event);

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChallengeCreationPage(
                          getTheme: widget.getTheme,
                          keychain: widget.keychain,
                        ),
                      ),
                    );
                  },
                  style: accentButtonStyle,
                  icon: Icon(
                    Icons.add,
                    size: 32.0,
                    color: widget.getTheme() == ThemeMode.light ? Colors.white : Colors.black,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
