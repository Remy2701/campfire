/// The different kinds of events, with their attached values.
/// see: https://github.com/nostr-protocol/nips?tab=readme-ov-file#event-kinds
enum EventKind {
  metadata(0),
  shortTextNode(1),
  follows(3),
  encryptedDirectMessage(4),
  eventDeletion(5),
  repost(6),
  reaction(7),
  badgeAward(8),
  groupChatMessage(9),
  groupChatThreadedReply(10),
  groupChatThread(11),
  groupThreadReply(12),
  seal(13),
  directMessage(14),
  genericRepost(16),
  channelCreation(40),
  channelMetadata(41),
  channelMessage(42),
  channelHideMessage(43),
  channelMuteUser(44),
  bid(1021),
  bidConfirmation(1022),
  openTimestamps(1040),
  giftWrap(1059),
  fileMetadata(1063),
  liveChatMessage(1311),
  patches(1617),
  issues(1621),
  replies(1622),
  statusOpened(1630),
  statusApplied(1631),
  statusClosed(1632),
  statusDraft(1633),
  problemTracker(1971),
  reporting(1984),
  label(1985),
  campfireEvent(2200);

  /// Create a new [EventKind] with the given value.
  const EventKind(this.value);

  /// The value of the kind.
  final int value;
}
