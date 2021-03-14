import "package:flutter/material.dart";
import 'dart:io';
import 'package:provider/provider.dart';
import '../utlis/message_store.dart';
import 'package:adhara_socket_io/adhara_socket_io.dart';

class ChatScreen extends StatefulWidget {
  static final routeName = "/chatscreen";
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  SocketIO _socket;
  SocketIOManager _manager;
  TextEditingController messageController = new TextEditingController();
  @override
  void initState() {
    super.initState();
    init();
    print("socket connected");
    
  }

  _socketOptions() {
    final Map<String, String> userMap = {"from": "dummy"};

    return SocketOptions("http://127.0.0.1:3000/",
        enableLogging: true,
        transports: [Transports.WEB_SOCKET],
        query: userMap);
  }

  void init() async {
    _manager = SocketIOManager();
    _socket = await _manager.createInstance(_socketOptions());
    _socket.connect();
  }

  @override
  Widget build(BuildContext context) {
    final store = Provider.of<MessageStore>(context, listen: false);
    return Scaffold(
        appBar: AppBar(
          title: Text("Chat Screen"),
        ),
        body: Center(
          child: Container(
            height: 500,
            width: 500,
            child: Row(
              children: [
                Container(
                  width: 300,
                  height: 100,
                  child: TextField(
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Enter a search term'),
                  ),
                ),
                RaisedButton(onPressed: () {
                  store.test();
                  // sendSingleChatMessage(messageController.text);
                })
              ],
            ),
          ),
        ));
  }

  sendSingleChatMessage(String chatMessageModel) {
    if (_socket == null) {
      print('Cannot Send Message');
      return;
    }
    print("sent");
    _socket.emit("connection", [
      {"message": "hellooooo"}
    ]);
  }
}
