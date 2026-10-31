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

  Future<void> logout() async {
    await _storageService.clearAll();
  }
}
