import "package:flutter/material.dart";
import 'dart:io';

import 'dart:convert';
import 'package:flutter_socket_io/flutter_socket_io.dart';
import 'package:flutter_socket_io/socket_io_manager.dart';
// import 'package:provider/provider.dart';
// import '../utlis/message_store.dart';
// import 'package:adhara_socket_io/adhara_socket_io.dart';

class ChatScreen extends StatefulWidget {
  static final routeName = "/chatscreen";
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  // SocketIO _socket;
  // SocketIOManager _manager;
  SocketIO socketIO;
  TextEditingController messageController = new TextEditingController();

  List<String> messages;
  double height, width;
  TextEditingController textController;
  ScrollController scrollController;
  
  @override
  void initState() {
    messages = [];
    //Initializing the TextEditingController and ScrollController
    textController = TextEditingController();
    scrollController = ScrollController();
    socketIO = SocketIOManager().createSocketIO(
      'http://10.0.2.2:3000',
      '',
    );
    socketIO.init();
    socketIO.subscribe('receive_message', (jsonData) {
      //Convert the JSON data received into a Map
      Map<String, dynamic> data = json.decode(jsonData);
      this.setState(() => messages.add(data['message']));
      scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 600),
        curve: Curves.ease,
      );
    });
    //Connect to the socket
    socketIO.connect();
    super.initState();

    socketIO.sendMessage(
              'send_message', json.encode({'message': "connection made!!!"}));
    // init();
    // print("socket connected");
    
  }

  // _socketOptions() {
  //   final Map<String, String> userMap = {"from": "dummy"};

  //   return SocketOptions("http://127.0.0.1:3000/",
  //       enableLogging: true,
  //       transports: [Transports.WEB_SOCKET],
  //       query: userMap);
  // }

  void init() async {
    // _manager = SocketIOManager();
    // _socket = await _manager.createInstance(_socketOptions());
    // _socket.connect();
  }

  @override
  Widget build(BuildContext context) {
    // final store = Provider.of<MessageStore>(context, listen: false);
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
                  // store.test();
                  // sendSingleChatMessage(messageController.text);
                })
              ],
            ),
          ),
        ));
  }

  // sendSingleChatMessage(String chatMessageModel) {
  //   if (_socket == null) {
  //     print('Cannot Send Message');
  //     return;
  //   }
  //   print("sent");
  //   _socket.emit("connection", [
  //     {"message": "hellooooo"}
  //   ]);
  // }
}
