import 'dart:typed_data';

import 'package:synergy_client_dart/synergy_client_dart.dart';

extension DataOutputSinkExt on ServerInterface {
  void writeMessage(Message message) {
    message.write(this);
  }

  void writeInt(int v) {
    final d = ByteData(4)..setInt32(0, v, Endian.big);
    write(d.buffer.asUint8List(d.offsetInBytes, 4));
  }

  void writeBytes(List<int> bytes) {
    if (bytes is Uint8List) {
      write(bytes);
    } else {
      write(Uint8List.fromList(bytes));
    }
  }
}
