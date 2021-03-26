import 'package:chatapp_client/utlis/urls.dart';
import 'package:http/http.dart' as http;
import "dart:convert";
import 'dart:io';

class ChatApi {
  
  // static const BaseUrl = "http://192.168.0.100:3000/";

  static Future getAllChats(token) async {
    print('hellooo');
    const url = Urls.baseUrl +"chat/getAllChats/";
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
    print(json.decode(res.body));
    print("====================");
    return json.decode(res.body);

  }

}