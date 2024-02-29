import 'package:get_storage/get_storage.dart';

class StorageHandler {
  late GetStorage _storage;

  Future<void> init() async {
    await GetStorage.init("synergy_client_flutter");
    _storage = GetStorage("synergy_client_flutter");
  }

  String? get serverIp => _storage.read('serverIp');
  set serverIp(String? value) => _storage.write('serverIp', value);

  int? get serverPort => _storage.read('serverPort');
  set serverPort(int? value) => _storage.write('serverPort', value);

  String? get clientName => _storage.read('clientName');
  set clientName(String? value) => _storage.write('clientName', value);

  bool? get autoConnect => _storage.read('autoConnect');
  set autoConnect(bool? value) => _storage.write('autoConnect', value);
}
