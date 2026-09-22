import 'package:encrypt/encrypt.dart' as encrypt;

class EncryptionService {
  // 32-character key for AES-256 encryption
  static final _key = encrypt.Key.fromUtf8('my32lengthsupersecretnooneknows1');
  static final _iv = encrypt.IV.fromLength(16);
  static final _encrypter = encrypt.Encrypter(encrypt.AES(_key));

  /// Encrypts plaintext into AES-256 Base64 string
  static String encryptText(String text) {
    if (text.isEmpty) return text;
    final encrypted = _encrypter.encrypt(text, iv: _iv);
    return encrypted.base64;
  }

  /// Decrypts AES-256 Base64 string back to plaintext
  static String decryptText(String encryptedText) {
    if (encryptedText.isEmpty) return encryptedText;
    try {
      final encrypted = encrypt.Encrypted.fromBase64(encryptedText);
      return _encrypter.decrypt(encrypted, iv: _iv);
    } catch (_) {
      // Fallback for unencrypted legacy entries created prior to Phase 3
      return encryptedText;
    }
  }
}