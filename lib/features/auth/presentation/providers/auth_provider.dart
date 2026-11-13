import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/api_exception.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/services/secure_storage_service.dart';
import '../../data/models/user_model.dart';
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
        try {
          final freshUser = await _repository.fetchCurrentUser();
          state = AuthState.authenticated(freshUser);
          return;
        } catch (_) {
          final user = await _repository.getStoredUser();
          if (user != null) {
            state = AuthState.authenticated(user);
            return;
          }
        }
      }
      state = AuthState.unauthenticated();
    } catch (_) {
      state = AuthState.unauthenticated();
    }
  }

  /// Explicitly fetches current user profile from GET /me and updates state
  Future<void> fetchCurrentUser() async {
    try {
      final user = await _repository.fetchCurrentUser();
      state = AuthState.authenticated(user);
    } catch (_) {}
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
      state = AuthState.signUpError(
        message: e.message,
        field: e.field,
        code: e.code,
      );
      return false;
    } catch (e) {
      state = AuthState.signUpError(
        message: e is Exception
            ? e.toString().replaceAll('Exception: ', '')
            : 'An unexpected error occurred. Please try again.',
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
      state = AuthState.loginError(
        message: e.message,
        field: e.field,
        code: e.code,
      );
      return false;
    } catch (e) {
      state = AuthState.loginError(
        message: e is Exception
            ? e.toString().replaceAll('Exception: ', '')
            : 'An unexpected error occurred. Please try again.',
      );
      return false;
    }
  }

  /// Log out user
  Future<void> logout() async {
    state = AuthState.loading();
    try {
      await _repository.logout();
    } finally {
      state = AuthState.unauthenticated();
    }
  }

  /// Delete current user account
  Future<bool> deleteAccount() async {
    state = AuthState.loading();
    try {
      await _repository.deleteAccount();
      state = AuthState.unauthenticated();
      return true;
    } on ApiException catch (e) {
      state = AuthState.loginError(
        message: e.message,
        code: e.code,
      );
      return false;
    } catch (e) {
      state = AuthState.loginError(
        message: e is Exception
            ? e.toString().replaceAll('Exception: ', '')
            : 'Failed to delete account. Please try again.',
      );
      return false;
    }
  }

  /// Reset error state
  void clearError() {
    if (state.status == AuthStatus.error) {
      state = AuthState.unauthenticated();
    }
  }

  /// Updates profile details via POST /me as multipart/form-data.
  /// Returns null on success, or the error message string on failure.
  Future<String?> updateProfile({
    required String firstName,
    required String lastName,
    String? preferredName,
    required String email,
    String? mobile,
    bool? remindersEnabled,
    bool? removePhoto,
    File? photoFile,
  }) async {
    try {
      final updatedUser = await _repository.updateProfile(
        firstName: firstName,
        lastName: lastName,
        preferredName: preferredName,
        email: email,
        mobile: mobile,
        remindersEnabled: remindersEnabled,
        removePhoto: removePhoto,
        photoFile: photoFile,
      );

      final current = state.user;
      final newFirstName = updatedUser.firstName ?? firstName;
      final newLastName = updatedUser.lastName ?? lastName;
      final newName = updatedUser.name.isNotEmpty
          ? updatedUser.name
          : '$newFirstName $newLastName'.trim();
      final newEmail = updatedUser.email.isNotEmpty
          ? updatedUser.email
          : email;
      final newPhoto = removePhoto == true ? null : (updatedUser.photo ?? current?.photo);

      state = AuthState.authenticated(
        UserModel(
          id: (updatedUser.id.isNotEmpty) ? updatedUser.id : (current?.id ?? ''),
          name: newName,
          firstName: newFirstName,
          lastName: newLastName,
          email: newEmail,
          mobile: updatedUser.mobile ?? mobile,
          photo: newPhoto,
          createdAt: (updatedUser.createdAt?.isNotEmpty == true)
              ? updatedUser.createdAt
              : current?.createdAt,
        ),
      );
      return null; // null indicates success
    } on ApiException catch (e) {
      return e.message;
    } catch (e) {
      return e is Exception
          ? e.toString().replaceAll('Exception: ', '')
          : 'Failed to update profile. Please try again.';
    }
  }

  /// Deletes user profile photo via DELETE /me/photo
  Future<bool> deleteProfilePhoto() async {
    try {
      final updatedUser = await _repository.deleteProfilePhoto();
      final current = state.user;

      if (current != null) {
        state = AuthState.authenticated(
          UserModel(
            id: current.id,
            name: updatedUser.name.isNotEmpty ? updatedUser.name : current.name,
            firstName: current.firstName,
            lastName: current.lastName,
            email: current.email,
            mobile: current.mobile,
            photo: null,
            createdAt: current.createdAt,
          ),
        );
      }
      return true;
    } catch (_) {
      return false;
    }
  }

  /// Changes user password via PUT /me/password
  Future<bool> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      await _repository.changePassword(
        currentPassword: currentPassword,
        newPassword: newPassword,
      );
      return true;
    } on ApiException catch (e) {
      state = AuthState.loginError(
        message: e.message,
        code: e.code,
      );
      return false;
    } catch (e) {
      return false;
    }
  }

  /// Sends password reset email link via POST /auth/password-reset
  Future<bool> sendPasswordResetEmail(String email) async {
    try {
      await _repository.sendPasswordResetEmail(email);
      return true;
    } on ApiException catch (e) {
      state = AuthState.loginError(
        message: e.message,
        code: e.code,
      );
      return false;
    } catch (e) {
      state = AuthState.loginError(
        message: e is Exception
            ? e.toString().replaceAll('Exception: ', '')
            : 'Failed to send reset link. Please try again.',
      );
      return false;
    }
  }
}
