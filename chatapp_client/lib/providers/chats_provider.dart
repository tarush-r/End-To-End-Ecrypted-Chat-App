import 'package:chatapp_client/api/chat_api.dart';
import 'package:chatapp_client/helpers/sharedpreferences_helper.dart';
import 'package:chatapp_client/models/chat_contact_model.dart';
import 'package:chatapp_client/models/chat_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class ChatsProvider with ChangeNotifier {
  List<ChatContactModel> _allChatContacts = [];
  List _allChats;

  List<ChatModel> _selectedChats = [];

  Future<void> getAllChats() async {
    List done = [];
    Map unread = {};
    List<ChatContactModel> tempChatContacts = [];
    String token;
    token = await SharedPreferencesHelper.getToken();
    print("TOKEN@@@@@@@@@@@@@@@@@@@@@@@@@@@: " + token);
    var trueRes = await ChatApi.getAllChats(token);
    var response = trueRes;
    _allChats = trueRes['chats'];
    response['chats'] = trueRes['chats'].reversed.toList();
    print(response['chats'].length);

    var user = await SharedPreferencesHelper.getUser();
    // tempChatContacts = ;
    for (int i = 0; i < response['chats'].length; i++) {
      // print(user);
      if (response['chats'][i]['from']['name'] == user['name']) {
        if (done.contains(response['chats'][i]['to']['_id'])) {
          print('if if');
          // if(response['chats'][i]['seen']==false){
          //   unread[response['chats'][i]['to']['_id']] = unread[response['chats'][i]['to']['_id']] +1;
          // }
          continue;
        } else {
          print('if else');
          done.add(response['chats'][i]['to']['_id']);
          print(response['chats'][i]['sentAt']);
          tempChatContacts.add(ChatContactModel(
              id: response['chats'][i]['to']['_id'],
              name: response['chats'][i]['to']['name'],
              recentMessage: response['chats'][i]['message'],
              notificationCount: 0,
              recentMessageTime: response['chats'][i]['sentAt'],
              publicKey: response['chats'][i]['to']['publicKey'],
              seen: response['chats'][i]['seen'],
              email: response['chats'][i]['to']['email'],
              profilePic: response['chats'][i]['to']['profile_pic']));
          // if(response['chats'][i]['seen']==false){
          //   unread[response['chats'][i]['to']['_id']] = 1;
          // }
          // response['chats'][i].firstWhere((chat)=>chat['to']['id']==);
        }
      } else {
        if (done.contains(response['chats'][i]['from']['_id'])) {
          print('else if ' + i.toString());
          if (response['chats'][i]['seen'] == false) {
            unread[response['chats'][i]['from']['_id']] =
                unread[response['chats'][i]['from']['_id']] + 1;
          }
          continue;
        } else {
          // print(response['chats'][i]['from']['_id']);
          done.add(response['chats'][i]['from']['_id']);
          print(response['chats'][i]['sentAt']);
          if (response['chats'][i]['seen'] == false) {
            unread[response['chats'][i]['from']['_id']] = 1;
          }
          tempChatContacts.add(ChatContactModel(
              id: response['chats'][i]['from']['_id'],
              name: response['chats'][i]['from']['name'],
              recentMessage: response['chats'][i]['message'],
              notificationCount: 0,
              recentMessageTime: response['chats'][i]['sentAt'],
              publicKey: response['chats'][i]['from']['publicKey'],
              seen: response['chats'][i]['seen'],
              email: response['chats'][i]['from']['email'],
              profilePic: response['chats'][i]['from']['profile_pic']));
          // response['chats'][i].firstWhere((chat)=>chat['to']['id']==);
        }
      }
    }
    print(done);
    print(unread);
    for (int i = 0; i < tempChatContacts.length; i++) {
      print(i);
      print(tempChatContacts[i].profilePic);
    }
    for (int i = 0; i < done.length; i++) {
      if (unread[done[i]] == null) {
        print('returned');
        continue;
      }
      tempChatContacts[i].notificationCount = unread[done[i]];
    }
    _allChatContacts = tempChatContacts;
    print("ALL CHATS");
    print(tempChatContacts);
    notifyListeners();
    print("NOTIFIED LISTENERS");
    // return [..._allChats];
  }

  List<ChatModel> initSelectedUserChats(String id) {
    _selectedChats = [];
    _allChats.forEach((chat) {
      if (chat['to']['_id'] == id || chat['from']['_id'] == id) {
        if (chat['sentAt'] is DateTime) {
          _selectedChats.add(ChatModel(
              to: chat['to']['_id'],
              from: chat['from']['_id'],
              message: chat['message'],
              seen: chat['seen'],
              time: chat['sentAt']));
        } else {
          _selectedChats.add(ChatModel(
              to: chat['to']['_id'],
              from: chat['from']['_id'],
              message: chat['message'],
              seen: chat['seen'],
              time: DateTime.parse(chat['sentAt'])));
        }
      }
    });
    print(_selectedChats);
    // notifyListeners();
  }

  List<ChatContactModel> get allChatContacts {
    List<ChatContactModel> temp;
    temp = _allChatContacts;
    return temp;
  }

  List<ChatModel> get getSelectedChats {
    List<ChatModel> temp;
    temp = _selectedChats;
    return temp;
  }

  void addChat(String message, Map user, var selectedUser) {
    print(message);
    print(user);
    print(selectedUser);
    Map chatMap = {
      '_id': 'idfromnode',
      'seen': false,
      'from': {
        'profile_pic': user['profile_pic'],
        '_id': user['_id'],
        'name': user['name'],
        'email': user['email'],
        'publicKey': user['publicKey']
      },
      'to': {
        'profile_pic': selectedUser.profilePic,
        '_id': selectedUser.id,
        'name': selectedUser.name,
        'email': selectedUser.email,
        'publicKey': selectedUser.publicKey
      },
      'sentAt': DateTime.now(),
      'message': message
    };

    ChatModel newSelectedChat = ChatModel(
        to: chatMap['to']['_id'],
        from: chatMap['from']['_id'],
        message: chatMap['message'],
        seen: chatMap['seen'],
        time: chatMap['sentAt']);

    _allChats.add(chatMap);
    _selectedChats.add(newSelectedChat);
    updateAllChatContacts(selectedUser.id, message, selectedUser);
    print(chatMap);
    // _allChats.add()

    notifyListeners();
    print("LISTENERS NOTIFIED");
  }

  void updateAllChatContacts(String id, String message, selectedUser) {
    print(_allChatContacts);
    ChatContactModel chatContact = _allChatContacts
        .firstWhere((chatContact) => chatContact.id == id, orElse: () => null);
    if (chatContact != null) {
      _allChatContacts.removeWhere((chatContact) => chatContact.id == id);
      chatContact.recentMessage = message;
      chatContact.recentMessageTime = DateTime.now().toString();
      chatContact.seen = false;
      chatContact.notificationCount = 0;
      _allChatContacts.insert(0, chatContact);
    }
    else{
      ChatContactModel freshChatContact = ChatContactModel(
        id: id,
        email: selectedUser.email,
        name: selectedUser.name,
        notificationCount: 0,
        profilePic: selectedUser.profilePic,
        publicKey: selectedUser.publicKey,
        seen: false,
        recentMessage: message,
        recentMessageTime: DateTime.now().toString());
        _allChatContacts.insert(0, freshChatContact);
    }
    

    print(_allChatContacts);
  }

  void logout() {
    _allChatContacts = [];
    _allChats = [];
    _selectedChats = [];
  }
}
