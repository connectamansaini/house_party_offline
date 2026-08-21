import 'package:dio/dio.dart';

class APIException implements Exception {
  const APIException({required this.message, this.code, this.statusCode});

  factory APIException.fromDioException(DioException error) {
    final statusCode = error.response?.statusCode;

    if (error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.receiveTimeout ||
        error.type == DioExceptionType.sendTimeout) {
      return APIException(
        message: 'Request timed out. Please try again.',
        code: 'timeout',
        statusCode: statusCode,
      );
    }

    if (error.type == DioExceptionType.connectionError) {
      return APIException(
        message: 'No internet connection.',
        code: 'connection_error',
        statusCode: statusCode,
      );
    }

    if (error.type == DioExceptionType.badResponse) {
      return APIException(
        message: 'Request failed (${statusCode ?? 'unknown'}).',
        code: 'bad_response',
        statusCode: statusCode,
      );
    }

    return APIException(
      message: error.message ?? 'Unexpected error.',
      code: 'unknown',
      statusCode: statusCode,
    );
  }

  final String message;
  final String? code;
  final int? statusCode;

  @override
  String toString() {
    final status = statusCode == null ? '' : ' (HTTP $statusCode)';
    final c = code == null ? '' : ' [$code]';
    return '$message$status$c';
  }
}
