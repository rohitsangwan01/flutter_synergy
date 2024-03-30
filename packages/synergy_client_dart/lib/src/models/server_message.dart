import 'dart:typed_data';

import 'package:synergy_client_dart/src/messages/message_type.dart';

class ServerMessage {
  MessageType type;
  Uint8List bodyBytes;
  late ByteData bodyBuffer;

  ServerMessage(this.type, this.bodyBytes) {
    bodyBuffer = bodyBytes.buffer.asByteData();
  }

  int readShort(int offset) {
    try {
      return bodyBuffer.getInt16(offset, Endian.big);
    } catch (e) {
      return 0;
    }
  }

  int readInt(int offset) {
    try {
      return bodyBuffer.getInt32(offset, Endian.big);
    } catch (e) {
      return 0;
    }
  }

  int readByte(int offset) {
    try {
      return bodyBuffer.getUint8(offset);
    } catch (e) {
      return 0;
    }
  }

  int readUnsignedShort(int offset) {
    try {
      return bodyBuffer.getUint16(offset, Endian.big);
    } catch (e) {
      return 0;
    }
  }

  @override
  String toString() {
    return 'MessageObj: $type, $bodyBytes';
  }
}
