import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';

import '../../../../core/comman/entitys/user_model.dart';
import '../../../../core/erorr/failure.dart';
import '../../../../core/utils/try_and_catch.dart';
import '../data_sourse/auth_remote_data_source.dart';

final authRepositoryProvider = Provider.autoDispose<AuthRepository>((ref) {
  return AuthRepository(
    remoteDataSource: ref.watch(authRemoteDataSourceProvider),
  );
});

class AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepository({required this.remoteDataSource});

  Future<Either<Failure, UserModel>> signUpWithEmail({
    required String email,
    required String name,
    required String password,
  }) async {
    return executeTryAndCatchForRepository(() async {
      final userData = await remoteDataSource.signUpWithEmail(
        email: email,
        name: name,
        password: password,
      );
      return UserModel.fromMap(userData);
    });
  }

  Future<Either<Failure, void>> createUserProfile({
    required UserModel user,
  }) async {
    return executeTryAndCatchForRepository(() async {
      await remoteDataSource.createUserProfile(user: user);
    });
  }

  Future<Either<Failure, UserModel?>> getCurrentUser(String email) async {
    return executeTryAndCatchForRepository(() async {
      final userData = await remoteDataSource.getCurrentUserData(email);
      if (userData == null) return null;
      return UserModel.fromMap(userData);
    });
  }

  Future<Either<Failure, void>> loginWithEmail({
    required String email,
    required String password,
  }) async {
    return executeTryAndCatchForRepository(() async {
      await remoteDataSource.loginWithEmail(email: email, password: password);
    });
  }

  Future<Either<Failure, void>> signOut() async {
    return executeTryAndCatchForRepository(() async {
      await remoteDataSource.signOut();
    });
  }

  Future<Either<Failure, void>> loginAsGuest() async {
    return executeTryAndCatchForRepository(() async {
      await remoteDataSource.loginAsGuest();
    });
  }

  Future<Either<Failure, void>> updateUserPhoneNumber({
    required int phoneNumber,
    int? userId,
  }) async {
    return executeTryAndCatchForRepository(() async {
      await remoteDataSource.updateUserPhoneNumber(
        phoneNumber: phoneNumber,
        userId: userId,
      );
    });
  }

  Future<Either<Failure, void>> forgetPassword({required String email}) async {
    return executeTryAndCatchForRepository(() async {
      await remoteDataSource.forgetPassword(email: email);
    });
  }
}
