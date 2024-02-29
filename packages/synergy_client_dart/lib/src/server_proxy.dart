import 'dart:io';

import 'package:synergy_client_dart/synergy_client_dart.dart';
import 'package:synergy_client_dart/src/messages/info_message.dart';
import 'package:synergy_client_dart/src/messages/keep_alive_message.dart';
import 'package:synergy_client_dart/src/messages/message_type.dart';
import 'package:synergy_client_dart/src/common/extensions.dart';

class ServerProxy {
  Socket? dout;
  late ScreenInterface screen;

  void setScreen(ScreenInterface screen) {
    this.screen = screen;
    screen.updateClientInfo = _sendClientInfo;
  }

  Map clipboardSequence = {};

  void handleData(ServerMessage msg) async {
    try {
      MessageType? type = msg.type;
      switch (msg.type) {
        case MessageType.qInfo:
          _sendClientInfo();
          break;
        // Commands
        case MessageType.cInfoAck:
          Logger.log('Info acknowledged', LogLevel.debug);
          break;
        case MessageType.cResetOptions:
          Logger.log('Reset options');
          break;
        case MessageType.cKeepAlive:
          dout?.writeMessage(KeepAliveMessage());
          break;
        case MessageType.cEnter:
          var x = msg.readShort(0);
          var y = msg.readShort(2);
          var sequenceNumber = msg.readInt(4);
          var mask = msg.readShort(8);
          screen.enter(x, y, sequenceNumber, mask);
          break;
        case MessageType.cLeave:
          screen.leave();
          break;
        case MessageType.cClipboard:
          var id = msg.readByte(0);
          print('GrabClipboard: $id');
          break;
        // Data
        case MessageType.dClipBoard:
          // var id = msg.readByte(0);
          // var sequenceNumber = msg.readInt(2);
          // var bytes = msg.bodyBytes.sublist(6);
          // setClipboard(id, sequenceNumber, msg.bodyBytes);
          break;
        case MessageType.dSetOptions:
          Logger.log('Handshake complete', LogLevel.debug);
          break;
        case MessageType.dMouseMove:
          screen.mouseMove(
            msg.readShort(0),
            msg.readShort(2),
          );
          break;
        case MessageType.dMouseRelMove:
          screen.mouseRelativeMove(
            msg.readShort(0),
            msg.readShort(2),
          );
          break;
        case MessageType.dMouseDown:
          screen.mouseDown(
            msg.readByte(0),
          );
          break;
        case MessageType.dMouseUp:
          screen.mouseUp(
            msg.readByte(0),
          );
          break;
        case MessageType.dMouseWheel:
          screen.mouseWheel(
            msg.readShort(0),
            msg.readShort(2),
          );
          break;

        case MessageType.dKeyDown:
          screen.keyDown(
            msg.readUnsignedShort(0),
            msg.readUnsignedShort(2),
            msg.readUnsignedShort(4),
          );
          break;
        case MessageType.dKeyUp:
          screen.keyUp(
            msg.readUnsignedShort(0),
            msg.readUnsignedShort(2),
            msg.readUnsignedShort(4),
          );
          break;
        case MessageType.dKeyRepeat:
          screen.keyRepeat(
            msg.readUnsignedShort(0),
            msg.readUnsignedShort(2),
            msg.readUnsignedShort(4),
            msg.readUnsignedShort(6),
          );
          break;
        default:
          Logger.log('Unhandled Message: $type', LogLevel.error);
          break;
      }
    } catch (e) {
      Logger.log(e);
    }
  }

  // StringBuffer dataCached = StringBuffer();

  // void setClipboard(int id, int seq, Uint8List remainingBytes) {
  //   int r = ClipboardChunk.assemble(remainingBytes, dataCached, id, seq);

  //   if (r == ClipboardChunk.kStart) {
  //     int size = ClipboardChunk.sExpectedSize;
  //     print('receiving clipboard $id size=$size');
  //   } else if (r == ClipboardChunk.kFinish) {
  //     print('received clipboard $id size=${dataCached.length}');

  //     print('clipboard was updated');
  //   }
  // }

  /// Send client info to server, For query info message
  void _sendClientInfo() {
    try {
      var clientInfo = ClientInfo(
        screenPosition: screen.getShape(),
        cursorPosition: screen.getCursorPos(),
      );
      Logger.log('Sending client info: $clientInfo', LogLevel.debug);
      dout?.writeMessage(
        InfoMessage(
          screenX: clientInfo.screenPosition.left,
          screenY: clientInfo.screenPosition.top,
          screenWidth: clientInfo.screenPosition.width,
          screenHeight: clientInfo.screenPosition.height,
          cursorX: clientInfo.cursorPosition.x,
          cursorY: clientInfo.cursorPosition.y,
        ),
      );
    } catch (e) {
      Logger.log(e);
    }
  }
}
