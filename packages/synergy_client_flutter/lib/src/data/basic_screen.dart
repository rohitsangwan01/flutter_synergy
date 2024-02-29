import 'dart:developer';

import 'package:flutter/gestures.dart';
import 'package:synergy_client_dart/synergy_client_dart.dart';
import 'package:synergy_client_flutter/src/data/keyboard_handler.dart';
import 'package:synergy_client_flutter/src/synergy_client_flutter_controller.dart';

class BasicScreen extends ScreenInterface {
  final SynergyClientController controller;
  BasicScreen(this.controller);
  final KeyboardHandler? _keyboardHandler = KeyboardHandler.defaultHandler;

  double? width;
  double? height;
  Offset? cursorPos;
  Offset? mouseDownPos;

  void handleShape(double width, double height) {
    if (this.width != null || this.height != null) {
      bool isChanged = this.width != width || this.height != height;
      if (!isChanged) return;
      this.width = width;
      this.height = height;
      updateClientInfo?.call();
    } else {
      this.width = width;
      this.height = height;
    }
  }

  @override
  RectObj getShape() => RectObj(width: width!, height: height!);

  @override
  CursorPosition getCursorPos() => CursorPosition(0, 0);

  @override
  void enter(int x, int y, int sequenceNumber, int toggleMask) {
    controller.showCursor.value = true;
  }

  @override
  bool leave() {
    controller.showCursor.value = false;
    return true;
  }

  @override
  void onConnect() {
    log('Connected to server');
    controller.isConnected.value = true;
  }

  @override
  void onDisconnect() {
    log('Disconnected from server');
    controller.isConnected.value = false;
  }

  @override
  void onError(String error) {
    log('Error: $error');
    controller.logs.add(error);
  }

  @override
  void mouseMove(int x, int y) {
    cursorPos = Offset(x.toDouble(), y.toDouble());
    controller.mouseCursorPos.value = cursorPos!;
  }

  @override
  void mouseDown(int buttonID) {
    if (cursorPos != null) {
      mouseDownPos = cursorPos;
      GestureBinding.instance.handlePointerEvent(
        PointerDownEvent(
          kind: PointerDeviceKind.touch,
          position: mouseDownPos!,
        ),
      );
    }
  }

  @override
  void mouseUp(int buttonID) {
    if (mouseDownPos != null) {
      GestureBinding.instance.handlePointerEvent(
        PointerUpEvent(
          kind: PointerDeviceKind.touch,
          position: mouseDownPos!,
        ),
      );
      mouseDownPos = null;
    }
  }

  @override
  void mouseWheel(int x, int y) {
    if (cursorPos != null) {
      GestureBinding.instance.handlePointerEvent(
        PointerScrollEvent(
          kind: PointerDeviceKind.touch,
          position: cursorPos!,
          scrollDelta: Offset(-x.toDouble(), -y.toDouble()),
        ),
      );
    }
  }

  @override
  void keyDown(int keyEventID, int mask, int button) async {
    await _keyboardHandler?.handleKeyDown(keyEventID, mask, button);
  }

  @override
  void keyRepeat(int keyEventID, int mask, int count, int button) async {
    await _keyboardHandler?.handleKeyRepeat(keyEventID, mask, count, button);
  }

  @override
  void keyUp(int keyEventID, int mask, int button) async {
    await _keyboardHandler?.handleKeyUp(keyEventID, mask, button);
  }
}
