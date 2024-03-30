import 'dart:io';
import 'dart:typed_data';

import 'package:synergy_client_dart/synergy_client_dart.dart';

class SocketServer implements ServerInterface {
  final String serverIp;
  final int serverPort;
  SocketServer(this.serverIp, this.serverPort);

  static Socket? _socket;

  @override
  Future<void> connect(
    Function(Uint8List data) onData,
    Function(String?) onError,
    Function() onDone,
  ) async {
    _socket = await Socket.connect(serverIp, serverPort);
    Logger.log(
      'Connected to: ${_socket?.remoteAddress.address}:${_socket?.remotePort}',
    );
    _socket?.listen(
      onData,
      onDone: onDone,
      onError: (error, stackTrace) => onError(error),
    );
  }

  @override
  Future<void> disconnect() async {
    _socket?.destroy();
    _socket = null;
  }

  @override
  Future<void> write(Uint8List data) async {
    _socket?.add(data);
  }
}
