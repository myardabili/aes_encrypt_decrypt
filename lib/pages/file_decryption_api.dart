import 'dart:typed_data';

import 'package:encrypt/encrypt.dart';

class FileDecryptionApi {
  static Future<Uint8List?> encryptFile(data) async {
    final key = Key.fromSecureRandom(16);
    final iv = IV.fromLength(16);
    final encrypter = Encrypter(AES(key, mode: AESMode.cbc));

    final encryptedFile = encrypter.encryptBytes(data, iv: iv);
    return encryptedFile.bytes;
  }
}
