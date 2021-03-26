import 'package:chatapp_client/models/chat_model.dart';
import 'package:chatapp_client/utlis/focus_handler.dart';
import 'package:chatapp_client/utlis/urls.dart';
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
  List chats = [];

  @override
  void initState() {
    messages = [];
    chats.add(ChatModel(to: "Rahil", from: 'Tarush', message: "Hey", seen: true));
    chats.add(ChatModel(to: "Rahil", from: 'Tarush', message: "This is a test", seen: true));
    chats.add(ChatModel(to: "Tarush", from: 'Rahil', message: "It works", seen: true));
    chats.add(ChatModel(to: "Rahil", from: 'Tarush', message: "Hey", seen: true));
    chats.add(ChatModel(to: "Rahil", from: 'Tarush', message: "This is a test", seen: true));
    chats.add(ChatModel(to: "Tarush", from: 'Rahil', message: "It works", seen: true));
    chats.add(ChatModel(to: "Rahil", from: 'Tarush', message: "Hey", seen: true));
    chats.add(ChatModel(to: "Rahil", from: 'Tarush', message: "This is a test", seen: true));
    chats.add(ChatModel(to: "Tarush", from: 'Rahil', message: "It works", seen: true));
    //Initializing the TextEditingController and ScrollController
    textController = TextEditingController();
    scrollController = ScrollController();
    socketIO = SocketIOManager().createSocketIO(
      Urls.baseUrl,
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

  _chatBubble(chat) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        // padding: EdgeInsets.all(10),
        color: Colors.red,
        height: 100,
        width: 50,
        child: Text(chat.message),
        
        
      ),
    );
    
  }

  _messagesContainer() {
    return GestureDetector(
      onTap: () {
        FocusHandler.unfocus(context);
      },
      child: Container(
          color: Colors.blue,
          child: ListView.builder(
            itemCount: chats.length,
            itemBuilder: (context, index) {
              return _chatBubble(chats[index]);
            },
          )
          // child: ListView(
          //   children: [

          //   ],
          // ),
          // height: double.infinity,
          // width: double.infinity,
          ),
    );
  }

  _inputMessage() {
    return Container(
      // color: Colors.red,
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Container(
              child: Icon(Icons.add),
            ),
          ),
          Expanded(
            flex: 10,
            child: TextFormField(
              decoration: InputDecoration(
                hintText: '',
                border: new OutlineInputBorder(
                  borderRadius: const BorderRadius.all(
                    const Radius.circular(20.0),
                  ),
                ),
                // enabledBorder: OutlineInputBorder(
                //     borderSide:
                //         BorderSide(color: Colors.black, width: 2.0)),
                // focusedBorder: OutlineInputBorder(
                //   borderSide: BorderSide(color: Colors.red, width: 2.0),
                // ),
              ),
              validator: (val) => val.isEmpty ? 'Enter a valid Email' : null,
              // controller: emailController,
            ),
          ),
          Expanded(
              flex: 2,
              child: Container(
                child: Icon(Icons.send),
              ))
        ],
      ),
      // height: 100,
      // width: double.infinity,
    );
  }

  @override
  Widget build(BuildContext context) {
    // final store = Provider.of<MessageStore>(context, listen: false);
    return Scaffold(
      // appBar: AppBar(
      //   title: Text("Chat Screen"),
      // ),
      body: SingleChildScrollView(
        child: ConstrainedBox(
          constraints:
              BoxConstraints(maxHeight: MediaQuery.of(context).size.height),
          child: Padding(
            padding: EdgeInsets.all(10),
            child: Container(
              // height: MediaQuery.of(context).size.height,
              // width: MediaQuery.of(context).size.width,

              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                    flex: 10,
                    child: _messagesContainer(),
                  ),
                  Expanded(
                    flex: 1,
                    child: _inputMessage(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
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
