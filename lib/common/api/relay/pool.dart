import 'package:dmp3s/common/api/relay/relay.dart';
import 'package:logger/web.dart';
import 'package:nostr/nostr.dart';

/// A pool of relays.
class RelayPool {
  /// Singleton instance of [RelayPool].
  static RelayPool? _instance;

  /// Get the singleton instance of [RelayPool].\
  /// Creates and initializes the instance if it does not exist.
  static RelayPool get instance {
    if (_instance == null) {
      _instance = RelayPool();
      _instance!._initRelays();
    }
    return _instance!;
  }

  /// List of relay URLs.
  final List<String> urls = [];

  /// Logger for [RelayPool].
  final Logger _logger = Logger(printer: PrettyPrinter());

  /// Initialize the relays.
  void _initRelays() {
    addRelay('wss://relay.blackbyte.nl');
  }

  /// Add a new relay to the pool.
  void addRelay(String url) {
    // TODO: Check if the relay is valid
    urls.add(url);
  }

  /// Remove the given [url] from the pool.
  void removeRelay(String url) {
    urls.remove(url);
  }

  /// Send an [Event] to the relay pool.\
  /// This sends the event to all relays in the pool.
  Future<void> sendEvent(Event event) async {
    bool success = true;
    for (final url in urls) {
      final relay = Relay(url: url);
      if (await relay.sendEvent(event)) {
        success = true;
      }
    }

    if (!success) {
      // If we reach this point, we could not send the event to any relay
      _logger.e("Failed to send event (kind: ${event.kind}, content: ${event.content}) to any relay in the pool!");
    }
  }

  /// Listen to the relay pool.
  /// This listens to all relays in the pool.
  Future<void> listen({
    Request? request,
    required void Function(Event) onEvent,
    void Function()? onFinished,
  }) async {
    bool success = false;
    for (final url in urls) {
      final relay = Relay(url: url);
      if (await relay.listen(request: request, onEvent: onEvent, onFinished: onFinished)) {
        success = true;
      }
    }

    if (!success) {
      // If we reach this point, we could not listen to any relay
      _logger.e("Failed to listen to any relay in the pool!");
    }
  }
}
