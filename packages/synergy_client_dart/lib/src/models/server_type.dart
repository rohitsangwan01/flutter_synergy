import 'package:synergy_client_dart/src/messages/message_type.dart';

enum ServerType {
  synergy(MessageType.helloBackSynergy),
  barrier(MessageType.helloBackBarrier);

  final MessageType helloBackMessage;
  const ServerType(this.helloBackMessage);
}
