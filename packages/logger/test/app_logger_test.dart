import 'package:logger/logger.dart';
import 'package:test/test.dart';

void main() {
  group('AppLogger', () {
    test('respects minLevel filtering', () {
      final lines = <String>[];
      final logger = AppLogger(
        minLevel: LogLevel.warning,
        output: lines.add,
      );

      logger.debug('hidden');
      logger.info('hidden');
      logger.warning('visible');
      logger.error('visible');

      expect(lines.length, 2);
    });

    test('includes error and stack trace', () {
      final lines = <String>[];
      final logger = AppLogger(output: lines.add);
      final stack = StackTrace.current;

      logger.error('boom', Exception('test'), stack);

      expect(lines.single, contains('boom'));
      expect(lines.single, contains('test'));
      expect(lines.single, contains('stack'));
    });

    test('JSON printer emits structured output', () {
      final lines = <String>[];
      final logger = AppLogger(
        printer: const JsonLogPrinter(),
        output: lines.add,
      );

      logger.info('hello');

      expect(lines.single, contains('"level": "info"'));
      expect(lines.single, contains('"message": "hello"'));
    });
  });
}
