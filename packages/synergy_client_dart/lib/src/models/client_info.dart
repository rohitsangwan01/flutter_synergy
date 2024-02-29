import 'package:synergy_client_dart/src/models/models_export.dart';

class ClientInfo {
  RectObj screenPosition;
  CursorPosition cursorPosition;

  ClientInfo({
    required this.screenPosition,
    required this.cursorPosition,
  });

  @override
  String toString() {
    return 'ClientInfo{screenPosition: $screenPosition, cursorPosition: $cursorPosition}';
  }
}
