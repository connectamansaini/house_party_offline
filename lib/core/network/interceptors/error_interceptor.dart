import 'package:dio/dio.dart';

import '../api_exception.dart';

class ErrorInterceptor extends Interceptor {
  const ErrorInterceptor();

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    handler.reject(
      DioException(
        requestOptions: err.requestOptions,
        response: err.response,
        error: APIException.fromDioException(err),
        type: err.type,
        message: err.message,
      ),
    );
  }
}
