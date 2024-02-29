import 'package:synergy_client_dart/src/interface/empty_message_interface.dart';
import 'package:synergy_client_dart/src/messages/message_type.dart';

class KeepAliveMessage extends EmptyMessage {
  static const MessageType messageType = MessageType.cKeepAlive;

  KeepAliveMessage() : super(type: messageType);

  @override
  String toString() {
    return 'KeepAliveMessage';
  }
}
