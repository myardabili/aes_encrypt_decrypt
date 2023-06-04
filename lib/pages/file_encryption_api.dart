import 'dart:convert';
import 'dart:typed_data';

import 'package:encrypt/encrypt.dart';

String? finalEncrypt;

class FileEncryptionApi {
  static Future<Uint8List?> encryptFile(Uint8List data) async {
    // final key = Key.fromSecureRandom(16);
    final key = Key.fromUtf8('my32lengthsupersecretnooneknows1');
    // final iv = IV.fromLength(16);
    final iv = IV.fromUtf8('HgNRbGHbDSz9T0CC');
    final encrypter = Encrypter(AES(key, mode: AESMode.sic, padding: 'PKCS7'));

    final encryptedFile = encrypter.encryptBytes(data, iv: iv);
    final result = encryptedFile.base64;
    finalEncrypt = result;
    Uint8List? encrypt = result.isNotEmpty
        ? Uint8List.fromList(utf8.encode(finalEncrypt!))
        : null;

    return encrypt;
  }

  static Future<Uint8List?> decryptedFile(List<int> encryptedData) async {
    final key = Key.fromUtf8('my32lengthsupersecretnooneknows1');
    final iv = IV.fromUtf8('HgNRbGHbDSz9T0CC');
    final encrypter = Encrypter(AES(key, mode: AESMode.sic, padding: 'PKCS7'));

    final encrypted = Encrypted.fromBase64(utf8.decode(encryptedData));
    final decrypted = encrypter.decryptBytes(encrypted, iv: iv);

    return Uint8List.fromList(decrypted);
  }
}
