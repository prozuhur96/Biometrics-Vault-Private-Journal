import 'dart:async';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';

class BiometricService {
  final LocalAuthentication _auth = LocalAuthentication();

  Future<bool> canCheckBiometrics() async {
    try {
      final bool canAuthenticateWithBiometrics = await _auth.canCheckBiometrics;
      final bool isDeviceSupported = await _auth.isDeviceSupported();
      return canAuthenticateWithBiometrics && isDeviceSupported;
    } on PlatformException {
      return false;
    }
  }

  Future<bool> authenticate() async {
    try {
      // Add a 2-second timeout so web/desktop browsers don't hang indefinitely
      return await _auth
          .authenticate(
            localizedReason: 'Scan your biometric to access your private vault',
          )
          .timeout(
            const Duration(seconds: 2),
            onTimeout: () => false,
          );
    } on PlatformException {
      return false;
    } catch (_) {
      return false;
    }
  }
}