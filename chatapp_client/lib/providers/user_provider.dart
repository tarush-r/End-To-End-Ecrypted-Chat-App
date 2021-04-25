import 'package:chatapp_client/models/chat_contact_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import 'package:provider/provider.dart';

class UserProvider with ChangeNotifier{

  Map _user;  
  var _selectedUser;

  void initUser(user) {
    _user = user;
    notifyListeners();
  }

  void initSelectedUser(user) {
    _selectedUser = user;
    print("SELECTED USER HERE=");
    print(_selectedUser);
    // notifyListeners();
  }

  Map get user {
    Map temp;
    temp = _user;
    return temp;
  }

  get selectedUser {
    var temp;
    temp = _selectedUser;
    return temp;
  }

  void logout() {
    _user = null;
    _selectedUser = null;
  }

}