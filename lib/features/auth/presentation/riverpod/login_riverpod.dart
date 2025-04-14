import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repository/auth_repository.dart';
import 'login_state.dart';

final loginControllerProvider =
    StateNotifierProvider<LoginController, LoginRiverpodState>((ref) {
      return LoginController(repository: ref.watch(authRepositoryProvider));
    });

class LoginController extends StateNotifier<LoginRiverpodState> {
  final AuthRepository _repository;

  LoginController({required AuthRepository repository})
    : _repository = repository,
      super(LoginRiverpodState.initial());

  Future<void> loginWithEmail({
    required String email,
    required String password,
  }) async {
    state = state.copyWith(state: LoginState.loading);
    final result = await _repository.loginWithEmail(
      email: email,
      password: password,
    );

    result.fold(
      (failure) =>
          state = state.copyWith(
            state: LoginState.error,
            error: failure.message,
          ),
      (user) => state = state.copyWith(state: LoginState.success),
    );
  }

  void togglePasswordVisibility() {
    state = state.copyWith(isPasswordVisible: !state.isPasswordVisible);
  }

  Future<void> loginAsGuest() async {
    state = state.copyWith(state: LoginState.loading);
    final result = await _repository.loginAsGuest();

    result.fold(
      (failure) =>
          state = state.copyWith(
            state: LoginState.error,
            error: failure.message,
          ),
      (user) => state = state.copyWith(state: LoginState.loginAsGuestSuccess),
    );
  }
}
