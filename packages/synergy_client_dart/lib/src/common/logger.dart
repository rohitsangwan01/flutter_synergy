import 'dart:developer' as developer;

typedef LogHandler = void Function(String message, LogLevel? level);

class Logger {
  static LogLevel level = LogLevel.debug;

  static LogHandler? logHandler;

  /// Log a message to the console.
  static void log(message, [LogLevel? level = LogLevel.debug]) {
    if (level != null && level.index > Logger.level.index) return;
    logHandler?.call(message.toString(), level);
    developer.log(message.toString(), name: 'SynergyClientDart');
  }
}

enum LogLevel {
  info,
  warning,
  error,
  debug,
  debug1,
}
