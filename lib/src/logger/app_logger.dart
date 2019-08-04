import 'package:meta/meta.dart';

enum _LogLevel { info, warning, error }

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

  void info(String message) {
    _log(
      level: _LogLevel.info,
      message: message,
    );
  }

  void warning(String message) {
    _log(
      level: _LogLevel.warning,
      message: message,
    );
  }

  void _log({
    String message,
    _LogLevel level,
  }) {
    if (this.isLoggerEnabled) {
      print("[Sailor] ${_logLevelToString(level)} : $message");
    }
  }
}
