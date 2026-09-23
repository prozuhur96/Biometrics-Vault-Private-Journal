import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';

class PinService {
  static const int minPinLength = 4;
  static const int maxPinLength = 6;

  String generateSalt() {
    final random = Random.secure();

    final bytes = List<int>.generate(
      32,
      (_) => random.nextInt(256),
    );

    return base64UrlEncode(bytes);
  }

  String hashPin(
    String pin,
    String salt,
  ) {
    final bytes = utf8.encode('$salt:$pin');
    final digest = sha256.convert(bytes);

    return digest.toString();
  }

  bool verifyPin({
    required String pin,
    required String salt,
    required String expectedHash,
  }) {
    if (pin.isEmpty ||
        salt.isEmpty ||
        expectedHash.isEmpty) {
      return false;
    }

    final actualHash = hashPin(
      pin,
      salt,
    );

    return actualHash == expectedHash;
  }

  bool isValidPin(String pin) {
    if (pin.length < minPinLength ||
        pin.length > maxPinLength) {
      return false;
    }

    return RegExp(r'^\d+$').hasMatch(pin);
  }
}