import 'log_level.dart';
import 'log_printer.dart';

/// Application logger. One instance per app, configurable level and printer.
class AppLogger {
  AppLogger({
    this.minLevel = LogLevel.debug,
    this.printer = const PrettyLogPrinter(),
    void Function(String)? output,
  }) : _output = output ?? _defaultOutput;

  final LogLevel minLevel;
  final LogPrinter printer;
  final void Function(String) _output;

  static void _defaultOutput(String line) {
    // ignore: avoid_print
    print(line);
  }

  bool _shouldLog(LogLevel level) => level >= minLevel;

  void trace(String message, [Object? error, StackTrace? st]) =>
      _log(LogLevel.trace, message, error, st);

  void debug(String message, [Object? error, StackTrace? st]) =>
      _log(LogLevel.debug, message, error, st);

  void info(String message, [Object? error, StackTrace? st]) =>
      _log(LogLevel.info, message, error, st);

  void warning(String message, [Object? error, StackTrace? st]) =>
      _log(LogLevel.warning, message, error, st);

  void error(String message, [Object? error, StackTrace? st]) =>
      _log(LogLevel.error, message, error, st);

  void fatal(String message, [Object? error, StackTrace? st]) =>
      _log(LogLevel.fatal, message, error, st);

  void _log(LogLevel level, String message, Object? error, StackTrace? st) {
    if (!_shouldLog(level)) return;
    _output(printer.format(level, message, error, st));
  }
}
