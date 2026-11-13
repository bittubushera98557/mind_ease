import 'dart:io';
import 'package:dio/dio.dart';

import '../../../../core/network/api_endpoints.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/services/secure_storage_service.dart';
import '../models/auth_response_model.dart';
import '../models/token_refresh_response_model.dart';
import '../models/user_model.dart';

/// Auth Repository using Dio, Secure Storage, and SharedPreferences
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
      // Save tokens and user info securely via FlutterSecureStorage & SharedPreferences
      await _storageService.saveAccessToken(authData.accessToken);
      await _storageService.saveRefreshToken(authData.refreshToken);
      await _storageService.saveUserData(
        id: authData.user.id,
        name: authData.user.name,
        email: authData.user.email,
        firstName: authData.user.firstName,
        lastName: authData.user.lastName,
        mobile: authData.user.mobile,
        photo: authData.user.photo,
        createdAt: authData.user.createdAt,
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
      // Save tokens and user info securely via FlutterSecureStorage & SharedPreferences
      await _storageService.saveAccessToken(authData.accessToken);
      await _storageService.saveRefreshToken(authData.refreshToken);
      await _storageService.saveUserData(
        id: authData.user.id,
        name: authData.user.name,
        email: authData.user.email,
        firstName: authData.user.firstName,
        lastName: authData.user.lastName,
        mobile: authData.user.mobile,
        photo: authData.user.photo,
        createdAt: authData.user.createdAt,
      );

      return authData;
    }

    throw Exception(response.message ?? 'Login failed');
  }

  Future<String?> getAccessToken() async {
    return await _storageService.getAccessToken();
  }

  /// Calls POST /auth/refresh with refreshToken and updates stored tokens.
  Future<bool> refreshToken() async {
    final refreshToken = await _storageService.getRefreshToken();
    if (refreshToken == null || refreshToken.isEmpty) return false;

    try {
      final response = await _dioClient.post<TokenRefreshResponseModel>(
        ApiEndpoints.tokenRefresh,
        body: {'refreshToken': refreshToken},
        fromJson: (json) => TokenRefreshResponseModel.fromJson(
          json is Map<String, dynamic> && json.containsKey('data') && json['data'] is Map<String, dynamic>
              ? json['data'] as Map<String, dynamic>
              : json,
        ),
      );

      if (response.data != null && response.data!.isSuccess) {
        await _storageService.saveAccessToken(response.data!.accessToken);
        if (response.data!.refreshToken.isNotEmpty) {
          await _storageService.saveRefreshToken(response.data!.refreshToken);
        }
        return true;
      }
    } catch (_) {}
    return false;
  }

  /// Fetches current user profile from GET /me
  Future<UserModel> fetchCurrentUser() async {
    final response = await _dioClient.get<UserModel>(
      ApiEndpoints.currentUser,
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
      final user = response.data!;
      await _storageService.saveUserData(
        id: user.id,
        name: user.name,
        email: user.email,
        firstName: user.firstName,
        lastName: user.lastName,
        mobile: user.mobile,
        photo: user.photo,
        createdAt: user.createdAt,
      );
      return user;
    }

    throw Exception(response.message ?? 'Failed to fetch user profile');
  }

  Future<UserModel?> getStoredUser() async {
    final id = await _storageService.getUserId();
    final name = await _storageService.getUserName();
    final email = await _storageService.getUserEmail();
    final createdAt = await _storageService.getUserCreatedAt();
    final firstName = await _storageService.getUserFirstName();
    final lastName = await _storageService.getUserLastName();
    final mobile = await _storageService.getUserMobile();
    final photo = await _storageService.getUserPhoto();

    if ((id != null && id.isNotEmpty) || (email != null && email.isNotEmpty)) {
      final validName = (name != null && name.isNotEmpty)
          ? name
          : ('$firstName $lastName'.trim().isNotEmpty ? '$firstName $lastName'.trim() : 'User');
      return UserModel(
        id: id ?? 'user_id',
        name: validName,
        firstName: firstName,
        lastName: lastName,
        email: email ?? '',
        mobile: mobile,
        photo: photo,
        createdAt: createdAt,
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

  /// Updates user profile details via POST /me as multipart/form-data
  Future<UserModel> updateProfile({
    required String firstName,
    required String lastName,
    String? preferredName,
    required String email,
    String? mobile,
    bool? remindersEnabled,
    bool? removePhoto,
    File? photoFile,
  }) async {
    final Map<String, dynamic> formMap = {
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
    };

    if (preferredName != null && preferredName.isNotEmpty) {
      formMap['preferredName'] = preferredName;
    }

    if (mobile != null && mobile.isNotEmpty) {
      formMap['mobile'] = mobile;
    }

    if (remindersEnabled != null) {
      formMap['remindersEnabled'] = remindersEnabled;
    }

    if (removePhoto != null) {
      formMap['removePhoto'] = removePhoto;
    }

    if (photoFile != null) {
      final fileName = photoFile.path.split('/').last;
      formMap['photo'] = await MultipartFile.fromFile(
        photoFile.path,
        filename: fileName,
      );
    }

    final formData = FormData.fromMap(formMap);

    final response = await _dioClient.post<UserModel>(
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
        firstName: updatedUser.firstName ?? firstName,
        lastName: updatedUser.lastName ?? lastName,
        mobile: updatedUser.mobile ?? mobile,
        photo: updatedUser.photo,
        createdAt: updatedUser.createdAt,
      );
      return updatedUser;
    }

    final fallbackName = '$firstName $lastName'.trim();
    await _storageService.saveUserData(
      id: '',
      name: fallbackName,
      email: email,
      firstName: firstName,
      lastName: lastName,
      mobile: mobile,
    );
    return UserModel(
      id: '',
      name: fallbackName,
      firstName: firstName,
      lastName: lastName,
      email: email,
      mobile: mobile,
    );
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
        firstName: updatedUser.firstName,
        lastName: updatedUser.lastName,
        mobile: updatedUser.mobile,
        photo: null,
        createdAt: updatedUser.createdAt,
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
