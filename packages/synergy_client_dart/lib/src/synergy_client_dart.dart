import 'dart:convert';
import 'dart:typed_data';

import 'package:synergy_client_dart/src/models/server_type.dart';
import 'package:synergy_client_dart/synergy_client_dart.dart';
import 'package:synergy_client_dart/src/messages/hello_back_message.dart';
import 'package:synergy_client_dart/src/messages/hello_message.dart';
import 'package:synergy_client_dart/src/messages/message_header.dart';
import 'package:synergy_client_dart/src/messages/message_type.dart';
import 'package:synergy_client_dart/src/server_proxy.dart';
import 'package:synergy_client_dart/src/common/extensions.dart';

/// Connect with SynergyServer, we provide by default [SocketServer] but you can provide your own implementation as well
/// [ServerInterface] is the interface to the screen, to receive all callbacks
class SynergyClientDart {
  ServerInterface? _server;
  late String _clientName;
  final ServerProxy _serverProxy = ServerProxy();
  final _headerMessageSize = MessageHeader.messageTypeSize;
  final _helloMessageSize = HelloMessage.helloMessageSize;

  Future<void> connect({
    required ScreenInterface screen,
    required ServerInterface synergyServer,
    required String clientName,
  }) async {
    _serverProxy.setScreen(screen);
    _clientName = clientName;
    _server = synergyServer;

    try {
      // Dispose previous instance if any
      await _server?.disconnect();

      // Connect to the new server
      await _server?.connect(
        _handleSocket,
        (String? error) {
          Logger.log('Error: $error');
          _serverProxy.screen.onError(error.toString());
          disconnect();
        },
        () {
          Logger.log('Disconnected from server');
          _serverProxy.screen.onDisconnect();
          disconnect();
        },
      );
      _serverProxy.screen.onConnect();
      _serverProxy.server = _server;
    } catch (e) {
      Logger.log('Error: $e');
      _serverProxy.screen.onError(e.toString());
    }
  }

  void disconnect() {
    _server?.disconnect();
    _serverProxy.server = null;
  }

  void setLogLevel(LogLevel level) {
    Logger.level = level;
  }

  void setLogHandler(LogHandler handler) {
    Logger.logHandler = handler;
  }

  void _handleSocket(Uint8List data) {
    ByteData din = data.buffer.asByteData();
    int messageSize = din.getInt32(0, Endian.big);
    // check if the message size is valid
    if (messageSize < 0 || data.length < messageSize) {
      Logger.log(
        'Invalid Data: MessageSize: $messageSize DataSize: ${data.length}',
        LogLevel.debug1,
      );
      return;
    }

    if (messageSize == _helloMessageSize) {
      // Check if the data is a hello message
      try {
        HelloMessage helloMessage = HelloMessage(data);
        Logger.log(helloMessage, LogLevel.debug);
        ServerType serverType = helloMessage.serverType!;

        _server?.writeMessage(
          HelloBackMessage(
            majorVersion: 1,
            minorVersion: 6,
            name: _clientName,
            serverType: serverType,
          ),
        );
      } catch (e) {
        Logger.log('Error parsing hello message: $e', LogLevel.error);
      }
      return;
    }

    // Parse the data
    try {
      MessageType messageType = MessageType.fromString(
        utf8.decode(
          din.buffer.asUint8List(_headerMessageSize, _headerMessageSize),
        ),
      );

      int totalSize = messageSize + _headerMessageSize;

      var bodyBytes = data.sublist(
        _headerMessageSize + _headerMessageSize,
        totalSize,
      );

      _serverProxy.handleData(ServerMessage(messageType, bodyBytes));

      // If there is more data, then parse it
      if (data.length > totalSize) {
        _handleSocket(data.sublist(totalSize));
        Logger.log(
          'Handling more data: ${data.length - totalSize} bytes',
          LogLevel.debug1,
        );
      }
    } catch (e) {
      Logger.log('Error parsing data: $e', LogLevel.error);
    }
  }
}
