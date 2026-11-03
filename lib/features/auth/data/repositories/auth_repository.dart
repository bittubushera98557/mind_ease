import 'dart:io';
import 'package:dio/dio.dart';

import '../../../../core/network/api_endpoints.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/services/secure_storage_service.dart';
import '../models/auth_response_model.dart';
import '../models/user_model.dart';

/// Auth Repository using Dio and Secure Storage
class AuthRepository {
  final DioClient _dioClient;
  final SecureStorageService _storageService;

  AuthRepository({
    DioClient? dioClient,
    SecureStorageService? storageService,
  })  : _dioClient = dioClient ?? DioClient(),
        _storageService = storageService ?? SecureStorageService();

  /// Registers a new user with name, email, and password.
  /// POST https://api.mindease.me/v1/auth/register
  Future<AuthResponseModel> register({
    required String name,
    required String email,
    required String password,
  }) async {
    final response = await _dioClient.post<AuthResponseModel>(
      ApiEndpoints.signUp,
      body: {
        'name': name,
        'email': email,
        'password': password,
      },
      fromJson: (json) => AuthResponseModel.fromJson(json as Map<String, dynamic>),
    );

    if (response.data != null) {
      final authData = response.data!;
      // Save tokens and user info securely via FlutterSecureStorage
      await _storageService.saveAccessToken(authData.accessToken);
      await _storageService.saveRefreshToken(authData.refreshToken);
      await _storageService.saveUserData(
        id: authData.user.id,
        name: authData.user.name,
        email: authData.user.email,
      );

      return authData;
    }

    throw Exception(response.message ?? 'Registration failed');
  }

  /// Logs in an existing user with email and password.
  /// POST https://api.mindease.me/v1/auth/login
  Future<AuthResponseModel> login({
    required String email,
    required String password,
  }) async {
    final response = await _dioClient.post<AuthResponseModel>(
      ApiEndpoints.signIn,
      body: {
        'email': email,
        'password': password,
      },
      fromJson: (json) => AuthResponseModel.fromJson(json as Map<String, dynamic>),
    );

    if (response.data != null) {
      final authData = response.data!;
      // Save tokens and user info securely via FlutterSecureStorage
      await _storageService.saveAccessToken(authData.accessToken);
      await _storageService.saveRefreshToken(authData.refreshToken);
      await _storageService.saveUserData(
        id: authData.user.id,
        name: authData.user.name,
        email: authData.user.email,
      );

      return authData;
    }

    throw Exception(response.message ?? 'Login failed');
  }

  Future<String?> getAccessToken() async {
    return await _storageService.getAccessToken();
  }

  Future<UserModel?> getStoredUser() async {
    final id = await _storageService.getUserId();
    final name = await _storageService.getUserName();
    final email = await _storageService.getUserEmail();

    if (id != null && email != null) {
      return UserModel(
        id: id,
        name: name ?? '',
        email: email,
      );
    }
    return null;
  }

  /// Logs out the current user by sending refreshToken to API and clearing secure storage.
  /// POST https://api.mindease.me/v1/auth/logout?refreshToken=<refreshToken>
  Future<void> logout() async {
    try {
      final refreshToken = await _storageService.getRefreshToken();
      if (refreshToken != null && refreshToken.isNotEmpty) {
        await _dioClient.post(
          ApiEndpoints.logout,
          queryParameters: {
            'refreshToken': refreshToken,
          },
          body: {
            'refreshToken': refreshToken,
          },
        );
      }
    } catch (_) {
      // Ignore API errors during logout so local storage is always cleared
    } finally {
      await _storageService.clearAll();
    }
  }

  /// Deletes user account using DELETE /me (requires Bearer token) and clears secure storage.
  Future<void> deleteAccount() async {
    try {
      await _dioClient.delete(
        ApiEndpoints.currentUser,
      );
    } finally {
      await _storageService.clearAll();
    }
  }

  /// Updates user profile details via PATCH /me as multipart/form-data
  Future<UserModel> updateProfile({
    required String firstName,
    required String lastName,
    required String email,
    String? mobile,
    File? photoFile,
  }) async {
    final Map<String, dynamic> formMap = {
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
    };

    if (mobile != null && mobile.isNotEmpty) {
      formMap['mobile'] = mobile;
    }

    if (photoFile != null) {
      final fileName = photoFile.path.split('/').last;
      formMap['photo'] = await MultipartFile.fromFile(
        photoFile.path,
        filename: fileName,
      );
    }

    final formData = FormData.fromMap(formMap);

    final response = await _dioClient.patch<UserModel>(
      ApiEndpoints.currentUser,
      body: formData,
      fromJson: (json) {
        if (json is Map<String, dynamic>) {
          if (json.containsKey('user') && json['user'] is Map<String, dynamic>) {
            return UserModel.fromJson(json['user'] as Map<String, dynamic>);
          }
          if (json.containsKey('data') && json['data'] is Map<String, dynamic>) {
            return UserModel.fromJson(json['data'] as Map<String, dynamic>);
          }
          return UserModel.fromJson(json);
        }
        return UserModel(
          id: '',
          name: '$firstName $lastName'.trim(),
          email: email,
        );
      },
    );

    if (response.data != null) {
      final updatedUser = response.data!;
      final fullName = updatedUser.name.isNotEmpty
          ? updatedUser.name
          : '$firstName $lastName'.trim();
      await _storageService.saveUserData(
        id: updatedUser.id,
        name: fullName,
        email: updatedUser.email.isNotEmpty ? updatedUser.email : email,
      );
      return updatedUser;
    }

    final fallbackName = '$firstName $lastName'.trim();
    await _storageService.saveUserData(
      id: '',
      name: fallbackName,
      email: email,
    );
    return UserModel(id: '', name: fallbackName, email: email);
  }

  /// Deletes user profile photo via DELETE /me/photo
  Future<UserModel> deleteProfilePhoto() async {
    final response = await _dioClient.delete<UserModel>(
      ApiEndpoints.deleteMyPhoto,
      fromJson: (json) {
        if (json is Map<String, dynamic>) {
          if (json.containsKey('user') && json['user'] is Map<String, dynamic>) {
            return UserModel.fromJson(json['user'] as Map<String, dynamic>);
          }
          if (json.containsKey('data') && json['data'] is Map<String, dynamic>) {
            return UserModel.fromJson(json['data'] as Map<String, dynamic>);
          }
          return UserModel.fromJson(json);
        }
        return const UserModel(id: '', name: '', email: '');
      },
    );

    if (response.data != null) {
      final updatedUser = response.data!;
      await _storageService.saveUserData(
        id: updatedUser.id,
        name: updatedUser.name,
        email: updatedUser.email,
      );
      return updatedUser;
    }

    return const UserModel(id: '', name: '', email: '');
  }

  /// Updates user password via PUT /me/password
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    await _dioClient.put(
      ApiEndpoints.password,
      body: {
        'currentPassword': currentPassword,
        'password': newPassword,
      },
    );
  }

  /// Sends password reset email link via POST /auth/password-reset
  Future<void> sendPasswordResetEmail(String email) async {
    await _dioClient.post(
      ApiEndpoints.passwordResetForget,
      body: {
        'email': email,
      },
    );
  }
}
