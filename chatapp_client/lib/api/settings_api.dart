import 'package:http/http.dart' as http;
import "dart:convert";
import 'dart:io';

class SettingsApi {
  static const BaseUrl = "http://192.168.0.100:3000/";

  static Future resetPassword(String oldPassword, String newPassword,
      String email, String token) async {
    const url = BaseUrl + "settings/resetPassword";
    Map passwords = {
      "oldPassword": oldPassword,
      "newPassword": newPassword,
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
    const url = BaseUrl + "settings/deleteAccount";
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
    const url = BaseUrl + "settings/sendotpForgetPassword";
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

  static Future forgotPassword(
      String newPassword, int otp, String email) async {
    const url = BaseUrl + "settings/forgetPassword";
    Map forgotPassword = {
      "email": email,
      "newPassword": newPassword,
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
    const url = BaseUrl + "settings/statusUpdate";
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
}
