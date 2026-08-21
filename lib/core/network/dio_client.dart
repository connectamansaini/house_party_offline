import 'package:dio/dio.dart';

import 'api_exception.dart';

class DioClient {
  DioClient(this._dio);

  final Dio _dio;

  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      return await _dio.get<T>(
        path,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
    } on DioException catch (error) {
      throw _normalizeError(error);
    }
  }

  Future<Response<T>> post<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      return await _dio.post<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
    } on DioException catch (error) {
      throw _normalizeError(error);
    }
  }

  APIException _normalizeError(DioException error) {
    final normalized = error.error;
    if (normalized is APIException) {
      return normalized;
    }
    return APIException.fromDioException(error);
  }
}
