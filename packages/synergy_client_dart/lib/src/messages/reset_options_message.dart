import 'dart:typed_data';

import 'package:synergy_client_dart/src/interface/empty_message_interface.dart';
import 'package:synergy_client_dart/src/messages/message_header.dart';
import 'package:synergy_client_dart/src/messages/message_type.dart';

class ResetOptionsMessage extends EmptyMessage {
  static const MessageType messageType = MessageType.cResetOptions;

  ResetOptionsMessage(
    ByteData data, {
    MessageHeader? header,
  }) : super(type: messageType, header: header);

  @override
  String toString() {
    return 'ResetOptionsMessage: TODO';
  }
}
