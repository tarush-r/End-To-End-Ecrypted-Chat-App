import 'package:chatapp_client/utils/urls.dart';
import 'package:http/http.dart' as http;
import "dart:convert";
import 'dart:io';

class ContactsApi {
  
  // static const BaseUrl = "http://192.168.0.100:3000/";

  static Future getVerifiedContacts(contactslist, token) async {

    const url = Urls.baseUrl +"user/getverifiedcontacts/";
    print(json.encode(contactslist));
    print("asdasdaaaaaaaaaaaaaaaaaa");
    http.Response res = await http.post(
      url,
      body: json.encode(contactslist),
      headers: {
        'Authorization': 'Bearer $token',
        HttpHeaders.contentTypeHeader: 'application/json',
      }, 
    );
    print("====================");
    print(json.decode(res.body));
    print("====================");
    return json.decode(res.body);

  }

}