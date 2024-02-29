import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:synergy_client_dart/src/common/extensions.dart';
import 'package:synergy_client_dart/src/common/logger.dart';
import 'package:synergy_client_dart/src/messages/message_type.dart';

class MessageHeader {
  static const messageTypeSize = 4;

  late int size;
  int? dataSize;
  late MessageType type;
  Uint8List? bodyBytes;

  MessageHeader.fromType(this.type) {
    size = type.value.length;
  }

  MessageHeader.fromString(String type) {
    this.type = MessageType.fromString(type);
    size = this.type.value.length;
  }

  MessageHeader.fromByteData(ByteData din) {
    try {
      int messageSize = din.getInt32(0, Endian.big);
      var messageTypeBytes = din.buffer.asUint8List(
        messageTypeSize,
        messageTypeSize,
      );
      type = MessageType.fromString(utf8.decode(messageTypeBytes));
      size = messageTypeSize;
      dataSize = messageSize - size;
      // Bytes of body
      bodyBytes = din.buffer.asUint8List().sublist(size + messageTypeSize);
    } catch (e) {
      Logger.log(
        'Error reading message header: $e ${din.buffer.asUint8List()}',
        LogLevel.error,
      );
    }
  }

  void write(Socket dout) {
    dataSize ??= 0;
    dout.writeInt(size + dataSize!);
    dout.writeBytes(utf8.encode(type.value));
  }

  @override
  String toString() => "MessageHeader:$size:$dataSize:$type";
}
