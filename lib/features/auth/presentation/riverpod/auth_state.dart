import '../../../../core/comman/entitys/user_model.dart';

enum AuthState {
  initial,
  loading,
  success,
  error,
  successCreateEmail,
  sucessSaveEmailInSupabaseDatabase,
}

extension AuthStateX on AuthRiverpodState {
  bool isLoading() => state == AuthState.loading;

  bool isError() => state == AuthState.error;

  bool isSuccess() => state == AuthState.success;

  bool isInitial() => state == AuthState.initial;

  bool isSuccessCreateEmail() => state == AuthState.successCreateEmail;

  bool isSuccessSaveEmailInSupabaseDatabase() =>
      state == AuthState.sucessSaveEmailInSupabaseDatabase;
}

class AuthRiverpodState {
  final AuthState state;
  final String? error;
  final bool isSuccess;
  final UserModel? user;

  AuthRiverpodState({
    required this.state,
    this.error,
    this.isSuccess = false,
    this.user,
  });

  factory AuthRiverpodState.initial() {
    return AuthRiverpodState(state: AuthState.initial, user: null);
  }

  AuthRiverpodState copyWith({
    AuthState? state,
    String? error,
    bool? isSuccess,
    UserModel? user,
  }) {
    return AuthRiverpodState(
      state: state ?? this.state,
      error: error ?? this.error,
      isSuccess: isSuccess ?? this.isSuccess,
      user: user ?? this.user,
    );
  }
}
