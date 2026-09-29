/// Severity levels ordered from least to most severe.
enum LogLevel {
  trace(0),
  debug(1),
  info(2),
  warning(3),
  error(4),
  fatal(5);

  const LogLevel(this.severity);
  final int severity;

  bool operator >=(LogLevel other) => severity >= other.severity;
}
