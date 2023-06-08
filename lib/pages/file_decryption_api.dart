import 'dart:convert';
import 'dart:typed_data';

import 'package:encrypt/encrypt.dart';

class FileDecryptionApi {
  static Future<Uint8List?> decryptedFile(List<int> encryptedData) async {
    final key = Key.fromUtf8('my32lengthsupersecretnooneknows1');
    final iv = IV.fromUtf8('HgNRbGHbDSz9T0CC');
    final encrypter = Encrypter(AES(key, mode: AESMode.sic, padding: 'PKCS7'));

    final encrypted = Encrypted.fromBase64(utf8.decode(encryptedData));
    final decrypted = encrypter.decryptBytes(encrypted, iv: iv);

    return Uint8List.fromList(decrypted);
  }
}
