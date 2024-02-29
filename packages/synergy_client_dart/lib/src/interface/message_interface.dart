import 'dart:io';

import 'package:synergy_client_dart/src/common/extensions.dart';
import 'package:synergy_client_dart/src/common/logger.dart';
import 'package:synergy_client_dart/src/common/message_data_output_stream.dart';
import 'package:synergy_client_dart/src/messages/message_header.dart';
import 'package:synergy_client_dart/src/messages/message_type.dart';

abstract class Message {
  late MessageType type;
  late MessageHeader header;
  late MessageDataOutputStream dataStream;

  Message({MessageType? type, MessageHeader? header}) {
    assert(type != null || header != null);

    dataStream = MessageDataOutputStream();

    if (type != null) {
      this.type = type;
    } else if (header != null) {
      this.type = MessageType.fromString(header.type.toString());
    }

    if (header != null) {
      this.header = header;
    } else if (type != null) {
      this.header = MessageHeader.fromType(type);
    }
  }

  // Abstract method to write data to dataStream
  void writeData();

  void write(Socket dout) {
    try {
      writeData();
      header.dataSize = dataStream.size;
      header.write(dout);
      dout.writeBytes(dataStream.bytes);
      Logger.log(
        "Message: Sending: ${toString()} | $header",
        LogLevel.debug1,
      );
    } catch (e) {
      Logger.log("MessageWriteError: $e", LogLevel.error);
    }
  }
}
