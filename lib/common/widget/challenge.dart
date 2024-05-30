import 'package:dmp3s/common/model/challenge.dart';
import 'package:dmp3s/core/challenge-fv/page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_boxicons/flutter_boxicons.dart';
import 'package:nostr/nostr.dart';

enum ChallengeCardMode {
  discover,
  participating,
  owned,
}

class ChallengeCard extends StatelessWidget {
  const ChallengeCard({
    super.key,
    required this.keychain,
    required this.getTheme,
    required this.challenge,
    this.mode = ChallengeCardMode.discover,
  });

  final ThemeMode Function() getTheme;

  final Keychain keychain;
  final Challenge challenge;
  final ChallengeCardMode mode;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (ctx) => ChallengePage(
              keychain: keychain,
              challenge: challenge,
              getTheme: getTheme,
              mode: mode,
            ),
          ),
        );
      },
      child: Container(
        width: double.infinity,
        height: 148.0,
        decoration: BoxDecoration(
          color: getTheme() == ThemeMode.dark ? const Color(0xFF1A1A1A) : const Color(0xFFEEEEEE),
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Row(
          children: [
            AspectRatio(
              aspectRatio: 1.0,
              child: Container(
                decoration: BoxDecoration(
                  color: getTheme() == ThemeMode.dark ? const Color(0xFF202020) : const Color(0xFFE2E2E2),
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
            ),
            const SizedBox(width: 12.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 4.0),
                  Text(
                    challenge.title,
                    style: TextStyle(
                      color: getTheme() == ThemeMode.dark ? const Color(0xFFEEEEEE) : const Color(0xFF1A1A1A),
                      fontSize: 18.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Visibility(
                    visible: challenge.rewards.isNotEmpty,
                    child: Padding(
                      padding: const EdgeInsets.only(
                        bottom: 4.0,
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Boxicons.bxs_gift,
                            color: getTheme() == ThemeMode.dark ? const Color(0xFFEEEEEE) : const Color(0xFF1A1A1A),
                            size: 18.0,
                          ),
                          const SizedBox(width: 4.0),
                          Text(
                            challenge.rewards.map((reward) {
                              var str = "";
                              if (reward.amount > 1000000) {
                                str += "${reward.amount ~/ 1000000}m";
                              } else if (reward.amount > 1000) {
                                str += "${reward.amount ~/ 1000}k";
                              } else {
                                str += reward.amount.toString();
                              }

                              str += switch (reward.type) {
                                RewardType.bitcoin => " SATS",
                                RewardType.europeanCredit => " ECs",
                              };

                              return str;
                            }).join(' & '),
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: getTheme() == ThemeMode.dark ? const Color(0xFFEEEEEE) : const Color(0xFF1A1A1A),
                              fontSize: 12.0,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Text(
                    "${challenge.description}\n\n\n",
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: getTheme() == ThemeMode.dark ? const Color(0xFFEEEEEE) : const Color(0xFF1A1A1A),
                      fontSize: 12.0,
                      fontWeight: FontWeight.w400,
                    ),
                    textAlign: TextAlign.justify,
                  ),
                  const SizedBox(height: 4.0),
                  SingleChildScrollView(
                    physics: const NeverScrollableScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: challenge.tags.indexed
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
                ],
              ),
            ),
            const SizedBox(width: 12.0),
          ],
        ),
      ),
    );
  }
}
