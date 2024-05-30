import 'package:dmp3s/common/api/kinds.dart';
import 'package:nostr/nostr.dart';

enum RewardType {
  bitcoin,
  europeanCredit,
}

class Reward {
  Reward({required this.type, required this.amount});

  final RewardType type;
  final int amount;
}

class Challenge {
  Challenge({
    this.id,
    required this.title,
    required this.description,
    required this.tags,
    required this.rewards,
  });

  final String? id;
  final String title;
  final String description;
  final List<String> tags;
  final List<Reward> rewards;

  Event toEvent(Keychain author) {
    return Event.from(
      privkey: author.private,
      kind: EventKind.campfireEvent.value,
      tags: [
        ["title", title],
        ["tags", tags.join(";")],
        ["rewards", rewards.map((r) => "${r.type.toString()}:${r.amount}").join(";")]
      ],
      content: description,
    );
  }

  Event toDeletEvent(Keychain author) {
    return Event.from(
      privkey: author.private,
      kind: EventKind.eventDeletion.value,
      tags: [
        ["e", id!],
      ],
      content: "Deleting event",
    );
  }

  Event likeEvent(Keychain author) {
    return Event.from(
      privkey: author.private,
      kind: EventKind.reaction.value,
      tags: [
        ["e", id!],
      ],
      content: "Liked challenge",
    );
  }

  static Challenge fromEvent(Event event) {
    final tags = event.tags.firstWhere((t) => t[0] == "tags", orElse: () => ["tags", ""]).last.split(";");
    final rewards =
        event.tags.firstWhere((t) => t[0] == "rewards", orElse: () => ["rewards", ""]).last.split(";").map((r) {
      final parts = r.split(":");
      return Reward(type: RewardType.values.firstWhere((t) => t.toString() == parts[0]), amount: int.parse(parts[1]));
    }).toList();

    return Challenge(
      id: event.id,
      title: event.tags.firstWhere((t) => t[0] == "title", orElse: () => ["title", ""]).last,
      description: event.content,
      tags: tags,
      rewards: rewards,
    );
  }

  static Request getChallengesRequest({int limit = 10, String? search}) {
    return Request(
      generate64RandomHexChars(),
      [
        Filter(
          kinds: [EventKind.campfireEvent.value],
          limit: limit,
          search: search,
        )
      ],
    );
  }

  static Request getChallengeWithIdRequest({required String id}) {
    return Request(
      generate64RandomHexChars(),
      [
        Filter(
          kinds: [EventKind.campfireEvent.value],
          limit: 1,
          ids: [id],
        )
      ],
    );
  }

  static Request getLikeReactions({required Keychain author, int limit = 10}) {
    return Request(
      generate64RandomHexChars(),
      [
        Filter(
            kinds: [EventKind.reaction.value],
            limit: limit,
            authors: [
              author.public,
            ])
      ],
    );
  }

  static Request getOwnedChallengesRequest(String author, {int limit = 10}) {
    return Request(
      generate64RandomHexChars(),
      [
        Filter(
          kinds: [EventKind.campfireEvent.value],
          authors: [author],
          limit: limit,
        )
      ],
    );
  }

  Request getLikedByUser(String author) {
    return Request(
      generate64RandomHexChars(),
      [
        Filter(
          kinds: [EventKind.reaction.value],
          e: [id!],
          authors: [author],
          limit: 1,
        )
      ],
    );
  }
}
