import 'dart:typed_data';

import 'package:synergy_client_dart/src/common/logger.dart';
import 'package:synergy_client_dart/src/interface/message_interface.dart';
import 'package:synergy_client_dart/src/messages/message_header.dart';
import 'package:synergy_client_dart/src/messages/message_type.dart';

class SetOptionsMessage extends Message {
  static const MessageType messageType = MessageType.dSetOptions;

  SetOptionsMessage(MessageHeader header, ByteData data)
      : super(type: messageType, header: header) {
    List<int> options = [];
    int? dataLeft = header.dataSize;
    while (dataLeft != null && dataLeft > 0) {
      int messageSize = data.getInt32(0);
      options.add(messageSize);
      dataLeft -= 4; // size of int in bytes
    }
    if (dataLeft != 0) {
      throw Exception('Error reading SetOptionsMessage. dataLeft: $dataLeft');
    }
  }

  @override
  String toString() {
    return 'SetOptionsMessage:';
  }

  @override
  void writeData() {
    Logger.log('SetOptionsMessage: writeData not implemented.');
  }
}
