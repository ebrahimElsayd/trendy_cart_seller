import 'package:flutter/services.dart';
import 'package:fpdart/fpdart.dart';
import 'package:local_auth/local_auth.dart';

class BiometricHelper {
  static final LocalAuthentication _auth = LocalAuthentication();

  static Future<Either<String, bool>> authenticate() async {
    try {
      final bool canAuthenticateWithBiometrics = await _auth.canCheckBiometrics;
      final bool canAuthenticate =
          canAuthenticateWithBiometrics || await _auth.isDeviceSupported();

      if (!canAuthenticate) {
        return const Left('Biometric authentication not available');
      }

      final bool didAuthenticate = await _auth.authenticate(
        localizedReason: 'Please authenticate to cancel your order',
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: false,
        ),
      );

      return Right(didAuthenticate);
    } on PlatformException catch (e) {
      return Left(e.message ?? 'Authentication error');
    } catch (e) {
      return Left(e.toString());
    }
  }
}
