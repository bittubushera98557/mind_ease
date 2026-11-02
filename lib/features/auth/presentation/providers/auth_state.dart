import '../../data/models/user_model.dart';

enum AuthStatus {
  initial,
  loading,
  authenticated,
  unauthenticated,
  error,
}

/// Immutable Authentication State
class AuthState {
  final AuthStatus status;
  final UserModel? user;
  final String? loginErrorMessage;
  final String? signUpErrorMessage;
  final String? errorField;
  final String? errorCode;

  const AuthState({
    required this.status,
    this.user,
    this.loginErrorMessage,
    this.signUpErrorMessage,
    this.errorField,
    this.errorCode,
  });

  factory AuthState.initial() {
    return const AuthState(status: AuthStatus.initial);
  }

  factory AuthState.loading() {
    return const AuthState(status: AuthStatus.loading);
  }

  factory AuthState.authenticated(UserModel user) {
    return AuthState(status: AuthStatus.authenticated, user: user);
  }

  factory AuthState.unauthenticated() {
    return const AuthState(status: AuthStatus.unauthenticated);
  }

  factory AuthState.loginError({
    required String message,
    String? field,
    String? code,
  }) {
    return AuthState(
      status: AuthStatus.error,
      loginErrorMessage: message,
      signUpErrorMessage: null,
      errorField: field,
      errorCode: code,
    );
  }

  factory AuthState.signUpError({
    required String message,
    String? field,
    String? code,
  }) {
    return AuthState(
      status: AuthStatus.error,
      loginErrorMessage: null,
      signUpErrorMessage: message,
      errorField: field,
      errorCode: code,
    );
  }

  AuthState copyWith({
    AuthStatus? status,
    UserModel? user,
    String? loginErrorMessage,
    String? signUpErrorMessage,
    String? errorField,
    String? errorCode,
  }) {
    return AuthState(
      status: status ?? this.status,
      user: user ?? this.user,
      loginErrorMessage: loginErrorMessage ?? this.loginErrorMessage,
      signUpErrorMessage: signUpErrorMessage ?? this.signUpErrorMessage,
      errorField: errorField ?? this.errorField,
      errorCode: errorCode ?? this.errorCode,
    );
  }
}
