import 'package:dio/dio.dart';

import '../env/environment.dart';
import 'api_exception.dart';

/// Configured [Dio] client with interceptors and error mapping.
class DioClient {
  DioClient({required Environment environment, Dio? dio})
      : _dio = dio ?? Dio() {
    _dio.options = BaseOptions(
      baseUrl: environment.baseUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      headers: {'Accept': 'application/json'},
    );
    _dio.interceptors.add(
      InterceptorsWrapper(
        onError: (e, handler) => handler.reject(
          DioException(
            requestOptions: e.requestOptions,
            error: ApiException.fromDio(e),
            type: e.type,
          ),
        ),
      ),
    );
  }

  final Dio _dio;

  Dio get raw => _dio;

  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) =>
      _dio.get<T>(path, queryParameters: queryParameters);

  Future<Response<T>> post<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
  }) =>
      _dio.post<T>(path, data: data, queryParameters: queryParameters);
}
