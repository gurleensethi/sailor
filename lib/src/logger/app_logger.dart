import 'package:meta/meta.dart';

enum _LogLevel { warning, error }

String _logLevelToString(_LogLevel level) {
  return level.toString().split(".")[1].toUpperCase();
}

class AppLogger {
  static AppLogger _instance;

  final bool isLoggerEnabled;

  AppLogger._internal({
    @required this.isLoggerEnabled,
  });

  static void init({
    bool isLoggerEnabled,
  }) {
    _instance = AppLogger._internal(
      isLoggerEnabled: isLoggerEnabled,
    );
  }

  static AppLogger get instance => _instance;

  void warning(String message) {
    _log(
      level: _LogLevel.warning,
      message: message,
      time: DateTime.now(),
    );
  }

  void _log({
    String message,
    _LogLevel level,
    DateTime time,
  }) {
    if (this.isLoggerEnabled) {
      print("[Sailor] ${_logLevelToString(level)} : $message");
    }
  }
}
