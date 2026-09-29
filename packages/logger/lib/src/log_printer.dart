import 'dart:convert';

import 'log_level.dart';

/// Formats a log record for output.
abstract class LogPrinter {
  const LogPrinter();

  String format(LogLevel level, String message,
      [Object? error, StackTrace? st]);
}

/// Default printer: timestamp, level, message.
class PrettyLogPrinter extends LogPrinter {
  const PrettyLogPrinter();

  @override
  String format(LogLevel level, String message,
      [Object? error, StackTrace? st]) {
    final now = DateTime.now().toIso8601String();
    final tag = level.name.toUpperCase().padRight(7);
    final buffer = StringBuffer('$now [$tag] $message');
    if (error != null) buffer.write('\n  error: $error');
    if (st != null) buffer.write('\n  stack: $st');
    return buffer.toString();
  }
}

/// Machine-readable JSON printer for structured logging pipelines.
class JsonLogPrinter extends LogPrinter {
  const JsonLogPrinter();

  @override
  String format(LogLevel level, String message,
      [Object? error, StackTrace? st]) {
    final map = <String, dynamic>{
      'timestamp': DateTime.now().toIso8601String(),
      'level': level.name,
      'message': message,
      if (error != null) 'error': error.toString(),
      if (st != null) 'stack': st.toString(),
    };
    return const JsonEncoder.withIndent('  ').convert(map);
  }
}
