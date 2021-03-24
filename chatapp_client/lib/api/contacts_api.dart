import 'package:http/http.dart' as http;
import "dart:convert";
import 'dart:io';

class ContactsApi {
  
  static const BaseUrl = "http://10.0.2.2:3000/";

  static Future getVerifiedContacts(contactslist) async {

    const url = BaseUrl+"user/getverifiedcontacts/";
    print(json.encode(contactslist));
    print("asdasda");
    http.Response res = await http.post(
      url,
      body: json.encode(contactslist),
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
      }, 
    );
    print("====================");
    print(json.decode(res.body)[0]['name']);
    print("====================");
    return json.decode(res.body);

  }

}