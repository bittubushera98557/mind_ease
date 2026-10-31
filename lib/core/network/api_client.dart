import 'dart:async';
import 'dart:convert';
import 'dart:developer' as developer;
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../config/app_constants.dart';
import '../config/env_config.dart';
import 'api_exception.dart';
import 'api_response.dart';

/// MindEase Centralized HTTP API Client
class ApiClient {
  final http.Client _httpClient;
  final EnvConfig _config;

  ApiClient({
    http.Client? httpClient,
    EnvConfig? config,
  })  : _httpClient = httpClient ?? http.Client(),
        _config = config ?? EnvConfig.instance;

  String? _authToken;

  void setAuthToken(String? token) {
    _authToken = token;
  }

  Future<String?> getAuthToken() async {
    if (_authToken != null) return _authToken;
    try {
      final prefs = await SharedPreferences.getInstance();
      _authToken = prefs.getString(AppConstants.keyAuthToken);
      return _authToken;
    } catch (_) {
      return null;
    }
  }

  Future<void> saveAuthToken(String token) async {
    _authToken = token;
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(AppConstants.keyAuthToken, token);
    } catch (_) {}
  }

  Future<void> clearAuthToken() async {
    _authToken = null;
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(AppConstants.keyAuthToken);
    } catch (_) {}
  }

  Future<Map<String, String>> _getHeaders({Map<String, String>? extraHeaders}) async {
    final token = await getAuthToken();
    final headers = <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    if (token != null && token.isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
    }

    if (extraHeaders != null) {
      headers.addAll(extraHeaders);
    }

    return headers;
  }

  Uri _buildUri(String path, [Map<String, dynamic>? queryParameters]) {
    final base = _config.apiBaseUrl;
    final cleanPath = path.startsWith('/') ? path : '/$path';
    final fullUrl = '$base$cleanPath';

    if (queryParameters == null || queryParameters.isEmpty) {
      return Uri.parse(fullUrl);
    }

    final stringParams = queryParameters.map((k, v) => MapEntry(k, v.toString()));
    return Uri.parse(fullUrl).replace(queryParameters: stringParams);
  }

  void _log(String message) {
    if (_config.enableLogging) {
      developer.log('[API] $message', name: 'MindEase.ApiClient');
    }
  }

  Future<ApiResponse<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
    T Function(dynamic json)? fromJson,
  }) async {
    return _sendRequest<T>(
      method: 'GET',
      path: path,
      queryParameters: queryParameters,
      headers: headers,
      fromJson: fromJson,
    );
  }

  Future<ApiResponse<T>> post<T>(
    String path, {
    dynamic body,
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
    T Function(dynamic json)? fromJson,
  }) async {
    return _sendRequest<T>(
      method: 'POST',
      path: path,
      body: body,
      queryParameters: queryParameters,
      headers: headers,
      fromJson: fromJson,
    );
  }

  Future<ApiResponse<T>> put<T>(
    String path, {
    dynamic body,
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
    T Function(dynamic json)? fromJson,
  }) async {
    return _sendRequest<T>(
      method: 'PUT',
      path: path,
      body: body,
      queryParameters: queryParameters,
      headers: headers,
      fromJson: fromJson,
    );
  }

  Future<ApiResponse<T>> delete<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
    T Function(dynamic json)? fromJson,
  }) async {
    return _sendRequest<T>(
      method: 'DELETE',
      path: path,
      queryParameters: queryParameters,
      headers: headers,
      fromJson: fromJson,
    );
  }

  Future<ApiResponse<T>> _sendRequest<T>({
    required String method,
    required String path,
    dynamic body,
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
    T Function(dynamic json)? fromJson,
  }) async {
    final uri = _buildUri(path, queryParameters);
    final requestHeaders = await _getHeaders(extraHeaders: headers);

    _log('==> $method $uri');
    if (body != null) {
      _log('Payload: ${jsonEncode(body)}');
    }

    try {
      http.Response response;
      final encodedBody = body != null ? jsonEncode(body) : null;

      final requestFuture = () {
        switch (method) {
          case 'POST':
            return _httpClient.post(uri, headers: requestHeaders, body: encodedBody);
          case 'PUT':
            return _httpClient.put(uri, headers: requestHeaders, body: encodedBody);
          case 'DELETE':
            return _httpClient.delete(uri, headers: requestHeaders);
          case 'GET':
          default:
            return _httpClient.get(uri, headers: requestHeaders);
        }
      }();

      response = await requestFuture.timeout(_config.apiTimeout);

      _log('<== [${response.statusCode}] $method $uri');
      _log('Body: ${response.body}');

      return _processResponse<T>(response, fromJson);
    } on SocketException catch (e) {
      _log('Network Error: $e');
      throw const NetworkException();
    } on TimeoutException catch (e) {
      _log('Timeout Error: $e');
      throw const TimeoutException();
    } on ApiException {
      rethrow;
    } catch (e) {
      _log('Unexpected Error: $e');
      throw ApiException(message: e.toString());
    }
  }

  ApiResponse<T> _processResponse<T>(
    http.Response response,
    T Function(dynamic json)? fromJson,
  ) {
    dynamic decoded;
    if (response.body.isNotEmpty) {
      try {
        decoded = jsonDecode(response.body);
      } catch (_) {
        decoded = response.body;
      }
    }

    final statusCode = response.statusCode;

    if (statusCode >= 200 && statusCode < 300) {
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

    // Error mapping
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
      throw UnauthorizedException(message: errorMessage, details: decoded);
    } else if (statusCode == 404) {
      throw NotFoundException(message: errorMessage, details: decoded);
    } else if (statusCode == 422) {
      Map<String, dynamic>? errors;
      if (decoded is Map<String, dynamic> && decoded['errors'] is Map<String, dynamic>) {
        errors = decoded['errors'] as Map<String, dynamic>;
      }
      throw ValidationException(message: errorMessage, errors: errors);
    } else if (statusCode >= 500) {
      throw ServerException(message: errorMessage, statusCode: statusCode, details: decoded);
    } else {
      throw ApiException(
        message: errorMessage,
        statusCode: statusCode,
        code: errorCode,
        field: errorField,
        details: decoded,
      );
    }
  }
}
