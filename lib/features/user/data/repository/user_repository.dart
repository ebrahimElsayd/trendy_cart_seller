import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';

import '../../../../core/erorr/failure.dart';
import '../../../../core/utils/try_and_catch.dart';
import '../data_source/user_datasource.dart';
import '../model/user_model_test.dart';

// final UpdateUserInfoDataSourceProvider =
//     Provider.autoDispose<UpdateUserInfoDataSource>((ref) =>
//         UpdateUserInfoDataSourceImpl(
//             supabaseClient: ref.read(supabaseClientProvider)));
final userRepositoryProvider = Provider.autoDispose<UserRepository>((ref) {
  return UserRepository(
    updateUserInfoDataSource: ref.read(UserDataSourceProvider),
  );
});

class UserRepository {
  final UserDataSource updateUserInfoDataSource;

  UserRepository({required this.updateUserInfoDataSource});

  Future<Either<Failure, void>> updateUser(
    String userId,
    String newName,
    String newPhone,
  ) async {
    return executeTryAndCatchForRepository(() async {
      await updateUserInfoDataSource.updateUser(userId, newName, newPhone);
    });
  }

  Future<Either<Failure, userModelTest>> getUserInfo(String userId) async {
    return executeTryAndCatchForRepository(() async {
      final user = await updateUserInfoDataSource.getUserInfo(userId);
      return userModelTest.fromMap(user);
    });
  }
}
