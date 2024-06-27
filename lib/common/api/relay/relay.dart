import 'dart:async';

import 'package:web_socket_channel/web_socket_channel.dart';
import "package:nostr/nostr.dart";
import 'package:logger/logger.dart';

/// The [Relay] class is a wrapper around the [WebSocketChannel] class to interact with a decentralized Relay using the Nostr protocol.
class Relay {
  static final Logger _logger = Logger(printer: PrettyPrinter());

  /// Create a relay with the given [url].
  Relay({required this.url});

  /// The URL of the relay.
  final String url;

  /// The [WebSocketChannel] instance.
  WebSocketChannel? _channel;

  /// Whether the relay is busy or not. If the relay is busy, it will not accept any new requests.
  bool get isBusy => _channel != null;

  /// Open a connection to the relay.
  void _open() {
    _channel = WebSocketChannel.connect(Uri.parse(url));
  }

  /// Close the connection to the relay.
  Future<void> _close() async {
    await _channel!.sink.close();
    _channel = null;
  }

  /// Send an [Event] to the relay.
  Future<bool> sendEvent(Event event) async {
    if (isBusy) {
      _logger.e(
        "Could not send event (kind: ${event.kind}, content: ${event.content}) "
        "to relay ($url), alreay busy!",
      );
      return false;
    }

    // Connect to the relay
    try {
      _open();
    } catch (_) {
      _logger.e("Could not connect to relay ($url)!");
      return false;
    }

    // Send the event
    _channel!.sink.add(event.serialize());
    await Future.delayed(const Duration(milliseconds: 100));

    // List to the response (should be an OK message)
    var success = true;
    final completer = Completer<void>();
    _channel!.stream.listen((e) {
      final message = Message.deserialize(e);
      if (message.messageType != MessageType.ok) {
        _logger.e(
          "Could not send event (kind: ${event.kind}, content: ${event.content}) "
          "to relay ($url), unexpected response: ${message.messageType}",
        );
        success = false;
        return;
      } else {
        _logger.d(
          "Event (kind: ${event.kind}, content: ${event.content}) successfully "
          "sent to relay ($url)!",
        );
        completer.complete();
      }
    });

    await completer.future;

    // Close the connection
    await _close();

    return success;
  }

  /// Listen to the relay for incoming events with the given [Request].
  Future<bool> listen({
    Request? request,
    required void Function(Event) onEvent,
    void Function()? onFinished,
  }) async {
    if (isBusy) {
      _logger.e("Could not listen to relay ($url), already busy!");
      return false;
    }

    // Connect to the relay
    try {
      _open();
    } catch (_) {
      _logger.e("Could not connect to relay ($url)!");
      return false;
    }

    // Send the request
    if (request != null) _channel!.sink.add(request.serialize());
    await Future.delayed(const Duration(milliseconds: 100));

    // Listen to the incoming events
    _channel!.stream.listen((e) async {
      final message = Message.deserialize(e);
      _logger.d("Message received from '$url': ${message.messageType}");
      if (message.messageType == MessageType.eose) {
        _logger.d("Connection to relay ($url) closed!");
        onFinished?.call();
        await _close();
        return;
      }
      if (message.messageType != MessageType.event) return;
      onEvent(message.message as Event);
    });

    return true;
  }
}
