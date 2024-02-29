import 'package:synergy_client_dart/src/interface/message_interface.dart';
import 'package:synergy_client_dart/src/messages/message_header.dart';
import 'package:synergy_client_dart/src/messages/message_type.dart';

class EmptyMessage extends Message {
  EmptyMessage({MessageHeader? header, MessageType? type})
      : super(header: header, type: type);

  @override
  void writeData() {
    // Do nothing.
  }
}
