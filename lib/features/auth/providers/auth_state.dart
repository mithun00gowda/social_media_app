import 'package:social_feed_app/core/models/user.dart';

enum AuthStatus { initial, loading, authenticated,unauthenticated, error }

class AuthState {
  final AuthStatus status;
  final AppUser? user;
  final String? errorMessage;

  const AuthState({required this.status, this.user, this.errorMessage});

  const AuthState.initial() : this(status: AuthStatus.initial);
  bool get isLoading => status == AuthStatus.loading;
  bool get isAuthenticated => status == AuthStatus.authenticated;
  bool get hasError => errorMessage != null;

  AuthState copyWith({
    AuthStatus? status,
    AppUser? user,
    String? errorMessage,
    bool clearUser = false
  }) {
    return AuthState(
      status: status ?? this.status,
      user:clearUser ? null : (user ?? this.user),
      errorMessage: errorMessage,
    );
  }
}
