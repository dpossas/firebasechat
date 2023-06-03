import 'package:encrypt/encrypt.dart';

class EncryptService {
  final String encryptKey;
  final String encryptIV;
  late Encrypter encrypter;

  EncryptService({required this.encryptKey, required this.encryptIV}) {
    encrypter = Encrypter(AES(Key.fromUtf8(encryptKey), mode: AESMode.ecb));
  }

  String encrypt(String message) {
    return encrypter.encrypt(message, iv: IV.fromUtf8(encryptIV)).base64;
  }

  String decrypt(String encryptedMessage) {
    return encrypter.decrypt(
      Encrypted.fromBase64(encryptedMessage),
      iv: IV.fromUtf8(encryptIV),
    );
  }
}
