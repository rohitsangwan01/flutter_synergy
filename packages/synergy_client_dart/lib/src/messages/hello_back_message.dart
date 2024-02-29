import 'package:synergy_client_dart/src/common/logger.dart';
import 'package:synergy_client_dart/src/interface/message_interface.dart';
import 'package:synergy_client_dart/src/models/server_type.dart';

class HelloBackMessage extends Message {
  int majorVersion;
  int minorVersion;
  String name;

  HelloBackMessage({
    required this.majorVersion,
    required this.minorVersion,
    required this.name,
    required ServerType serverType,
  }) : super(type: serverType.helloBackMessage);

  @override
  void writeData() {
    try {
      dataStream.writeShort(majorVersion);
      dataStream.writeShort(minorVersion);
      dataStream.writeString(name);
    } catch (e) {
      Logger.log("Error: $e");
    }
  }

  @override
  String toString() {
    return "HelloBackMessage: V: $majorVersion.$minorVersion Name: $name";
  }
}
