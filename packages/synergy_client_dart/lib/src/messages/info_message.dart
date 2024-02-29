import 'package:synergy_client_dart/src/interface/message_interface.dart';
import 'package:synergy_client_dart/src/messages/message_type.dart';

class InfoMessage extends Message {
  static const MessageType messageType = MessageType.dInfo;

  double screenX;
  double screenY;
  double screenWidth;
  double screenHeight;
  double cursorX;
  double cursorY;
  double unknown = 0;

  InfoMessage({
    required this.screenX,
    required this.screenY,
    required this.screenWidth,
    required this.screenHeight,
    required this.cursorX,
    required this.cursorY,
  }) : super(type: messageType);

  @override
  void writeData() {
    dataStream.writeShort(screenX.toInt());
    dataStream.writeShort(screenY.toInt());
    dataStream.writeShort(screenWidth.toInt());
    dataStream.writeShort(screenHeight.toInt());
    dataStream.writeShort(unknown.toInt());
    dataStream.writeShort(cursorX.toInt());
    dataStream.writeShort(cursorY.toInt());
  }

  @override
  String toString() {
    return 'InfoMessage:$screenX:$screenY:$screenWidth:$screenHeight:$unknown:$cursorX:$cursorY';
  }
}
