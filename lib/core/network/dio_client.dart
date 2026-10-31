import 'dart:developer' as developer;
import 'package:dio/dio.dart';
import '../config/env_config.dart';
import '../services/secure_storage_service.dart';
import 'api_exception.dart';
import 'api_response.dart';

/// MindEase Centralized Dio API Client
class DioClient {
  late final Dio dio;
  final SecureStorageService _storageService;

  DioClient({
    Dio? dioOverride,
    SecureStorageService? storageService,
  }) : _storageService = storageService ?? SecureStorageService() {
    final config = EnvConfig.instance;

    dio = dioOverride ??
        Dio(
          BaseOptions(
            baseUrl: config.apiBaseUrl,
            connectTimeout: config.apiTimeout,
            receiveTimeout: config.apiTimeout,
            sendTimeout: config.apiTimeout,
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
          ),
        );

    _setupInterceptors();
  }

  void _setupInterceptors() {
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await _storageService.getAccessToken();
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          if (EnvConfig.instance.enableLogging) {
            developer.log('==> [DIO] ${options.method} ${options.uri}', name: 'MindEase.DioClient');
            if (options.data != null) {
              developer.log('Payload: ${options.data}', name: 'MindEase.DioClient');
            }
          }
          return handler.next(options);
        },
        onResponse: (response, handler) {
          if (EnvConfig.instance.enableLogging) {
            developer.log('<== [DIO] [${response.statusCode}] ${response.requestOptions.uri}', name: 'MindEase.DioClient');
            developer.log('Data: ${response.data}', name: 'MindEase.DioClient');
          }
          return handler.next(response);
        },
        onError: (DioException error, handler) {
          if (EnvConfig.instance.enableLogging) {
            developer.log('ERROR [DIO] [${error.response?.statusCode}] ${error.requestOptions.uri}: ${error.message}', name: 'MindEase.DioClient');
          }
          return handler.next(error);
        },
      ),
    );
  }

  ApiException _handleDioError(DioException error) {
    if (error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.sendTimeout ||
        error.type == DioExceptionType.receiveTimeout) {
      return const TimeoutException();
    }

    if (error.type == DioExceptionType.connectionError) {
      return const NetworkException();
    }

    final response = error.response;
    if (response == null) {
      return ApiException(message: error.message ?? 'Network connection issue');
    }

    final statusCode = response.statusCode;
    final decoded = response.data;

    String errorMessage = 'An error occurred. Please try again.';
    String? errorCode;
    String? errorField;

    if (decoded is Map<String, dynamic>) {
      if (decoded.containsKey('message') && decoded['message'] != null) {
        errorMessage = decoded['message'].toString();
      } else if (decoded.containsKey('error') && decoded['error'] != null) {
        final err = decoded['error'];
        if (err is Map<String, dynamic>) {
          if (err.containsKey('message') && err['message'] != null) {
            errorMessage = err['message'].toString();
          }
          if (err.containsKey('code') && err['code'] != null) {
            errorCode = err['code']?.toString();
          }
          if (err.containsKey('field') && err['field'] != null) {
            errorField = err['field']?.toString();
          }
        } else if (err is String) {
          errorMessage = err;
        }
      }
    }

    if (statusCode == 401) {
      return UnauthorizedException(message: errorMessage, details: decoded);
    } else if (statusCode == 404) {
      return NotFoundException(message: errorMessage, details: decoded);
    } else if (statusCode == 422) {
      Map<String, dynamic>? errors;
      if (decoded is Map<String, dynamic> && decoded['errors'] is Map<String, dynamic>) {
        errors = decoded['errors'] as Map<String, dynamic>;
      }
      return ValidationException(message: errorMessage, errors: errors);
    } else if (statusCode != null && statusCode >= 500) {
      return ServerException(message: errorMessage, statusCode: statusCode, details: decoded);
    } else {
      return ApiException(
        message: errorMessage,
        statusCode: statusCode,
        code: errorCode,
        field: errorField,
        details: decoded,
      );
    }
  }

  Future<ApiResponse<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    T Function(dynamic json)? fromJson,
  }) async {
    try {
      final response = await dio.get(
        path,
        queryParameters: queryParameters,
        options: options,
      );
      return _processResponse<T>(response, fromJson);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<ApiResponse<T>> post<T>(
    String path, {
    dynamic body,
    Map<String, dynamic>? queryParameters,
    Options? options,
    T Function(dynamic json)? fromJson,
  }) async {
    try {
      final response = await dio.post(
        path,
        data: body,
        queryParameters: queryParameters,
        options: options,
      );
      return _processResponse<T>(response, fromJson);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<ApiResponse<T>> put<T>(
    String path, {
    dynamic body,
    Map<String, dynamic>? queryParameters,
    Options? options,
    T Function(dynamic json)? fromJson,
  }) async {
    try {
      final response = await dio.put(
        path,
        data: body,
        queryParameters: queryParameters,
        options: options,
      );
      return _processResponse<T>(response, fromJson);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<ApiResponse<T>> delete<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    T Function(dynamic json)? fromJson,
  }) async {
    try {
      final response = await dio.delete(
        path,
        queryParameters: queryParameters,
        options: options,
      );
      return _processResponse<T>(response, fromJson);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  ApiResponse<T> _processResponse<T>(
    Response response,
    T Function(dynamic json)? fromJson,
  ) {
    final decoded = response.data;
    final statusCode = response.statusCode ?? 200;

    T? parsedData;
    if (decoded != null && fromJson != null) {
      parsedData = fromJson(decoded);
    } else if (decoded is T) {
      parsedData = decoded;
    }

    String? message;
    if (decoded is Map<String, dynamic> && decoded.containsKey('message')) {
      message = decoded['message']?.toString();
    }

    return ApiResponse<T>.success(
      statusCode: statusCode,
      data: parsedData,
      message: message,
    );
  }
}
