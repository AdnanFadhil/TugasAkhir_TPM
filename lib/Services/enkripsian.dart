import 'package:encrypt/encrypt.dart';
import 'dart:convert';

class EncryptionUtils {
  static final key = Key.fromSecureRandom(32); // Ganti dengan kunci enkripsi yang sesuai
  static final iv = IV.fromLength(16); // IV harus memiliki panjang yang sesuai dengan algoritma enkripsi yang digunakan

  static final encrypter = Encrypter(AES(key, mode: AESMode.cbc));

  static String encryptString(String plaintext) {
    final encrypted = encrypter.encrypt(plaintext, iv: iv);
    return base64.encode(encrypted.bytes);
  }

  static String decryptString(String encryptedText) {
    final encryptedBytes = base64.decode(encryptedText);
    final encrypted = Encrypted(encryptedBytes);
    final decrypted = encrypter.decrypt(encrypted, iv: iv);
    return decrypted;
  }
}