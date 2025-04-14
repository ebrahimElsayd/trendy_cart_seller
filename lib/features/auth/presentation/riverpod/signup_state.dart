import '../../../../core/comman/entitys/user_model.dart';

enum SignupState {
  initial,
  loading,
  success,
  emailAlreadyExists,
  error,
  successCreateEmail,
  sucessSaveEmailInSupabaseDatabase,
}

class SignupRiverpodState {
  final SignupState state;
  final String? error;
  final UserModel? user;
  final bool isPasswordVisible;
  final bool isConfirmPasswordVisible;

  SignupRiverpodState({
    required this.state,
    this.error,
    this.user,
    this.isPasswordVisible = false,
    this.isConfirmPasswordVisible = false,
  });

  factory SignupRiverpodState.initial() {
    return SignupRiverpodState(state: SignupState.initial);
  }

  bool isLoading() => state == SignupState.loading;

  bool isSuccess() => state == SignupState.success;

  bool isError() => state == SignupState.error;

  bool isSuccessCreateEmail() => state == SignupState.successCreateEmail;

  bool isSuccessSaveEmailInSupabaseDatabase() =>
      state == SignupState.sucessSaveEmailInSupabaseDatabase;

  bool isEmailAlreadyExists() => state == SignupState.emailAlreadyExists;

  SignupRiverpodState copyWith({
    SignupState? state,
    String? error,
    UserModel? user,
    bool? isPasswordVisible,
    bool? isConfirmPasswordVisible,
  }) {
    return SignupRiverpodState(
      state: state ?? this.state,
      error: error ?? this.error,
      user: user ?? this.user,
      isPasswordVisible: isPasswordVisible ?? this.isPasswordVisible,
      isConfirmPasswordVisible:
          isConfirmPasswordVisible ?? this.isConfirmPasswordVisible,
    );
  }
}
