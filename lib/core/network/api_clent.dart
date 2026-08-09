import 'dart:io';

import 'package:dio/dio.dart';
import 'package:expense_tracker/core/network/base_url.dart';

import 'api_exception.dart';

class ApiClient {
  late final Dio _dio;

  ApiClient() {
    _dio = Dio(
      BaseOptions(
        baseUrl: BaseUrl.apiUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        sendTimeout: const Duration(seconds: 30),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      ),
    );

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          print('${options.method} ${options.uri}');
          print('Request: ${options.data}');
          handler.next(options);
        },
        onResponse: (response, handler) {
          print(
            '${response.statusCode} '
            '${response.requestOptions.uri}',
          );
          handler.next(response);
        },
        onError: (error, handler) {
          print(
            '${error.response?.statusCode} '
            '${error.requestOptions.uri}',
          );
          handler.next(error);
        },
      ),
    );
  }

  // GET
  Future<Response<T>> get<T>(
    String endpoint, {
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  }) async {
    try {
      return await _dio.get<T>(
        endpoint,
        queryParameters: queryParameters,
        options: Options(headers: headers),
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // POST
  Future<Response<T>> post<T>(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  }) async {
    try {
      return await _dio.post<T>(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        options: Options(headers: headers),
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // PUT
  Future<Response<T>> put<T>(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  }) async {
    try {
      return await _dio.put<T>(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        options: Options(headers: headers),
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // PATCH
  Future<Response<T>> patch<T>(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  }) async {
    try {
      return await _dio.patch<T>(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        options: Options(headers: headers),
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // DELETE
  Future<Response<T>> delete<T>(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  }) async {
    try {
      return await _dio.delete<T>(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        options: Options(headers: headers),
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // UPLOAD FILE
  Future<Response<T>> uploadFile<T>(
    String endpoint, {
    required String filePath,
    String fieldName = 'file',
    Map<String, dynamic>? data,
    ProgressCallback? onSendProgress,
  }) async {
    try {
      final file = await MultipartFile.fromFile(
        filePath,
        filename: filePath.split(Platform.pathSeparator).last,
      );

      final formData = FormData.fromMap({...?data, fieldName: file});

      return await _dio.post<T>(
        endpoint,
        data: formData,
        options: Options(contentType: 'multipart/form-data'),
        onSendProgress: onSendProgress,
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // DOWNLOAD FILE
  Future<Response> downloadFile(
    String endpoint,
    String savePath, {
    Map<String, dynamic>? queryParameters,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      return await _dio.download(
        endpoint,
        savePath,
        queryParameters: queryParameters,
        onReceiveProgress: onReceiveProgress,
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // SET TOKEN
  void setToken(String token) {
    _dio.options.headers['Authorization'] = 'Bearer $token';
  }

  // REMOVE TOKEN
  void removeToken() {
    _dio.options.headers.remove('Authorization');
  }

  // ERROR HANDLING
  ApiException _handleError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        return ApiException(message: 'Connection timeout');

      case DioExceptionType.sendTimeout:
        return ApiException(message: 'Request timeout');

      case DioExceptionType.receiveTimeout:
        return ApiException(message: 'Response timeout');

      case DioExceptionType.connectionError:
        return ApiException(message: 'No internet connection');

      case DioExceptionType.badResponse:
        return ApiException(
          message: _getErrorMessage(error),
          statusCode: error.response?.statusCode,
        );

      case DioExceptionType.cancel:
        return ApiException(message: 'Request cancelled');

      default:
        return ApiException(message: 'Something went wrong');
    }
  }

  String _getErrorMessage(DioException error) {
    final data = error.response?.data;

    if (data is Map<String, dynamic>) {
      return data['message']?.toString() ??
          data['error']?.toString() ??
          'Server error';
    }

    return 'Server error';
  }
}
