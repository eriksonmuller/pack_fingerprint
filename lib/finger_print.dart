
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:local_auth/error_codes.dart' as auth_error;


class FingerPrint {
  final _localAuth = LocalAuthentication();

  check() async {
    if (await authenticateIsAvailable()) {
      try {
        if (await authenticateIsAvailable()) {
          final bool canAuthenticateWithBiometrics =
              await _localAuth.canCheckBiometrics;

          final bool canAuthenticate = canAuthenticateWithBiometrics ||
              await _localAuth.isDeviceSupported();

          if (!canAuthenticate) {
            return false;
          } else {
            try {
              final bool didAuthenticate = await _localAuth.authenticate(
                  localizedReason: 'Acesso por biometria');

              if (didAuthenticate) {
                return true;
              } else {
                return false;
              }
            } on PlatformException {
              return false;
            }
          }
        } else {
          return false;
        }
      } catch (e) {
        return false;
      }
    }
  }

  Future<bool> authenticateIsAvailable() async {
    final isAvailable = await _localAuth.canCheckBiometrics;
    final isDeviceSupported = await _localAuth.isDeviceSupported();
    return isAvailable && isDeviceSupported;
  }

  Future<bool> authenticate()async {
       try {
      //final bool didAuthenticate = 
      await _localAuth.authenticate(
          localizedReason: 'Faça a autenticação',
          options: const AuthenticationOptions(useErrorDialogs: false));
      return true;
    } on PlatformException catch (e) {
      if (e.code == auth_error.notAvailable) {
        return false;
      } else if (e.code == auth_error.notEnrolled) {
        return false;
      } else {
        return false;
      }
    }
  }

 

 
}

