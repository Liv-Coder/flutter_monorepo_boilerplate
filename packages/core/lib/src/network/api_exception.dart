import 'package:dio/dio.dart';

/// Application-level exception mapped from [DioException].
class ApiException implements Exception {
  const ApiException({
    required this.message,
    this.statusCode,
    this.type = ApiExceptionType.unknown,
  });

  factory ApiException.fromDio(DioException e) {
    return switch (e.type) {
      DioExceptionType.connectionTimeout ||
      DioExceptionType.sendTimeout ||
      DioExceptionType.receiveTimeout =>
        const ApiException(
          message: 'Request timed out. Check your connection.',
          type: ApiExceptionType.timeout,
        ),
      DioExceptionType.connectionError => const ApiException(
          message: 'No internet connection.',
          type: ApiExceptionType.network,
        ),
      DioExceptionType.badResponse => ApiException(
          message: _messageForStatus(e.response?.statusCode),
          statusCode: e.response?.statusCode,
          type: ApiExceptionType.server,
        ),
      DioExceptionType.cancel => const ApiException(
          message: 'Request cancelled.',
          type: ApiExceptionType.cancelled,
        ),
      _ => ApiException(
          message: e.message ?? 'An unknown error occurred.',
          type: ApiExceptionType.unknown,
        ),
    };
  }

  final String message;
  final int? statusCode;
  final ApiExceptionType type;

  static String _messageForStatus(int? code) {
    return switch (code) {
      400 => 'Bad request.',
      401 => 'Unauthorized. Please sign in again.',
      403 => 'Forbidden.',
      404 => 'Resource not found.',
      500 => 'Server error. Try again later.',
      _ => 'Unexpected error ($code).',
    };
  }

  @override
  String toString() => 'ApiException($type, $statusCode): $message';
}

enum ApiExceptionType { timeout, network, server, cancelled, unknown }
