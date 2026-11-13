import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../config/app_constants.dart';

/// Secure Storage & SharedPreferences service for managing sensitive tokens and user info
class SecureStorageService {
  final FlutterSecureStorage _storage;

  SecureStorageService({FlutterSecureStorage? storage})
      : _storage = storage ?? const FlutterSecureStorage();

  // Access Token
  Future<void> saveAccessToken(String token) async {
    await _storage.write(key: AppConstants.keyAuthToken, value: token);
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(AppConstants.keyAuthToken, token);
    } catch (_) {}
  }

  Future<String?> getAccessToken() async {
    final token = await _storage.read(key: AppConstants.keyAuthToken);
    if (token != null && token.isNotEmpty) return token;
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(AppConstants.keyAuthToken);
    } catch (_) {
      return null;
    }
  }

  // Refresh Token
  Future<void> saveRefreshToken(String token) async {
    await _storage.write(key: AppConstants.keyRefreshToken, value: token);
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(AppConstants.keyRefreshToken, token);
    } catch (_) {}
  }

  Future<String?> getRefreshToken() async {
    final token = await _storage.read(key: AppConstants.keyRefreshToken);
    if (token != null && token.isNotEmpty) return token;
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(AppConstants.keyRefreshToken);
    } catch (_) {
      return null;
    }
  }

  // User Info
  Future<void> saveUserData({
    required String id,
    required String name,
    required String email,
    String? firstName,
    String? lastName,
    String? mobile,
    String? photo,
    String? createdAt,
  }) async {
    await _storage.write(key: 'user_id', value: id);
    await _storage.write(key: 'user_name', value: name);
    await _storage.write(key: AppConstants.keyUserEmail, value: email);
    if (firstName != null) await _storage.write(key: 'user_first_name', value: firstName);
    if (lastName != null) await _storage.write(key: 'user_last_name', value: lastName);
    if (mobile != null) await _storage.write(key: 'user_mobile', value: mobile);
    if (photo != null && photo.isNotEmpty) {
      await _storage.write(key: 'user_photo', value: photo);
    } else {
      await _storage.delete(key: 'user_photo');
    }
    if (createdAt != null && createdAt.isNotEmpty) {
      await _storage.write(key: 'user_created_at', value: createdAt);
    }

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_id', id);
      await prefs.setString('user_name', name);
      await prefs.setString(AppConstants.keyUserEmail, email);
      if (firstName != null) await prefs.setString('user_first_name', firstName);
      if (lastName != null) await prefs.setString('user_last_name', lastName);
      if (mobile != null) await prefs.setString('user_mobile', mobile);
      if (photo != null && photo.isNotEmpty) {
        await prefs.setString('user_photo', photo);
      } else {
        await prefs.remove('user_photo');
      }
      if (createdAt != null && createdAt.isNotEmpty) {
        await prefs.setString('user_created_at', createdAt);
      }
    } catch (_) {}
  }

  Future<String?> getUserName() async {
    final val = await _storage.read(key: 'user_name');
    if (val != null && val.isNotEmpty) return val;
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString('user_name');
    } catch (_) {
      return null;
    }
  }

  Future<String?> getUserEmail() async {
    final val = await _storage.read(key: AppConstants.keyUserEmail);
    if (val != null && val.isNotEmpty) return val;
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(AppConstants.keyUserEmail);
    } catch (_) {
      return null;
    }
  }

  Future<String?> getUserId() async {
    final val = await _storage.read(key: 'user_id');
    if (val != null && val.isNotEmpty) return val;
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString('user_id');
    } catch (_) {
      return null;
    }
  }

  Future<String?> getUserCreatedAt() async {
    final val = await _storage.read(key: 'user_created_at');
    if (val != null && val.isNotEmpty) return val;
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString('user_created_at');
    } catch (_) {
      return null;
    }
  }

  Future<String?> getUserFirstName() async {
    final val = await _storage.read(key: 'user_first_name');
    if (val != null && val.isNotEmpty) return val;
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString('user_first_name');
    } catch (_) {
      return null;
    }
  }

  Future<String?> getUserLastName() async {
    final val = await _storage.read(key: 'user_last_name');
    if (val != null && val.isNotEmpty) return val;
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString('user_last_name');
    } catch (_) {
      return null;
    }
  }

  Future<String?> getUserMobile() async {
    final val = await _storage.read(key: 'user_mobile');
    if (val != null && val.isNotEmpty) return val;
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString('user_mobile');
    } catch (_) {
      return null;
    }
  }

  Future<String?> getUserPhoto() async {
    final val = await _storage.read(key: 'user_photo');
    if (val != null && val.isNotEmpty) return val;
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString('user_photo');
    } catch (_) {
      return null;
    }
  }

  // Clear all storage
  Future<void> clearAll() async {
    await _storage.deleteAll();
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(AppConstants.keyAuthToken);
      await prefs.remove(AppConstants.keyRefreshToken);
      await prefs.remove('user_id');
      await prefs.remove('user_name');
      await prefs.remove(AppConstants.keyUserEmail);
      await prefs.remove('user_first_name');
      await prefs.remove('user_last_name');
      await prefs.remove('user_mobile');
      await prefs.remove('user_photo');
      await prefs.remove('user_created_at');
    } catch (_) {}
  }
}
