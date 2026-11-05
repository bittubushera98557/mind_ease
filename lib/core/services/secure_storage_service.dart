import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../config/app_constants.dart';

/// Secure Storage service for managing sensitive tokens and user info
class SecureStorageService {
  final FlutterSecureStorage _storage;

  SecureStorageService({FlutterSecureStorage? storage})
      : _storage = storage ?? const FlutterSecureStorage();

  // Access Token
  Future<void> saveAccessToken(String token) async {
    await _storage.write(key: AppConstants.keyAuthToken, value: token);
  }

  Future<String?> getAccessToken() async {
    return await _storage.read(key: AppConstants.keyAuthToken);
  }

  // Refresh Token
  Future<void> saveRefreshToken(String token) async {
    await _storage.write(key: AppConstants.keyRefreshToken, value: token);
  }

  Future<String?> getRefreshToken() async {
    return await _storage.read(key: AppConstants.keyRefreshToken);
  }

  // User Info
  Future<void> saveUserData({
    required String id,
    required String name,
    required String email,
    String? createdAt,
  }) async {
    await _storage.write(key: 'user_id', value: id);
    await _storage.write(key: 'user_name', value: name);
    await _storage.write(key: AppConstants.keyUserEmail, value: email);
    if (createdAt != null && createdAt.isNotEmpty) {
      await _storage.write(key: 'user_created_at', value: createdAt);
    }
  }

  Future<String?> getUserName() async {
    return await _storage.read(key: 'user_name');
  }

  Future<String?> getUserEmail() async {
    return await _storage.read(key: AppConstants.keyUserEmail);
  }

  Future<String?> getUserId() async {
    return await _storage.read(key: 'user_id');
  }

  Future<String?> getUserCreatedAt() async {
    return await _storage.read(key: 'user_created_at');
  }

  // Clear all storage
  Future<void> clearAll() async {
    await _storage.deleteAll();
  }
}
