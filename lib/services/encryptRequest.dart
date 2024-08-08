import 'package:encrypt/encrypt.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class EncryptionHelper {
  static final key = Key.fromUtf8('E1nl0g1C@/@/encrypt10n/#/121549@'); // 32 chars
  static final iv = IV.fromLength(16);
  static final encrypter = Encrypter(AES(key));

  static String encrypt(String plainText) {
    final encrypted = encrypter.encrypt(plainText, iv: iv);
    return encrypted.base64;
  }

  static String decrypt(String encryptedText) {
    final decrypted = encrypter.decrypt64(encryptedText, iv: iv);
    return decrypted;
  }
}

Future<void> sendEncryptedData(String url, Map<String, dynamic> data) async {
  final encryptedData = EncryptionHelper.encrypt(jsonEncode(data));
  final response = await http.post(
    Uri.parse(url),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({'data': encryptedData}),
  );

  if (response.statusCode == 200) {
    print('Data sent successfully!');
  } else {
    print('Failed to send data: ${response.reasonPhrase}');
  }
}