import 'package:crypto/crypto.dart';
import 'dart:convert';
import 'package:rsa_encrypt/rsa_encrypt.dart';
import 'package:pointycastle/api.dart' as encryption;

class EncryptionHelper {
  static hashPassword(String password) {
    var bytes = utf8.encode(password); // data being hashed

    var digest = sha1.convert(bytes).toString();
    return digest.substring(0, 20);
    //api to send pass to server
    // print(digest.substring(20, 40));
  }

  static Future<encryption.AsymmetricKeyPair<encryption.PublicKey, encryption.PrivateKey>> getKeyPair() {
    var helper = RsaKeyHelper();
    return helper.computeRSAKeyPair(helper.getSecureRandom());
  }

  static Future<encryption.AsymmetricKeyPair<encryption.PublicKey, encryption.PrivateKey>> generateKeyPair() async {
    Future<encryption.AsymmetricKeyPair> futureKeyPair;
    encryption.AsymmetricKeyPair keyPair;
    keyPair = await getKeyPair();
    return keyPair;
    // print(keyPair.publicKey);
    // print(encrypt("Tarush", keyPair.publicKey));
    // print(decrypt(encrypt("Tarush", keyPair.publicKey), keyPair.privateKey));
    

  }
}
