import 'package:core/core.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Result', () {
    test('Success carries a value', () {
      const result = Success(42);
      expect(result.value, 42);
    });

    test('Failure carries an error', () {
      const result = Failure<String>('boom');
      expect(result.error, 'boom');
    });

    test('pattern matching is exhaustive', () {
      const Result<int> result = Success(1);
      final message = switch (result) {
        Success(value: final v) => 'ok: $v',
        Failure(error: final e) => 'fail: $e',
      };
      expect(message, 'ok: 1');
    });
  });
}
