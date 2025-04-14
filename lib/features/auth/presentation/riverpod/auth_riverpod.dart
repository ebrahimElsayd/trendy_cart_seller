import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/comman/entitys/user_model.dart';
import '../../data/repository/auth_repository.dart';
import 'auth_state.dart';

final authControllerProvider =
    StateNotifierProvider<AuthController, AuthRiverpodState>((ref) {
      return AuthController(repository: ref.watch(authRepositoryProvider));
    });

class AuthController extends StateNotifier<AuthRiverpodState> {
  final AuthRepository _repository;

  AuthController({required AuthRepository repository})
    : _repository = repository,
      super(AuthRiverpodState.initial());

  Future<void> getCurrentUser(String email) async {
    state = state.copyWith(state: AuthState.loading);
    final result = await _repository.getCurrentUser(email);
    result.fold(
      (failure) =>
          state = state.copyWith(
            state: AuthState.error,
            error: failure.message,
          ),
      (user) =>
          state = state.copyWith(
            state: AuthState.success,
            isSuccess: user != null,
          ),
    );
  }

  Future<void> createUserProfile({required UserModel user}) async {
    final result = await _repository.createUserProfile(user: user);
    result.fold(
      (failure) =>
          state = state.copyWith(
            state: AuthState.error,
            error: failure.message,
          ),
      (user) =>
          state = state.copyWith(
            state: AuthState.sucessSaveEmailInSupabaseDatabase,
            isSuccess: true,
          ),
    );
  }

  Future<void> signUpWithEmail({
    required String email,
    required String name,
    required String password,
  }) async {
    state = state.copyWith(state: AuthState.loading);
    final result = await _repository.signUpWithEmail(
      email: email,
      name: name,
      password: password,
    );
    result.fold(
      (failure) =>
          state = state.copyWith(
            state: AuthState.error,
            error: failure.message,
          ),
      (userModel) =>
          state = state.copyWith(
            state: AuthState.successCreateEmail,
            user: userModel,
            isSuccess: true,
          ),
    );
  }

  Future<void> forgetPassword({required String email}) async {
    state = state.copyWith(state: AuthState.loading);
    final result = await _repository.forgetPassword(email: email);
    result.fold(
      (failure) =>
          state = state.copyWith(
            state: AuthState.error,
            error: failure.message,
          ),
      (success) =>
          state = state.copyWith(state: AuthState.success, isSuccess: true),
    );
  }
}
