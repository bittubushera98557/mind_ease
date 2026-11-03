import 'dart:convert';
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
    dynamic decoded = response.data;

    if (decoded is String && decoded.trim().startsWith('{')) {
      try {
        decoded = jsonDecode(decoded);
      } catch (_) {}
    }

    String errorMessage = 'An error occurred. Please try again.';
    String? errorCode;
    String? errorField;

    if (decoded is Map<String, dynamic>) {
      if (decoded.containsKey('error') && decoded['error'] != null) {
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
      } else if (decoded.containsKey('message') && decoded['message'] != null) {
        final msg = decoded['message'];
        if (msg is List) {
          errorMessage = msg.join('\n');
        } else {
          errorMessage = msg.toString();
        }
      } else if (decoded.containsKey('errors') && decoded['errors'] != null) {
        final errs = decoded['errors'];
        if (errs is Map<String, dynamic> && errs.isNotEmpty) {
          final firstEntry = errs.entries.first;
          errorField = firstEntry.key;
          if (firstEntry.value is List && (firstEntry.value as List).isNotEmpty) {
            errorMessage = (firstEntry.value as List).first.toString();
          } else {
            errorMessage = firstEntry.value.toString();
          }
        } else if (errs is List && errs.isNotEmpty) {
          errorMessage = errs.first.toString();
        }
      }
    }

    // Meaningful fallbacks if parsing didn't extract a custom message
    if (errorMessage == 'An error occurred. Please try again.') {
      if (statusCode == 401) {
        errorMessage = "That email and password don't match. Please try again.";
      } else if (statusCode == 409) {
        errorMessage = "An account with this email already exists.";
      } else if (statusCode == 404) {
        errorMessage = "We couldn't find an account with that email. Check it or sign up.";
      }
    }

    if (statusCode == 401) {
      return UnauthorizedException(
        message: errorMessage,
        code: errorCode ?? 'invalid_credentials',
        field: errorField,
        details: decoded,
      );
    } else if (statusCode == 409) {
      return ConflictException(
        message: errorMessage,
        code: errorCode ?? 'email_taken',
        field: errorField ?? 'email',
        details: decoded,
      );
    } else if (statusCode == 404) {
      return NotFoundException(
        message: errorMessage,
        code: errorCode,
        field: errorField,
        details: decoded,
      );
    } else if (statusCode == 422) {
      Map<String, dynamic>? errors;
      if (decoded is Map<String, dynamic> && decoded['errors'] is Map<String, dynamic>) {
        errors = decoded['errors'] as Map<String, dynamic>;
      }
      return ValidationException(
        message: errorMessage,
        code: errorCode,
        field: errorField,
        errors: errors,
      );
    } else if (statusCode != null && statusCode >= 500) {
      return ServerException(
        message: errorMessage,
        statusCode: statusCode,
        code: errorCode,
        field: errorField,
        details: decoded,
      );
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

  Future<ApiResponse<T>> patch<T>(
    String path, {
    dynamic body,
    Map<String, dynamic>? queryParameters,
    Options? options,
    T Function(dynamic json)? fromJson,
  }) async {
    try {
      final response = await dio.patch(
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
