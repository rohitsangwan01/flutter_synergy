import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:synergy_client_flutter/src/data/native_channel.dart';

/// Handles keyboard events
abstract class KeyboardHandler {
  // Returns the default keyboard handler for the current platform
  static KeyboardHandler? get defaultHandler {
    if (kIsWeb) return null;
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return AndroidKeyboardHandler();
      default:
        return null;
    }
  }

  Future<void> handleKeyDown(int keyEventID, int mask, int button);

  Future<void> handleKeyRepeat(int keyEventID, int mask, int count, int button);

  Future<void> handleKeyUp(int keyEventID, int mask, int button);
}

/// Handle Android keyboard events
class AndroidKeyboardHandler extends KeyboardHandler {
  final NativeChannel _nativeChannel = NativeChannel();

  @override
  Future<void> handleKeyDown(int keyEventID, int mask, int button) =>
      _nativeChannel.handleKeyDown(keyEventID, mask, button);

  @override
  Future<void> handleKeyRepeat(
          int keyEventID, int mask, int count, int button) =>
      _nativeChannel.handleKeyRepeat(keyEventID, mask, count, button);

  @override
  Future<void> handleKeyUp(int keyEventID, int mask, int button) =>
      _nativeChannel.handleKeyUp(keyEventID, mask, button);
}

extension LogicalKeyboardKeyExtension on int {
  LogicalKeyboardKey? get logicalKeyboardKey => _keyTranslation[this];
}

/// Find a better way to parse the keyEventID to LogicalKeyboardKey
final Map<int, LogicalKeyboardKey> _keyTranslation = {
  'a'.codeUnitAt(0): LogicalKeyboardKey.keyA,
  'b'.codeUnitAt(0): LogicalKeyboardKey.keyB,
  'c'.codeUnitAt(0): LogicalKeyboardKey.keyC,
  'd'.codeUnitAt(0): LogicalKeyboardKey.keyD,
  'e'.codeUnitAt(0): LogicalKeyboardKey.keyE,
  'f'.codeUnitAt(0): LogicalKeyboardKey.keyF,
  'g'.codeUnitAt(0): LogicalKeyboardKey.keyG,
  'h'.codeUnitAt(0): LogicalKeyboardKey.keyH,
  'i'.codeUnitAt(0): LogicalKeyboardKey.keyI,
  'j'.codeUnitAt(0): LogicalKeyboardKey.keyJ,
  'k'.codeUnitAt(0): LogicalKeyboardKey.keyK,
  'l'.codeUnitAt(0): LogicalKeyboardKey.keyL,
  'm'.codeUnitAt(0): LogicalKeyboardKey.keyM,
  'n'.codeUnitAt(0): LogicalKeyboardKey.keyN,
  'o'.codeUnitAt(0): LogicalKeyboardKey.keyO,
  'p'.codeUnitAt(0): LogicalKeyboardKey.keyP,
  'q'.codeUnitAt(0): LogicalKeyboardKey.keyQ,
  'r'.codeUnitAt(0): LogicalKeyboardKey.keyR,
  's'.codeUnitAt(0): LogicalKeyboardKey.keyS,
  't'.codeUnitAt(0): LogicalKeyboardKey.keyT,
  'u'.codeUnitAt(0): LogicalKeyboardKey.keyU,
  'v'.codeUnitAt(0): LogicalKeyboardKey.keyV,
  'w'.codeUnitAt(0): LogicalKeyboardKey.keyW,
  'x'.codeUnitAt(0): LogicalKeyboardKey.keyX,
  'y'.codeUnitAt(0): LogicalKeyboardKey.keyY,
  'z'.codeUnitAt(0): LogicalKeyboardKey.keyZ,

  'A'.codeUnitAt(0): LogicalKeyboardKey.keyA,
  'B'.codeUnitAt(0): LogicalKeyboardKey.keyB,
  'C'.codeUnitAt(0): LogicalKeyboardKey.keyC,
  'D'.codeUnitAt(0): LogicalKeyboardKey.keyD,
  'E'.codeUnitAt(0): LogicalKeyboardKey.keyE,
  'F'.codeUnitAt(0): LogicalKeyboardKey.keyF,
  'G'.codeUnitAt(0): LogicalKeyboardKey.keyG,
  'H'.codeUnitAt(0): LogicalKeyboardKey.keyH,
  'I'.codeUnitAt(0): LogicalKeyboardKey.keyI,
  'J'.codeUnitAt(0): LogicalKeyboardKey.keyJ,
  'K'.codeUnitAt(0): LogicalKeyboardKey.keyK,
  'L'.codeUnitAt(0): LogicalKeyboardKey.keyL,
  'M'.codeUnitAt(0): LogicalKeyboardKey.keyM,
  'N'.codeUnitAt(0): LogicalKeyboardKey.keyN,
  'O'.codeUnitAt(0): LogicalKeyboardKey.keyO,
  'P'.codeUnitAt(0): LogicalKeyboardKey.keyP,
  'Q'.codeUnitAt(0): LogicalKeyboardKey.keyQ,
  'R'.codeUnitAt(0): LogicalKeyboardKey.keyR,
  'S'.codeUnitAt(0): LogicalKeyboardKey.keyS,
  'T'.codeUnitAt(0): LogicalKeyboardKey.keyT,
  'U'.codeUnitAt(0): LogicalKeyboardKey.keyU,
  'V'.codeUnitAt(0): LogicalKeyboardKey.keyV,
  'W'.codeUnitAt(0): LogicalKeyboardKey.keyW,
  'X'.codeUnitAt(0): LogicalKeyboardKey.keyX,
  'Y'.codeUnitAt(0): LogicalKeyboardKey.keyY,
  'Z'.codeUnitAt(0): LogicalKeyboardKey.keyZ,

  '0'.codeUnitAt(0): LogicalKeyboardKey.digit0,
  '1'.codeUnitAt(0): LogicalKeyboardKey.digit1,
  '2'.codeUnitAt(0): LogicalKeyboardKey.digit2,
  '3'.codeUnitAt(0): LogicalKeyboardKey.digit3,
  '4'.codeUnitAt(0): LogicalKeyboardKey.digit4,
  '5'.codeUnitAt(0): LogicalKeyboardKey.digit5,
  '6'.codeUnitAt(0): LogicalKeyboardKey.digit6,
  '7'.codeUnitAt(0): LogicalKeyboardKey.digit7,
  '8'.codeUnitAt(0): LogicalKeyboardKey.digit8,
  '9'.codeUnitAt(0): LogicalKeyboardKey.digit9,

  /**
   * Fix these by using shift key mask
 */
  '!'.codeUnitAt(0): LogicalKeyboardKey.digit1,
  '@'.codeUnitAt(0): LogicalKeyboardKey.digit2,
  '#'.codeUnitAt(0): LogicalKeyboardKey.digit3,
  '\$'.codeUnitAt(0): LogicalKeyboardKey.digit4,
  '%'.codeUnitAt(0): LogicalKeyboardKey.digit5,
  '^'.codeUnitAt(0): LogicalKeyboardKey.digit6,
  '&'.codeUnitAt(0): LogicalKeyboardKey.digit7,
  '*'.codeUnitAt(0): LogicalKeyboardKey.digit8,
  '('.codeUnitAt(0): LogicalKeyboardKey.digit9,
  ')'.codeUnitAt(0): LogicalKeyboardKey.digit0,
  '-'.codeUnitAt(0): LogicalKeyboardKey.minus,
  '_'.codeUnitAt(0): LogicalKeyboardKey.minus,
  '='.codeUnitAt(0): LogicalKeyboardKey.equal,
  '+'.codeUnitAt(0): LogicalKeyboardKey.equal,
  '?'.codeUnitAt(0): LogicalKeyboardKey.slash,
  '/'.codeUnitAt(0): LogicalKeyboardKey.slash,
  '.'.codeUnitAt(0): LogicalKeyboardKey.period,
  '>'.codeUnitAt(0): LogicalKeyboardKey.period,
  ','.codeUnitAt(0): LogicalKeyboardKey.comma,
  '<'.codeUnitAt(0): LogicalKeyboardKey.comma,

  61192: LogicalKeyboardKey.backspace,
  8: LogicalKeyboardKey.backspace,

  61197: LogicalKeyboardKey.enter,
  10: LogicalKeyboardKey.enter,
  13: LogicalKeyboardKey.enter,
  32: LogicalKeyboardKey.space,

  61265: LogicalKeyboardKey.arrowLeft,
  61266: LogicalKeyboardKey.arrowUp,
  61267: LogicalKeyboardKey.arrowRight,
  61268: LogicalKeyboardKey.arrowDown,

  61193: LogicalKeyboardKey.tab,

  61410: LogicalKeyboardKey.shiftRight,
  61409: LogicalKeyboardKey.shiftLeft,

  27: LogicalKeyboardKey.escape,
  61211: LogicalKeyboardKey.escape,

  63236: LogicalKeyboardKey.home, // F1 to HOME
  63237: LogicalKeyboardKey.contextMenu, // F2 to MENU
  63238: LogicalKeyboardKey.escape, // F3 to BACK
  63239: LogicalKeyboardKey.find, // F4 to SEARCH
  63240: LogicalKeyboardKey.power, // F5 to POWER

  61374: LogicalKeyboardKey.home, // F1 to HOME
  61375: LogicalKeyboardKey.contextMenu, // F2 to MENU
  61376: LogicalKeyboardKey.escape, // F3 to BACK
  61377: LogicalKeyboardKey.find, // F4 to SEARCH
  61378: LogicalKeyboardKey.power, // F5 to POWER
};
