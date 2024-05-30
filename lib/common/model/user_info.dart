import 'package:collection/collection.dart';
import 'package:dmp3s/common/api/kinds.dart';
import 'package:nostr/nostr.dart';

/// The information of a user.
class UserInfo {
  const UserInfo({this.firstName, this.lastName, this.anonymous, this.description})
      : assert(firstName != null || lastName != null || anonymous != null);

  final String? firstName;
  final String? lastName;
  final String? description;
  final bool? anonymous;

  /// Convert the [UserInfo] to an [Event].
  Event toEvent(Keychain keychain) {
    return Event.from(
      privkey: keychain.private,
      kind: EventKind.metadata.value,
      tags: [
        if (firstName != null) ["firstName", firstName!],
        if (lastName != null) ["lastName", lastName!],
        if (anonymous != null) ["anonymous", anonymous!.toString()],
        if (description != null) ["description", description!],
      ],
      content: "",
    );
  }

  /// Create a [UserInfo] from the given [Event].
  static UserInfo fromEvent(Event event) {
    final firstName = event.tags.firstWhereOrNull((tag) => tag[0] == "firstName")?.elementAt(1);
    final lastName = event.tags.firstWhereOrNull((tag) => tag[0] == "lastName")?.elementAt(1);
    final anonymous = event.tags.firstWhereOrNull((tag) => tag[0] == "anonymous")?.elementAt(1);
    final description = event.tags.firstWhereOrNull((tag) => tag[0] == "description")?.elementAt(1);

    return UserInfo(
      firstName: firstName,
      lastName: lastName,
      anonymous: anonymous == null ? null : anonymous == "true",
      description: description,
    );
  }

  /// Generate the requst to the get [UserInfo] of the user with the given public key.
  static Request getRequest(String author) {
    return Request(generate64RandomHexChars(), [
      Filter(
        kinds: [EventKind.metadata.value],
        authors: [author],
        limit: 1,
      )
    ]);
  }
}
