import 'package:dmp3s/common/api/ai/ai.dart';
import 'package:dmp3s/common/api/kinds.dart';
import 'package:dmp3s/common/api/relay/pool.dart';
import 'package:dmp3s/common/model/challenge.dart';
import 'package:dmp3s/common/widget/challenge.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_boxicons/flutter_boxicons.dart';
import 'package:nostr/nostr.dart';

class ChallengePage extends StatefulWidget {
  const ChallengePage({
    super.key,
    required this.keychain,
    required this.challenge,
    required this.getTheme,
    this.mode = ChallengeCardMode.discover,
  });

  final Keychain keychain;
  final Challenge challenge;
  final ThemeMode Function() getTheme;
  final ChallengeCardMode mode;

  @override
  State<ChallengePage> createState() => _ChallengePageState();
}

class _ChallengePageState extends State<ChallengePage> {
  bool _liked = false;
  String? _likedId;

  @override
  void initState() {
    // Retrieve like
    RelayPool.instance.listen(
        request: widget.challenge.getLikedByUser(widget.keychain.public),
        onEvent: (event) {
          setState(() {
            _liked = true;
            _likedId = event.id;
          });
        },
        onFinished: () {
          if (_likedId == null) {
            setState(() => _likedId = "");
          }
        });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          ListView(
            padding: EdgeInsets.zero,
            children: [
              AspectRatio(
                aspectRatio: 1.0,
                child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  decoration: BoxDecoration(
                    color: widget.getTheme() == ThemeMode.dark ? const Color(0xFF202020) : const Color(0xFFE2E2E2),
                  ),
                ),
              ),
              const SizedBox(height: 12.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.challenge.title,
                      style: TextStyle(
                        color: widget.getTheme() == ThemeMode.dark ? const Color(0xFFEEEEEE) : const Color(0xFF1A1A1A),
                        fontSize: 20.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    SingleChildScrollView(
                      physics: const NeverScrollableScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: widget.challenge.tags.indexed
                            .map(
                              (e) => Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 2.0),
                                margin: const EdgeInsets.only(right: 8.0),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(4.0),
                                  color: e.$1.isEven ? const Color(0xFFFF7349) : const Color(0xFF9D9D9D),
                                ),
                                child: Text(
                                  e.$2,
                                  style: const TextStyle(
                                    color: Color(0xFFFFFFFF),
                                    fontSize: 12.0,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      widget.challenge.description,
                      style: TextStyle(
                        color: widget.getTheme() == ThemeMode.dark ? const Color(0xFFD0D0D0) : const Color(0xFF1A1A1A),
                        fontSize: 14.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Positioned(
            bottom: 8.0,
            width: 45.0,
            right: 8.0,
            height: 45.0,
            child: GestureDetector(
              onTap: () async {
                final prompt = PromptGenerator.instance.generate(
                  title: widget.challenge.title,
                  description: widget.challenge.description,
                );
                await showDialog(
                  context: context,
                  builder: (context) => SimpleDialog(
                    title: const Text("Generated promp"),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    children: [
                      FutureBuilder(
                        future: prompt,
                        builder: (context, snapshot) => snapshot.hasData
                            ? ListTile(
                                title: Text(snapshot.data!,
                                    style: TextStyle(
                                      color: widget.getTheme() == ThemeMode.dark
                                          ? const Color(0xFFEEEEEE)
                                          : const Color(0xFF1A1A1A),
                                    )),
                                onTap: () async {
                                  // Set ... to clipboard
                                  Clipboard.setData(ClipboardData(text: snapshot.data!)).then(
                                    (_) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                          content: Text("Prompt copied!"),
                                        ),
                                      );
                                    },
                                  );
                                },
                              )
                            : const Center(child: CircularProgressIndicator()),
                      ),
                    ],
                  ),
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFFF7349),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: const Icon(
                  Boxicons.bxs_magic_wand,
                  color: Colors.white,
                  size: 24.0,
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 8.0,
            left: 8.0,
            right: 8.0 + 45.0 + 8.0,
            height: 45.0,
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFF9D9D9D),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: const Center(
                child: Text(
                  "Register",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: 8.0,
            left: 8.0,
            child: SafeArea(
              child: Align(
                alignment: Alignment.topLeft,
                child: IconButton(
                  iconSize: 32.0,
                  icon: const Icon(
                    Boxicons.bx_chevron_left,
                    color: Colors.black,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
            ),
          ),
          Visibility(
            visible: widget.mode != ChallengeCardMode.owned,
            child: Positioned(
              top: 8.0,
              right: 8.0,
              child: SafeArea(
                child: Align(
                  alignment: Alignment.topLeft,
                  child: IconButton(
                    iconSize: 32.0,
                    icon: Icon(
                      _liked ? Boxicons.bxs_heart : Boxicons.bx_heart,
                      color: _liked ? Colors.red : Colors.black,
                    ),
                    onPressed: () async {
                      if (!_liked && _likedId == "") {
                        final event = widget.challenge.likeEvent(widget.keychain);
                        setState(() {
                          _liked = true;
                          _likedId = event.id;
                        });
                        await RelayPool.instance.sendEvent(event);
                      } else if (_liked && _likedId != null) {
                        await RelayPool.instance.sendEvent(Event.from(
                          privkey: widget.keychain.private,
                          kind: EventKind.eventDeletion.value,
                          tags: [
                            ["e", _likedId!],
                          ],
                          content: "Deleting like",
                        ));
                        setState(() {
                          _likedId = null;
                          _liked = false;
                        });
                      }
                    },
                  ),
                ),
              ),
            ),
          ),
          Visibility(
            visible: widget.mode == ChallengeCardMode.owned,
            child: Positioned(
              top: 8.0,
              right: 8.0,
              child: SafeArea(
                child: Align(
                  alignment: Alignment.topLeft,
                  child: IconButton(
                    iconSize: 24.0,
                    icon: const Icon(Boxicons.bxs_trash),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text("Delete Challenge"),
                          content: const Text("Are you sure you want to delete this challenge?"),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text("Cancel"),
                            ),
                            TextButton(
                              onPressed: () {
                                RelayPool.instance.sendEvent(widget.challenge.toDeletEvent(widget.keychain));

                                Navigator.pop(context);
                                Navigator.pop(context);
                              },
                              child: const Text("Delete"),
                            ),
                          ],
                        ),
                      );
                    },
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
