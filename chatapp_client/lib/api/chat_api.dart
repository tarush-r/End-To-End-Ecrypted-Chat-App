import 'package:chatapp_client/utils/urls.dart';
import 'package:http/http.dart' as http;
import "dart:convert";
import 'dart:io';

class ChatApi {
  // static const BaseUrl = "http://192.168.0.100:3000/";

  static Future getAllChats(token) async {
    print('hellooo');
    const url = Urls.baseUrl + "chat/getAllChats/";
    print(token);
    print("asdasda");
    http.Response res = await http.get(
      url,
      // body: json.encode(contactslist),
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    print("====================");
    print("ALL CCHATS");
    // print(json.decode(res.body));
    print("====================");
    return json.decode(res.body);
  }

  static Future getNewChats(token) async {
    print('hell0');
    const url = Urls.baseUrl + "chat/getNewChats/";
    print(token);
    print("asdasda");
    http.Response res = await http.get(
      url,
      // body: json.encode(contactslist),
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    print("====================");
    print("ALL CCHATS");
    // print(json.decode(res.body));
    print("====================");
    return json.decode(res.body);
  }

  static Future getAllCalls(token) async {
    print('hell0');
    const url = Urls.baseUrl + "chat/getAllCalls/";
    print(token);
    print("asdasda");
    http.Response res = await http.get(
      url,
      // body: json.encode(contactslist),
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    print("====================");
    print("ALL Calls");
    // print(json.decode(res.body));
    print("====================");
    return res;
  }

  static Future getSelectedUserChat(token) async {
    const url = Urls.baseUrl + "chat/getSelectedUserChat/";
    print(token);
    print(url);
    http.Response res = await http.get(
      url,
      // body: json.encode(contactslist),
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    print("====================");
    print(json.decode(res.body));
    print("====================");
    return json.decode(res.body);
  }

  static Future setSeenTrue(token, id) async {
    const url = Urls.baseUrl + "chat/setSeen/";
    print(token);
    print(url);
    Map data = {
      '_id': id,
    };
    http.Response res = await http.post(
      url,
      body: json.encode(data),
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    print("====================");
    //  print(json.decode(res.body));
    print("====================");
    return json.decode(res.body);
  }

  static Future deleteSelectedUserChat(String id, String token) async {
    const url = Urls.baseUrl + "chat/deleteSelectedUserChat";
    Map data = {
      '_id': id,
    };
    print(json.encode(data));
    print("delete api");
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

  static Future schedule(token, id, message, toSendAt) async {
    const url = Urls.baseUrl + "chat/schedule/";
    print(token);
    print(url);
    print(message);
    print(toSendAt is String);
    Map data = {'to': id, 'message': message, 'toSendAt': toSendAt.toString()};
    http.Response res = await http.post(
      url,
      body: json.encode(data),
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    print("====================");
    print(json.decode(res.body));
    print("====================");
    return json.decode(res.body);
  }

    static Future getSelectedUserProfile(token, id) async {
    print("getSelectedUserProfile");
    const url = Urls.baseUrl + "chat/getSelectedUserProfile/";
    Map data = {
      '_id': id,
    };
    http.Response res = await http.post(
      url,
      body: json.encode(data),
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    print(json.decode(res.body));
    print("====================");
    return json.decode(res.body);
  }

}

