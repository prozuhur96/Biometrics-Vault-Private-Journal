import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';

class BiometricService {
  final LocalAuthentication _auth = LocalAuthentication();

  // 1. Check if hardware supports biometrics and if biometrics are enrolled
  Future<bool> canCheckBiometrics() async {
    try {
      final bool canAuthenticateWithBiometrics = await _auth.canCheckBiometrics;
      final bool isDeviceSupported = await _auth.isDeviceSupported();
      return canAuthenticateWithBiometrics && isDeviceSupported;
    } on PlatformException catch (_) {
      return false;
    }
  }

  // 2. Trigger the biometric hardware prompt (Fingerprint / Face ID)
  Future<bool> authenticate() async {
    try {
      return await _auth.authenticate(
        localizedReason: 'Scan your biometric to access your private vault',
        options: const AuthenticationOptions(
          stickyAuth: true, // Keeps auth prompt active if app goes to background briefly
          biometricOnly: true, // Forces biometrics instead of passcode fallback
        ),
      );
    } on PlatformException catch (e) {
      // Handle hardware unavailable, user canceled, or permissions denied
      return false;
    }
  }
}