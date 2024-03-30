import 'package:synergy_client_dart/synergy_client_dart.dart';

void main(List<String> args) async {
  BasicScreen screen = BasicScreen();

  SocketServer server = SocketServer("0.0.0.0", 24800);

  await SynergyClientDart.connect(
    screen: screen,
    synergyServer: server,
    clientName: "flutter",
  );
}

class BasicScreen extends ScreenInterface {
  @override
  void onConnect() {
    print("Connected");
  }

  @override
  void onDisconnect() {
    print("Disconnected");
  }

  @override
  void onError(String error) {
    print("Error $error");
  }

  @override
  void enter(int x, int y, int sequenceNumber, int toggleMask) {}

  @override
  CursorPosition getCursorPos() {
    return CursorPosition(0, 0);
  }

  @override
  RectObj getShape() {
    return RectObj(width: 1920, height: 1080);
  }
}
