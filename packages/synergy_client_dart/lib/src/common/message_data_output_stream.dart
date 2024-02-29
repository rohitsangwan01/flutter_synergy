import 'dart:convert';
import 'dart:typed_data';

class MessageDataOutputStream {
  final BytesBuilder _bytesBuilder = BytesBuilder();

  void writeShort(int value) {
    var byteData = ByteData(2);
    byteData.setInt16(0, value, Endian.big);
    _bytesBuilder.add(byteData.buffer.asUint8List());
  }

  void writeString(String str) {
    var strBytes = utf8.encode(str);
    var lengthData = ByteData(4);
    lengthData.setInt32(0, strBytes.length);
    _bytesBuilder.add(lengthData.buffer.asUint8List());
    _bytesBuilder.add(strBytes);
  }

  int get size => _bytesBuilder.length;

  Uint8List get bytes => _bytesBuilder.toBytes();

  @override
  String toString() => "MessageDataOutputStream: ${_bytesBuilder.toBytes()}";
}
