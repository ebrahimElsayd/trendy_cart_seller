import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fpdart/fpdart.dart';

import '../entitys/user_model.dart';

class SecureStorageHelper {
  static AndroidOptions _getAndroidOptions() =>
      const AndroidOptions(encryptedSharedPreferences: true);
  static const String _userKey = 'user_data';
  static const String _firstTime = 'first_time';
  static final _storage = FlutterSecureStorage(aOptions: _getAndroidOptions());

  // Save user data
  static Future<Either<String, void>> saveUserData(UserModel user) async {
    try {
      await _storage.write(key: _userKey, value: user.toJson());
      return const Right(null);
    } catch (e) {
      return Left(e.toString());
    }
  }

  // Get user data
  static Future<Either<String, UserModel?>> getUserData() async {
    try {
      final userData = await _storage.read(key: _userKey);
      if (userData != null) {
        return Right(UserModel.fromJson(userData));
      }
      return const Right(null);
    } catch (e) {
      return Left(e.toString());
    }
  }

  // Remove user data
  static Future<Either<String, void>> removeUserData() async {
    try {
      await _storage.delete(key: _userKey);
      return const Right(null);
    } catch (e) {
      return Left(e.toString());
    }
  }

  // Check if user is logged in
  static Future<Either<String, UserModel>> isUserLoggedIn() async {
    try {
      final userData = await _storage.read(key: _userKey);
      if (userData != null) {
        return Right(UserModel.fromJson(userData));
      }
      return const Left('User is not logged in');
    } catch (e) {
      return Left(e.toString());
    }
  }

  static Future<Either<String, String>> isFirstInstallation() async {
    try {
      final flag = await _storage.read(key: _firstTime);
      if (flag != null) {
        print('flag: $flag');
        return Right(flag);
      }
      return const Left('User is not Install the app');
    } catch (e) {
      return Left(e.toString());
    }
  }

  static Future<Either<String, void>> saveInstalltionFlag() async {
    try {
      await _storage.write(key: _firstTime, value: 'installed');
      return const Right(null);
    } catch (e) {
      return Left(e.toString());
    }
  }
}
