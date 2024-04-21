// ignore_for_file: avoid_print

import 'package:synergy_client_dart/synergy_client_dart.dart';
import 'package:synergy_client_flutter/src/data/basic_screen.dart';
import 'package:synergy_client_flutter/src/data/storage_handler.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

/// Controller for SynergyClient, handles the connection and disconnection
class SynergyClientController extends GetxController {
  TextEditingController serverIpController = TextEditingController();
  TextEditingController serverPortController = TextEditingController();
  TextEditingController clientNameController = TextEditingController();
  late final SynergyClientDart client = SynergyClientDart();

  late BasicScreen screen;
  late StorageHandler _storage;

  RxBool isConnected = false.obs;
  RxBool autoConnect = false.obs;
  RxBool showCursor = false.obs;
  Rx<Offset> mouseCursorPos = const Offset(0, 0).obs;
  RxList<String> logs = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
    _initialize();
  }

  Future<void> _initialize() async {
    screen = BasicScreen(this);

    _storage = StorageHandler();
    await _storage.init();

    client.setLogLevel(LogLevel.debug);

    client.setLogHandler((message, LogLevel? level) {
      logs.add(message);
    });

    serverIpController.text = _storage.serverIp ?? '';
    serverPortController.text = _storage.serverPort?.toString() ?? '';
    clientNameController.text = _storage.clientName ?? '';
    autoConnect.value = _storage.autoConnect ?? false;
    if (autoConnect.value) connect();
  }

  void setAutoConnect(bool value) {
    autoConnect.value = value;
    _storage.autoConnect = value;
  }

  void connect() async {
    try {
      final serverIp = serverIpController.text;
      int? serverPort = int.tryParse(serverPortController.text);
      final clientName = clientNameController.text;
      if (serverIp.isEmpty || serverPort == null || clientName.isEmpty) return;

      _storage.serverIp = serverIp;
      _storage.serverPort = serverPort;
      _storage.clientName = clientName;

      print(
        'Connecting to Synergy server: $serverIp:$serverPort as $clientName',
      );

      //  if (formKey.currentState?.validate() == false) return;
      await client.connect(
        screen: screen,
        synergyServer: SocketServer(serverIp, serverPort),
        clientName: clientName,
      );
    } catch (e) {
      print('Error: $e');
    }
  }

  void disconnect() => client.disconnect();

  void handleShape(double width, double height) =>
      screen.handleShape(width, height);
}
