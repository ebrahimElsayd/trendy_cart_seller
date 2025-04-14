import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repository/user_repository.dart';
import 'user_state.dart';

final userProvider =
    StateNotifierProvider.autoDispose<UserRiverpod, UserRiverpodState>(
      (ref) => UserRiverpod(repository: ref.read(userRepositoryProvider)),
    );

class UserRiverpod extends StateNotifier<UserRiverpodState> {
  final UserRepository repository;

  UserRiverpod({required this.repository})
    : super(UserRiverpodState(state: userState.initial));

  Future<void> updateUser(
    String userId,
    String newName,
    String newPhone,
  ) async {
    state = state.copyWith(state: userState.loading);
    final result = await repository.updateUser(userId, newName, newPhone);
    result.fold(
      (failure) =>
          state = state.copyWith(
            state: userState.error,
            errorMessage: failure.message,
          ),
      (success) {
        final newname = newName;
        final newphone = newPhone;
        state = state.copyWith(
          state: userState.success,
          username: newname,
          userphone: newphone,
        );
      },
    );
  }

  Future<void> getUserInfo(String userId) async {
    state = state.copyWith(state: userState.loading);
    final result = await repository.getUserInfo(userId);
    result.fold(
      (failure) =>
          state = state.copyWith(
            state: userState.error,
            errorMessage: failure.message,
          ),
      (success) {
        final newname = success.name;
        final newphone = success.phone;
        state = state.copyWith(
          state: userState.success,
          username: newname,
          userphone: newphone,
        );
      },
    );
  }
}
