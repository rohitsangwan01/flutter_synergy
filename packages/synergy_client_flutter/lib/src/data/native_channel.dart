import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:synergy_client_dart/synergy_client_dart.dart';
import 'package:synergy_client_flutter/src/data/keyboard_handler.dart';

/// For native communications using method channels
class NativeChannel {
  final MethodChannel _channel = const MethodChannel('synergy_client_flutter');

  Future<void> handleKeyDown(int keyEventID, int mask, int button) async {
    await _simulateKey(
      keyEventID: keyEventID,
      isDown: true,
      isRepeat: false,
    );
  }

  Future<void> handleKeyRepeat(
      int keyEventID, int mask, int count, int button) async {
    await _simulateKey(
      keyEventID: keyEventID,
      isDown: true,
      isRepeat: true,
      repeatCount: count,
    );
  }

  Future<void> handleKeyUp(int keyEventID, int mask, int button) async {
    await _simulateKey(
      keyEventID: keyEventID,
      isDown: false,
      isRepeat: false,
    );
  }

  Future<void> _simulateKey({
    required int keyEventID,
    required bool isDown,
    required bool isRepeat,
    int repeatCount = 0,
  }) async {
    LogicalKeyboardKey? logicalKeyboardKey = keyEventID.logicalKeyboardKey;
    if (logicalKeyboardKey == null) {
      Logger.log('Unknown key: $keyEventID Down: $isDown', LogLevel.debug1);
      return;
    }

    int? keyCode = _getKeyCode(logicalKeyboardKey);

    if (keyCode == null) {
      Logger.log(
        'KeyCode not found: $keyEventID Down: $isDown',
        LogLevel.debug1,
      );
      return;
    }

    _channel.invokeMethod('simulateKey', {
      'keyCode': keyCode,
      'isDown': isDown,
      'isRepeat': isRepeat,
      'repeatCount': repeatCount,
    });
  }

  static int? _getKeyCode(LogicalKeyboardKey key) {
    if (kIsWeb) return null;
    Map<int, LogicalKeyboardKey> map = {};
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        map = kAndroidToLogicalKey;
        break;
      case TargetPlatform.fuchsia:
        map = kFuchsiaToLogicalKey;
        break;
      case TargetPlatform.linux:
        map = kGlfwToLogicalKey;
        break;
      case TargetPlatform.windows:
        map = kWindowsToLogicalKey;
        break;
      default:
        // macOS doesn't do key codes, just scan codes.
        // iOS doesn't do key codes, just scan codes.
        // web doesn't have int type code.
        return null;
    }
    int? keyCode;
    for (final int code in map.keys) {
      if (key.keyId == map[code]!.keyId) {
        keyCode = code;
        break;
      }
    }
    return keyCode;
  }
}
