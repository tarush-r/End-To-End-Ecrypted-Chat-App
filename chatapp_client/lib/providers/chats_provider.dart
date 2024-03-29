import 'dart:convert';

import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:chatapp_client/api/chat_api.dart';
import 'package:chatapp_client/helpers/database_helper.dart';
import 'package:chatapp_client/helpers/encryption_helper.dart';
import 'package:chatapp_client/helpers/sharedpreferences_helper.dart';
import 'package:chatapp_client/models/chat_contact_model.dart';
import 'package:chatapp_client/models/chat_model.dart';
import 'package:chatapp_client/screens/call_screen.dart';
import 'package:chatapp_client/utils/context_util.dart';
import 'package:chatapp_client/utils/urls.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_socket_io/flutter_socket_io.dart';
import 'package:flutter_socket_io/socket_io_manager.dart';
import 'package:provider/provider.dart';
import '../helpers/encryption_helper.dart';
import 'package:rsa_encrypt/rsa_encrypt.dart';

class ChatsProvider with ChangeNotifier {
  List<ChatContactModel> _allChatContacts = [];
  List _allChats = [];

  List<ChatModel> _selectedChats = [];
  SocketIO socketIO;
  DatabaseHelper databaseHelper;

  Future<void> getAllChats() async {
    List done = [];
    Map unread = {};
    List<ChatContactModel> tempChatContacts = [];
    String token;
    token = await SharedPreferencesHelper.getToken();
    print("TOKEN@@@@@@@@@@@@@@@@@@@@@@@@@@@: " + token);
    var trueRes = await ChatApi.getNewChats(token);
    var response = trueRes;
    // _allChats = trueRes['chats'];
    await _setAllChats(trueRes['chats']);
    // response['chats'] = trueRes['chats'].reversed.toList();
    if (_allChats == null) {
      response['chats'] = [];
    } else {
      response['chats'] = _allChats.reversed.toList();
    }
    // response['chats'] = _allChats.reversed.toList();
    print(response['chats']);

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

  Future _setAllChats(var newChats) async {
    var user=await SharedPreferencesHelper.getUser();
    newChats.forEach((newChat) async{
     await databaseHelper.insert({
        'toId': newChat['to']['_id'],
        'toName': newChat['to']['name'],
        'toEmail': newChat['to']['email'],
        'toPublicKey': newChat['to']['publicKey'],
        'toProfilePic': newChat['to']['profile_pic'],
        'fromId': newChat['from']['_id'],
        'fromName': newChat['from']['name'],
        'fromEmail': newChat['from']['email'],
        'fromPublicKey': newChat['from']['publicKey'],
        'fromProfilePic': newChat['from']['profile_pic'],
        'message':decrypt(newChat['message'], EncryptionHelper.convertStringToPrivateKey(user['privateKey'])),
        // 'message': newChat['message'],
        'sentAt': newChat['sentAt'],
        'seen': newChat['seen'],
        'isStored': 1,
      });
    });
    List databaseChats = await databaseHelper.getChats();
    print("DATABASE CHATS");
    print(databaseChats);
    databaseChats.forEach((databaseChat) {
      bool seenStatus = databaseChat['seen'] == 1;
      _allChats.add({
        '_id': 'idfromnode',
        'seen': seenStatus,
        'from': {
          'profile_pic': databaseChat['fromProfilePic'],
          '_id': databaseChat['fromId'],
          'name': databaseChat['fromName'],
          'email': databaseChat['fromEmail'],
          'publicKey': databaseChat['fromPublicKey']
        },
        'to': {
          'profile_pic': databaseChat['toProfilePic'],
          '_id': databaseChat['toId'],
          'name': databaseChat['toName'],
          'email': databaseChat['toEmail'],
          'publicKey': databaseChat['toPublicKey']
        },
        'sentAt': databaseChat['sentAt'],
        'message': databaseChat['message']
      });
    });
    print("FOCUS");
    print(_allChats);
  }

  void initSelectedUserChats(String id) {
    _selectedChats = [];
    if (_allChats == null) {
      return;
    }
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

  void addChat(
      String message, Map user, var selectedUser, bool isReceived) async {
    Map chatMap;
    // print(NavigatorState._history);
    print("received heree_----------------------------------");
    print(message);
    print(user);
    print(selectedUser);
    if (isReceived) {
      if (ContextUtil.buildContext.last != null &&
          user['_id'] == ContextUtil.selectedUserIds.last) {
        print("inside iff");
        await databaseHelper.insert({
          'toId': selectedUser['_id'],
          'toName': selectedUser['name'],
          'toEmail': selectedUser['email'],
          'toPublicKey': selectedUser['publicKey'],
          'toProfilePic': selectedUser['profile_pic'],
          'fromId': user['_id'],
          'fromName': user['name'],
          'fromEmail': user['email'],
          'fromPublicKey': user['publicKey'],
          'fromProfilePic': user['profile_pic'],
          'message': message,
          'sentAt': DateTime.now().toString(),
          'seen': 1,
          'isStored': 1,
        });
        chatMap = {
          '_id': 'idfromnode',
          'seen': true,
          'from': {
            'profile_pic': user['profile_pic'],
            '_id': user['_id'],
            'name': user['name'],
            'email': user['email'],
            'publicKey': user['publicKey']
          },
          'to': {
            'profile_pic': selectedUser['profile_pic'],
            '_id': selectedUser['_id'],
            'name': selectedUser['name'],
            'email': selectedUser['email'],
            'publicKey': selectedUser['publicKey']
          },
          'sentAt': DateTime.now(),
          'message': message
        };
      } else {
        print("inside else");
        await databaseHelper.insert({
          'toId': selectedUser['_id'],
          'toName': selectedUser['name'],
          'toEmail': selectedUser['email'],
          'toPublicKey': selectedUser['publicKey'],
          'toProfilePic': selectedUser['profile_pic'],
          'fromId': user['_id'],
          'fromName': user['name'],
          'fromEmail': user['email'],
          'fromPublicKey': user['publicKey'],
          'fromProfilePic': user['profile_pic'],
          'message': message,
          'sentAt': DateTime.now().toString(),
          'seen': 0,
          'isStored': 1,
        });
        chatMap = {
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
            'profile_pic': selectedUser['profile_pic'],
            '_id': selectedUser['_id'],
            'name': selectedUser['name'],
            'email': selectedUser['email'],
            'publicKey': selectedUser['publicKey']
          },
          'sentAt': DateTime.now(),
          'message': message
        };
      }
    } else {
      // try {
      await databaseHelper.insert({
        'toId': selectedUser.id,
        'toName': selectedUser.name,
        'toEmail': selectedUser.email,
        'toPublicKey': selectedUser.publicKey,
        'toProfilePic': selectedUser.profilePic,
        'fromId': user['_id'],
        'fromName': user['name'],
        'fromEmail': user['email'],
        'fromPublicKey': user['publicKey'],
        'fromProfilePic': user['profile_pic'],
        'message': message,
        'sentAt': DateTime.now().toString(),
        'seen': 0,
        'isStored': 1,
      });
      // } catch (error) {
      //   print(error.toString());
      // }
      chatMap = {
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
    }

    ChatModel newSelectedChat = ChatModel(
        to: chatMap['to']['_id'],
        from: chatMap['from']['_id'],
        message: chatMap['message'],
        seen: chatMap['seen'],
        time: chatMap['sentAt']);

    _allChats.add(chatMap);
    if (isReceived) {
      if (ContextUtil.buildContext.last != null &&
          user['_id'] == ContextUtil.selectedUserIds.last) {
        _selectedChats.add(newSelectedChat);
      }
    } else {
      _selectedChats.add(newSelectedChat);
    }
    print("ADDED");
    if (isReceived) {
      print(user['_id']);
      updateAllChatContacts(user['_id'], message, selectedUser, user, true);
    } else {
      updateAllChatContacts(
          selectedUser.id, message, selectedUser, user, false);
    }
    print(chatMap);
    // _allChats.add()

    notifyListeners();
    print("LISTENERS NOTIFIED");
  }

  void updateAllChatContacts(
      String id, String message, selectedUser, Map user, bool isReceived) {
    ChatContactModel freshChatContact;
    print("inside chat contacts" + id);
    print(_allChatContacts);
    ChatContactModel chatContact = _allChatContacts
        .firstWhere((chatContact) => chatContact.id == id, orElse: () => null);
    if (chatContact != null) {
      print("CHAT CONTACT NOT NULL");

      if (isReceived) {
        print("CONRTEXT AND ID");
        print(ContextUtil.buildContext.last);
        // print(ContextUtil.selectedUserIds.last);
        print(selectedUser['_id']);
        if (ContextUtil.buildContext.last != null &&
            ContextUtil.selectedUserIds.last == id) {
          print("buildcontext is not null");
          _allChatContacts.removeWhere((chatContact) => chatContact.id == id);

          chatContact.recentMessage = message;
          chatContact.recentMessageTime = DateTime.now().toString();
          chatContact.seen = true;
          chatContact.notificationCount = 0;
          _allChatContacts.insert(0, chatContact);
        } else {
          print("buildcontext is null");
          print("notification increment");
          _allChatContacts.removeWhere((chatContact) => chatContact.id == id);

          chatContact.recentMessage = message;
          chatContact.recentMessageTime = DateTime.now().toString();
          chatContact.seen = false;
          chatContact.notificationCount = chatContact.notificationCount + 1;
          _allChatContacts.insert(0, chatContact);
        }
      } else {
        print("buildcontext is null");
        _allChatContacts.removeWhere((chatContact) => chatContact.id == id);

        chatContact.recentMessage = message;
        chatContact.recentMessageTime = DateTime.now().toString();
        chatContact.seen = false;
        chatContact.notificationCount = 0;
        _allChatContacts.insert(0, chatContact);
      }
    } else {
      if (isReceived) {
        print("is received chat contact");
        freshChatContact = ChatContactModel(
            id: id,
            email: user['email'],
            name: user['name'],
            notificationCount: 1,
            profilePic: user['profile_pic'],
            publicKey: user['publicKey'],
            seen: false,
            recentMessage: message,
            recentMessageTime: DateTime.now().toString());
      } else {
        freshChatContact = ChatContactModel(
            id: id,
            email: selectedUser.email,
            name: selectedUser.name,
            notificationCount: 0,
            profilePic: selectedUser.profilePic,
            publicKey: selectedUser.publicKey,
            seen: false,
            recentMessage: message,
            recentMessageTime: DateTime.now().toString());
      }
      _allChatContacts.insert(0, freshChatContact);
    }

    print(_allChatContacts[0].notificationCount);
  }

  void readMessage(String receiverId, String senderId) async {
    // messages.add(Message(text, currentUser.chatID, receiverChatID));
    // print(message);
    await socketIO.sendMessage(
      'read_message',
      json.encode({
        'receiverId': receiverId,
        'senderId': senderId,
        // 'message': message,
      }),
    );
    print("done");
    // notifyListeners();
  }

  void storeMessage(String receiverId, String senderId) async {
    // messages.add(Message(text, currentUser.chatID, receiverChatID));
    // print(message);
    await socketIO.sendMessage(
      'store_message',
      json.encode({
        'receiverId': receiverId,
        'senderId': senderId,
        // 'message': message,
      }),
    );
    print("done");
    // notifyListeners();
  }

  void initSocket(id) {
    print(id);
    socketIO = SocketIOManager()
        .createSocketIO(Urls.baseUrl, '/', query: 'senderId=$id');
    socketIO.init();

    socketIO.subscribe('receive_message', (jsonData) async {
      Map<String, dynamic> data = json.decode(jsonData);
      print("RECEIVERRRRRRRRRRRRRRRRRRRRRRRRR");
      print(data);
      var user = await SharedPreferencesHelper.getUser();
      print(decrypt(data['message'], EncryptionHelper.convertStringToPrivateKey(user['privateKey'])));
      print("-------------------");
      // print(ContextUtil.buildContext.last);
      addChat(
        decrypt(data['message'], EncryptionHelper.convertStringToPrivateKey(user['privateKey'])),
        data['from'], data['to'], true);
      print("before function");
      print(ContextUtil.buildContext.last != null);
      // print(ContextUtil.selectedUserIds.last == data['from']['_id']);
      storeMessage(data['to']['_id'], data['from']['_id']);
      setStoredTrue(data['from']['_id'], data['to']['_id']);
      if (ContextUtil.buildContext.last != null &&
          ContextUtil.selectedUserIds.last == data['from']['_id']) {
        //call read message
        print("INSIDE@@@@@@@@@@@@@@");
        readMessage(data['to']['_id'], data['from']['_id']);
        setSeenTrue(data['from']['_id'], data['to']['_id']);
      }
      // messages.add(Message(
      //     data['content'], data['senderChatID'], data['receiverChatID']));
      // notifyListeners();
    });

    socketIO.subscribe('read_message', (jsonData) {
      Map<String, dynamic> data = json.decode(jsonData);
      setSeenTrue(data['senderId'], data['receiverId']);
      // databaseHelper.updateSeen(data['senderId'], data['receiverId']);
    });

    socketIO.subscribe('receive_call', (jsonData) {
      Map<String, dynamic> data = json.decode(jsonData);
      print(data);
      print(ContextUtil.homeScreenContext);
      print("context herere");
      Navigator.push(
      ContextUtil.homeScreenContext,
      //  await Navigator.pushNamed(
      //   context,
      MaterialPageRoute(
        builder: (context) => CallPage(
          channelName: data['call_id'],
          role: ClientRole.Broadcaster,
        ),
      ),
      
      // CallPage.routeName,
      // arguments: <String, String>{
      //   'email': selectedUser.email,
      //   'role': ClientRole.Broadcaster,
      // },
    );
    print("pushed");
      // setSeenTrue(data['senderId'], data['receiverId']);
      // databaseHelper.updateSeen(data['senderId'], data['receiverId']);
    });
    
    socketIO.subscribe('set_isStored_true', (jsonData) {
      Map<String, dynamic> data = json.decode(jsonData);
      setSeenTrue(data['senderId'], data['receiverId']);
      // databaseHelper.updateSeen(data['senderId'], data['receiverId']);
    });
    print("SOCKET CONNECTED@@@@");
    socketIO.connect();

    databaseHelper = DatabaseHelper();
  }

  void setStoredTrue(String from, String to) {
    if (_allChats == null) {
      return;
    }
    databaseHelper.updateIsStored(from, to);
    _allChats.forEach((chat) {
      if (chat['from']['_id'] == from && chat['to']['_id'] == to) {
        chat['isStored'] = true;
      }
    });

    // _allChatContacts.forEach((chatContact) {
    //   if (chatContact.id == from) {
    //     chatContact.notificationCount = 0;
    //   }
    // });

    // _selectedChats.forEach((selectedChat) {
    //   if (selectedChat.from == from) {
    //     selectedChat.seen = true;
    //   }
    // });
    notifyListeners();
  }


  void setSeenTrue(String from, String to) {
    if (_allChats == null) {
      return;
    }
    databaseHelper.updateSeen(from, to);
    _allChats.forEach((chat) {
      if (chat['from']['_id'] == from && chat['to']['_id'] == to) {
        chat['seen'] = true;
      }
    });

    _allChatContacts.forEach((chatContact) {
      if (chatContact.id == from) {
        chatContact.notificationCount = 0;
      }
    });

    _selectedChats.forEach((selectedChat) {
      if (selectedChat.from == from) {
        selectedChat.seen = true;
      }
    });
    notifyListeners();
  }

  void deleteSelectedUserChats(selectedUserId) {
    _allChats.removeWhere((chat) {
      return (chat['from']['_id']==selectedUserId || chat['to']['_id']==selectedUserId); 
    });

    _allChatContacts.removeWhere((chatContact) {
      return chatContact.id==selectedUserId;
    });
    notifyListeners();
  }

  void logout() {
    _allChatContacts = [];
    _allChats = [];
    _selectedChats = [];
    socketIO.disconnect();
    socketIO.destroy();
  }
}
