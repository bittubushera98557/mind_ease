import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/api_exception.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/services/secure_storage_service.dart';
import '../../data/repositories/auth_repository.dart';
import 'auth_state.dart';

// Service & Repository Providers
final secureStorageProvider = Provider<SecureStorageService>((ref) {
  return SecureStorageService();
});

final dioClientProvider = Provider<DioClient>((ref) {
  final storageService = ref.watch(secureStorageProvider);
  return DioClient(storageService: storageService);
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final dioClient = ref.watch(dioClientProvider);
  final storageService = ref.watch(secureStorageProvider);
  return AuthRepository(dioClient: dioClient, storageService: storageService);
});

// Auth State Notifier Provider
final authNotifierProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return AuthNotifier(repository: repository);
});

// Auth State Provider
final authStateProvider = Provider<AuthState>((ref) {
  return ref.watch(authNotifierProvider);
});

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepository _repository;

  AuthNotifier({required AuthRepository repository})
      : _repository = repository,
        super(AuthState.initial());

  /// Checks if token exists and loads user profile
  Future<void> checkAuthStatus() async {
    state = AuthState.loading();
    try {
      final token = await _repository.getAccessToken();
      if (token != null && token.isNotEmpty) {
        final user = await _repository.getStoredUser();
        if (user != null) {
          state = AuthState.authenticated(user);
          return;
        }
      }
      state = AuthState.unauthenticated();
    } catch (_) {
      state = AuthState.unauthenticated();
    }
  }

  /// Registers user with dynamic registration API
  Future<bool> register({
    required String name,
    required String email,
    required String password,
  }) async {
    state = AuthState.loading();

    try {
      final authResponse = await _repository.register(
        name: name,
        email: email,
        password: password,
      );

      state = AuthState.authenticated(authResponse.user);
      return true;
    } on ApiException catch (e) {
      state = AuthState.error(
        message: e.message,
        field: e.field,
        code: e.code,
      );
      return false;
    } catch (e) {
      state = AuthState.error(
        message: 'An unexpected error occurred. Please try again.',
      );
      return false;
    }
  }

  /// Logs in user with email and password API
  Future<bool> login({
    required String email,
    required String password,
  }) async {
    state = AuthState.loading();

    try {
      final authResponse = await _repository.login(
        email: email,
        password: password,
      );

      state = AuthState.authenticated(authResponse.user);
      return true;
    } on ApiException catch (e) {
      state = AuthState.error(
        message: e.message,
        field: e.field,
        code: e.code,
      );
      return false;
    } catch (e) {
      state = AuthState.error(
        message: 'An unexpected error occurred. Please try again.',
      );
      return false;
    }
  }

  /// Log out user
  Future<void> logout() async {
    await _repository.logout();
    state = AuthState.unauthenticated();
  }

  /// Reset error state
  void clearError() {
    if (state.status == AuthStatus.error) {
      state = AuthState.unauthenticated();
    }
  }
}
