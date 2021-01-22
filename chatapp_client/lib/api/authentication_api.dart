import 'package:http/http.dart' as http;
import "dart:convert";

class AuthenticationApi{
  
  static register(hashedPassword, publicKey, privateKey){

    const url = "registeration_endpoint_here";
    
    http.post(url, body: json.encode({
      'hashedPassword': hashedPassword,
      'publicKey': publicKey,
      'privateKey': privateKey,
    }));
  }

  static login(hashedPassword){
    const url = "login_endpoint_here";
    
    http.post(url, body: json.encode({
      'hashedPassword': hashedPassword,
    }));
  }

}