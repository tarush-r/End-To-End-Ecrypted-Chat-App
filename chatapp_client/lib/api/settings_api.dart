import 'package:chatapp_client/utils/urls.dart';
import 'package:http/http.dart' as http;
import "dart:convert";
import 'dart:io';
import '../helpers/encryption_helper.dart';
import 'package:rsa_encrypt/rsa_encrypt.dart';
import 'package:pointycastle/api.dart' as encryption;

class SettingsApi {
  // static const BaseUrl = "http://192.168.0.100:3000/";

  static Future resetPassword(
      String oldPassword,
      String newPassword,
      String encryption_key,
      String privateKey,
      String email,
      String token) async {
    const url = Urls.baseUrl +"settings/resetPassword";
    Map passwords = {
      "oldPassword": oldPassword,
      "newPassword": newPassword,
      "privateKey":
          EncryptionHelper.encryptPrivateKey(encryption_key, privateKey),
      "email": email,
    };
    print(json.encode(passwords));
    print("reset password api");
    http.Response res = await http.post(
      url,
      body: json.encode(passwords),
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        // 'Authorization': 'Bearer $token',
      },
    );
    print("====================");
    print(res.body);
    // print(json.decode(res.body)[0]['name']);
    print("====================");
    return json.decode(res.body);
  }

  static Future deleteAccount(String email) async {
    const url = Urls.baseUrl + "settings/deleteAccount";
    Map emailMap = {
      "email": email,
    };
    print(json.encode(emailMap));
    print("reset password api");
    http.Response res = await http.post(
      url,
      body: json.encode(emailMap),
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        // 'Authorization': 'Bearer $token',
      },
    );
    print("====================");
    print(res.body);
    // print(json.decode(res.body)[0]['name']);
    print("====================");
    return json.decode(res.body);
  }

  static Future otpForgotPassword(String email) async {
    const url = Urls.baseUrl + "settings/sendotpForgetPassword";
    Map emailMap = {
      "email": email,
    };
    print(json.encode(emailMap));
    print("reset password api");
    http.Response res = await http.post(
      url,
      body: json.encode(emailMap),
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        // 'Authorization': 'Bearer $token',
      },
    );
    print("====================");
    print(res.body);
    // print(json.decode(res.body)[0]['name']);
    print("====================");
    return json.decode(res.body);
  }

  static Future forgotPassword(String newPassword, int otp,
      String encryption_key, String privateKey, String email) async {
    const url = Urls.baseUrl +"settings/forgetPassword";
    Map forgotPassword = {
      "email": email,
      "newPassword": newPassword,
      "privateKey":
          EncryptionHelper.encryptPrivateKey(encryption_key, privateKey),
      "otp": otp
    };
    print(json.encode(forgotPassword));
    print("forgot password api");
    http.Response res = await http.post(
      url,
      body: json.encode(forgotPassword),
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        // 'Authorization': 'Bearer $token',
      },
    );
    print("====================");
    print(res.body);
    // print(json.decode(res.body)[0]['name']);
    print("====================");
    return json.decode(res.body);
  }

  static Future updateStatus(String status, String token) async {
    const url = Urls.baseUrl + "settings/statusUpdate";
    Map data = {
      'status': status,
    };
    print(json.encode(status));
    print("status update api");
    http.Response res = await http.post(
      url,
      body: json.encode(data),
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    print("====================");
    print(res.body);
    // print(json.decode(res.body)[0]['name']);
    print("====================");
    return res;
  }

  static Future updateProfilePhoto(String profilePhotoUrl, String token) async {
    const url = Urls.baseUrl + "settings/profileUpdate";
    Map data = {
      'profile_pic': profilePhotoUrl,
    };
    print(json.encode(data));
    print("status update api");
    http.Response res = await http.post(
      url,
      body: json.encode(data),
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    print("====================");
    print(res.body);
    // print(json.decode(res.body)[0]['name']);
    print("====================");
    return res;
  }

  static Future logout(String token) async {
    const url = Urls.baseUrl + "settings/logout";
    print("logout api");
    http.Response res = await http.post(
      url,
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    print("====================");
    print(res.body);
    // print(json.decode(res.body)[0]['name']);
    print("====================");
    return res;
  }

  static Future logoutAll(String token) async {
    const url = Urls.baseUrl + "settings/logoutAll";
    print("logout api");
    http.Response res = await http.post(
      url,
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    print("====================");
    print(res.body);
    // print(json.decode(res.body)[0]['name']);
    print("====================");
    return res;
  }
}
