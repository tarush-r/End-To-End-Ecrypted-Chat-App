import 'package:crypto/crypto.dart';
import 'dart:convert';
import 'package:rsa_encrypt/rsa_encrypt.dart';
import 'package:pointycastle/api.dart' as encryption;
import 'package:pointycastle/export.dart' as pointy;
import 'package:asn1lib/asn1lib.dart';
import 'package:encrypt/encrypt.dart';
import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

class EncryptionHelper {
  static hashPassword(String password) {
    var bytes = utf8.encode(password); // data being hashed

    var digest = sha1.convert(bytes).toString();
    List<String> divided_hashed_password = [];
    divided_hashed_password.add(digest.substring(0, 23));
    divided_hashed_password.add(digest.substring(24, 40));
    return divided_hashed_password;
    //api to send pass to server
    // print(digest.substring(20, 40));
  }

  static encryptPrivateKey(
      String key_hashed_password, String text_private_key) {
    final plainText = text_private_key;
    final key = Key.fromUtf8(key_hashed_password);
    final iv = IV.fromUtf8("bfdcjjnjfnf");
    final encrypter = Encrypter(AES(key));
    final encrypted = encrypter.encrypt(plainText, iv: iv);
    print("PLAIN");
    print(plainText); //generated private key (considered as plain text to be encrypted)
    print("ENCRYPTED");
    print(encrypted.base64); //encrypted private key in string format
    return encrypted.base64;
  }

  static decryptPrivateKey(
      String key_hashed_password, String encrypted_private_key) {
    final key = Key.fromUtf8(key_hashed_password);
    final iv = IV.fromUtf8("bfdcjjnjfnf");

    final encrypter = Encrypter(AES(key));

    // final encrypted = encrypter.encrypt(plainText, iv: iv);
    final decrypted =
        encrypter.decrypt(Encrypted.fromBase64(encrypted_private_key), iv: iv);
    print("ENCRYPTED");
    print(encrypted_private_key); //encrypted private key in string format
    print("DECRYPTED");
    print(decrypted); //decrypted private key(which was earlier passed as plain text)
    return decrypted;
  }

  static Future<
          encryption
              .AsymmetricKeyPair<encryption.PublicKey, encryption.PrivateKey>>
      getKeyPair() {
    var helper = RsaKeyHelper();
    return helper.computeRSAKeyPair(helper.getSecureRandom());
  }

  static Future<
          encryption
              .AsymmetricKeyPair<encryption.PublicKey, encryption.PrivateKey>>
      generateKeyPair() async {
    Future<encryption.AsymmetricKeyPair> futureKeyPair;
    encryption.AsymmetricKeyPair keyPair;
    keyPair = await getKeyPair();
    return keyPair;
    // print(keyPair.publicKey);
    // print(encrypt("Tarush", keyPair.publicKey));
    // print(decrypt(encrypt("Tarush", keyPair.publicKey), keyPair.privateKey));
  }

  static String convertPublicKeyToString(pointy.RSAPublicKey publicKey) {
    var topLevel = ASN1Sequence();

    topLevel.add(ASN1Integer(publicKey.modulus));
    topLevel.add(ASN1Integer(publicKey.exponent));

    var dataBase64 = base64.encode(topLevel.encodedBytes);
    return "$dataBase64";
  }

  static pointy.RSAPublicKey _parsePublic(ASN1Sequence sequence) {
    final modulus = (sequence.elements[0] as ASN1Integer).valueAsBigInteger;
    final exponent = (sequence.elements[1] as ASN1Integer).valueAsBigInteger;

    return pointy.RSAPublicKey(modulus, exponent);
  }

  static ASN1Sequence _parseSequence(List<String> rows) {
    final keyText = rows
        .skipWhile((row) => row.startsWith('-----BEGIN'))
        .takeWhile((row) => !row.startsWith('-----END'))
        .map((row) => row.trim())
        .join('');

    final keyBytes = Uint8List.fromList(base64.decode(keyText));
    final asn1Parser = ASN1Parser(keyBytes);

    return asn1Parser.nextObject() as ASN1Sequence;
  }

  static pointy.RSAPublicKey convertStringToPublicKey(String key) {
    final rows = key.split('\n'); // LF-only, this could be a problem
    final header = rows.first;
    return _parsePublic(_parseSequence(rows));
  }

  static String convertPrivateKeyToString(pointy.RSAPrivateKey privateKey) {
    var topLevel = ASN1Sequence();

    var version = ASN1Integer(BigInt.from(0));
    var modulus = ASN1Integer(privateKey.n);
    var publicExponent = ASN1Integer(privateKey.exponent);
    var privateExponent = ASN1Integer(privateKey.d);
    var p = ASN1Integer(privateKey.p);
    var q = ASN1Integer(privateKey.q);
    var dP = privateKey.d % (privateKey.p - BigInt.from(1));
    var exp1 = ASN1Integer(dP);
    var dQ = privateKey.d % (privateKey.q - BigInt.from(1));
    var exp2 = ASN1Integer(dQ);
    var iQ = privateKey.q.modInverse(privateKey.p);
    var co = ASN1Integer(iQ);

    topLevel.add(version);
    topLevel.add(modulus);
    topLevel.add(publicExponent);
    topLevel.add(privateExponent);
    topLevel.add(p);
    topLevel.add(q);
    topLevel.add(exp1);
    topLevel.add(exp2);
    topLevel.add(co);

    var dataBase64 = base64.encode(topLevel.encodedBytes);

    return "$dataBase64";
  }

  static pointy.RSAPrivateKey _parsePrivate(ASN1Sequence sequence) {
    final modulus = (sequence.elements[1] as ASN1Integer).valueAsBigInteger;
    final exponent = (sequence.elements[3] as ASN1Integer).valueAsBigInteger;
    final p = (sequence.elements[4] as ASN1Integer).valueAsBigInteger;
    final q = (sequence.elements[5] as ASN1Integer).valueAsBigInteger;

    return pointy.RSAPrivateKey(modulus, exponent, p, q);
  }

  static pointy.RSAPrivateKey convertStringToPrivateKey(String key) {
    final rows = key.split('\n'); // LF-only, this could be a problem
    final header = rows.first;

    return _parsePrivate(_parseSequence(rows));
  }
}
