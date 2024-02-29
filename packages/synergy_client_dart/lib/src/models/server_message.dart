import 'dart:typed_data';

import 'package:synergy_client_dart/src/messages/message_type.dart';

class ServerMessage {
  MessageType type;
  Uint8List bodyBytes;
  late ByteData bodyBuffer;

  ServerMessage(this.type, this.bodyBytes) {
    bodyBuffer = bodyBytes.buffer.asByteData();
  }

  int readShort(int offset) => bodyBuffer.getInt16(offset, Endian.big);

  int readInt(int offset) => bodyBuffer.getInt32(offset, Endian.big);

  int readByte(int offset) => bodyBuffer.getUint8(offset);

  int readUnsignedShort(int offset) => bodyBuffer.getUint16(offset, Endian.big);

  @override
  String toString() {
    return 'MessageObj: $type, $bodyBytes';
  }
}
