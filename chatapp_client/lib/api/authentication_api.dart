import 'package:chatapp_client/utils/urls.dart';
import 'package:http/http.dart' as http;
import "dart:convert";
import 'dart:io';
import '../helpers/encryption_helper.dart';
import 'package:rsa_encrypt/rsa_encrypt.dart';
import 'package:pointycastle/api.dart' as encryption;

class AuthenticationApi {
  // static const BaseUrl = "http://192.168.0.100:3000/";

  static register(hashedPassword, publicKey, privateKey) {
    const url = "registeration_endpoint_here";
    http.post(
      url,
      body: json.encode({
        'hashedPassword': hashedPassword,
        'publicKey': publicKey,
        'privateKey': privateKey,
      }),
    );
  }

  static Future getOtp(name, email, phone_num) async {
    print(name + " " + email + " " + phone_num);
    const url = Urls.baseUrl + "user/getotp";
    print(url);
    http.Response res = await http.post(
      url,
      body: json.encode({
        'name': name,
        'email': email,
        'phone_num': phone_num,
      }),
      headers: {
        // "accept": "application/json",
        // "content-type": "application/json"
        HttpHeaders.contentTypeHeader: 'application/json',
        // "Content-Type": "application/json",
      },
    );
    return res;
  }

  static Future verifyOtp(
      String name,
      String email,
      String password,
      String phone_num,
      int otp,
      String publicKey,
      String privateKey,
      String hashedPass) async {
    // print(name+" "+email+" "+phone_num+" "+password+" "+otp);
    print(otp);
    const url = Urls.baseUrl +"user/verifyotp";
    print(url);
    http.Response res = await http.post(
      url,
      body: json.encode({
        'name': name,
        'email': email,
        'password': password,
        'phone_num': phone_num,
        'otp': otp,
        'publicKey': publicKey,
        'privateKey': privateKey,
        'hashedPass': hashedPass,
      }),
      headers: {
        // "accept": "application/json",
        // "content-type": "application/json"
        HttpHeaders.contentTypeHeader: 'application/json',
        // "Content-Type": "application/json",
      },
    );
    return res;
  }

  static Future login(hashedPassword,encryption_key, email) async {
    const url = Urls.baseUrl + 'auth/login';
    print(url + " " + email);
    var res = await http.post(
      url,
      body: json.encode({
        'hashedPassword': hashedPassword,
        'email': email,
      }),
      headers: {
        // "accept": "application/json",
        // "content-type": "application/json"
        HttpHeaders.contentTypeHeader: 'application/json',
        // "Content-Type": "application/json",
      },
    );
    
    final response=json.decode(res.body);
    print("STATUS HERE");
    print(res.statusCode);
    print(json.decode(res.body));
    print("HEEYYYYYYY--111");
    print(response['user']['privateKey']);
    response['user']['privateKey']=EncryptionHelper.decryptPrivateKey(
    encryption_key, response['user']['privateKey']); 
    print("HEEYYYYYY--222");
    print(response['user']['privateKey']);
     print("HEEYYYYYY--333");
    print(json.encode(response));
    // res.body=json.encode(response);
    // catch error
    return json.encode(response);
  }
}
