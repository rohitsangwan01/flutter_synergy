import 'dart:typed_data';

abstract class ServerInterface {
  Future<void> connect(
    Function(Uint8List) onData,
    Function(String?) onError,
    Function() onDone,
  );

  Future<void> disconnect();

  Future<void> write(Uint8List data);
}
