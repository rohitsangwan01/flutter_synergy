import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:synergy_client_dart/src/models/server_type.dart';
import 'package:synergy_client_dart/synergy_client_dart.dart';
import 'package:synergy_client_dart/src/messages/hello_back_message.dart';
import 'package:synergy_client_dart/src/messages/hello_message.dart';
import 'package:synergy_client_dart/src/messages/message_header.dart';
import 'package:synergy_client_dart/src/messages/message_type.dart';
import 'package:synergy_client_dart/src/server_proxy.dart';
import 'package:synergy_client_dart/src/common/extensions.dart';

class SynergyClientDart {
  static Socket? _socket;
  static late String _clientName;
  static final ServerProxy _serverProxy = ServerProxy();
  static final _headerMessageSize = MessageHeader.messageTypeSize;
  static final _helloMessageSize = HelloMessage.helloMessageSize;

  static Future<void> connect({
    required ScreenInterface screen,
    required String serverIp,
    required int serverPort,
    required String clientName,
  }) async {
    _serverProxy.setScreen(screen);
    SynergyClientDart._clientName = clientName;

    try {
      _socket = await Socket.connect(serverIp, serverPort);
      Logger.log(
        'Connected to: ${_socket?.remoteAddress.address}:${_socket?.remotePort}',
      );
      _serverProxy.screen.onConnect();
      _socket?.listen(
        _handleSocket,
        onDone: () {
          Logger.log('Disconnected from server');
          _serverProxy.screen.onDisconnect();
          disconnect();
        },
        onError: (error) {
          Logger.log('Error: $error');
          _serverProxy.screen.onError(error.toString());
          disconnect();
        },
      );
      _serverProxy.dout = _socket;
    } catch (e) {
      Logger.log('Error: $e');
      _serverProxy.screen.onError(e.toString());
    }
  }

  static void disconnect() {
    _socket?.destroy();
    _socket = null;
    _serverProxy.dout = null;
  }

  static void setLogLevel(LogLevel level) {
    Logger.level = level;
  }

  static void setLogHandler(LogHandler handler) {
    Logger.logHandler = handler;
  }

  static void _handleSocket(Uint8List data) {
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

        _socket?.writeMessage(
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
