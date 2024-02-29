import 'dart:io';
import 'dart:typed_data';

import 'package:synergy_client_dart/synergy_client_dart.dart';

extension DataOutputSinkExt on Socket {
  void writeMessage(Message message) {
    message.write(this);
  }

  void writeInt(int v) {
    final d = ByteData(4)..setInt32(0, v, Endian.big);
    add(d.buffer.asUint8List(d.offsetInBytes, 4));
  }

  void writeBytes(List<int> bytes) {
    if (bytes is Uint8List) {
      add(bytes);
    } else {
      add(Uint8List.fromList(bytes));
    }
  }
}
