import 'dart:convert';
import 'dart:typed_data';

import 'package:synergy_client_dart/src/models/server_type.dart';

class HelloMessage {
  static const int helloMessageSize = 11;

  late int majorVersion;
  late int minorVersion;
  late String serverName;
  ServerType? serverType;

  HelloMessage(Uint8List data) {
    var byteData = ByteData.view(data.buffer);
    int packetSize = byteData.getInt32(0, Endian.big);

    if (packetSize != helloMessageSize) {
      throw Exception(
        'Hello message not the right size: $packetSize',
      );
    }

    serverName = utf8.decode(data.sublist(4, 11));

    for (ServerType server in ServerType.values) {
      if (server.helloBackMessage.value.toLowerCase() ==
          serverName.toLowerCase()) {
        serverType = server;
        break;
      }
    }

    if (serverType == null) {
      throw Exception('Unsupported server: $serverName');
    }

    majorVersion = byteData.getInt16(11, Endian.big);
    minorVersion = byteData.getInt16(13, Endian.big);
  }

  @override
  String toString() {
    return '$serverName - HelloMessage: V $majorVersion.$minorVersion';
  }
}
