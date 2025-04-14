import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/comman/entitys/user_model.dart';
import '../../data/repository/auth_repository.dart';
import 'signup_state.dart';

final signupControllerProvider =
    StateNotifierProvider<SignupController, SignupRiverpodState>((ref) {
      return SignupController(repository: ref.watch(authRepositoryProvider));
    });

class SignupController extends StateNotifier<SignupRiverpodState> {
  final AuthRepository _repository;

  SignupController({required AuthRepository repository})
    : _repository = repository,
      super(SignupRiverpodState.initial());

  void togglePasswordVisibility() {
    state = state.copyWith(isPasswordVisible: !state.isPasswordVisible);
  }

  void toggleConfirmPasswordVisibility() {
    state = state.copyWith(
      isConfirmPasswordVisible: !state.isConfirmPasswordVisible,
    );
  }

  Future<void> signUpWithEmail({
    required String email,
    required String name,
    required String password,
  }) async {
    state = state.copyWith(state: SignupState.loading);
    final result = await _repository.signUpWithEmail(
      email: email,
      name: name,
      password: password,
    );

    result.fold(
      (failure) =>
          state = state.copyWith(
            state: SignupState.error,
            error: failure.message,
          ),
      (userModel) =>
          state = state.copyWith(
            state: SignupState.successCreateEmail,
            user: userModel,
          ),
    );
  }

  Future<void> createUserProfile({required UserModel user}) async {
    final result = await _repository.createUserProfile(user: user);
    result.fold(
      (failure) {
        print(failure.message);

        state = state.copyWith(
          state: SignupState.error,
          error:
              failure.message.contains(
                    'duplicate key value violates unique constraint',
                  )
                  ? "Email Already Exists"
                  : failure.message,
        );
      },
      (_) =>
          state = state.copyWith(
            state: SignupState.sucessSaveEmailInSupabaseDatabase,
          ),
    );
  }
}
