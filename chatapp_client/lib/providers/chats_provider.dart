import 'package:chatapp_client/models/chat_contact_model.dart';
import 'package:flutter/cupertino.dart';



class ChatsProvider with ChangeNotifier {
  List<ChatContactModel> _allChats = [];
  
  List<ChatContactModel> get allChats {
    return [..._allChats];
  }

  void addChat() {
    notifyListeners();
  }
}