import 'package:synergy_client_dart/src/models/models_export.dart';

abstract class ScreenInterface {
  // To update client info, like screen size, etc.
  Function()? updateClientInfo;

  RectObj getShape();

  CursorPosition getCursorPos();

  void onConnect() {
    // Handle connection to socket
  }

  void onDisconnect() {
    // Handle disconnection from socket
  }

  void onError(String error) {
    // Handle error messages from socket
  }

  void enter(int x, int y, int sequenceNumber, int toggleMask) {
    // Default implementation (does nothing)
  }

  bool leave() {
    // Default implementation (does nothing)
    return false;
  }

  void keyDown(int keyEventID, int mask, int button) {
    // Default implementation (does nothing)
  }

  void keyUp(int keyEventID, int mask, int button) {
    // Default implementation (does nothing)
  }

  void keyRepeat(int keyEventID, int mask, int count, int button) {
    // Default implementation (does nothing)
  }

  void mouseDown(int buttonID) {
    // Default implementation (does nothing)
  }

  void mouseUp(int buttonID) {
    // Default implementation (does nothing)
  }

  void mouseMove(int x, int y) {
    // Default implementation (does nothing)
  }

  void mouseRelativeMove(int x, int y) {
    // Default implementation (does nothing)
  }

  void mouseWheel(int x, int y) {
    // Default implementation (does nothing)
  }
}
