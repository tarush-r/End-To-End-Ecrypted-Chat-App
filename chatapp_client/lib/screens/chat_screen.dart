import 'package:chatapp_client/helpers/sharedpreferences_helper.dart';
import 'package:chatapp_client/models/chat_model.dart';
import 'package:chatapp_client/utils/color_themes.dart';
import 'package:chatapp_client/utils/focus_handler.dart';
import 'package:chatapp_client/utils/urls.dart';
import "package:flutter/material.dart";
import 'dart:io';
import '../widgets/chat_screen_appbar.dart';
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
  bool _isLoading = true;
  TextEditingController messageController = new TextEditingController();
  final _scrollController = ScrollController();

  List<String> messages;
  double height, width;
  TextEditingController textController;
  ScrollController scrollController;
  List chats = [];
  var user;
  _getUser() async {
    user = await SharedPreferencesHelper.getUser();
    print(user['_id']);

    socketIO = SocketIOManager().createSocketIO(
        Urls.baseUrl, '/',
        query: 'chatID=${user['_id']}');
    socketIO.init();

    socketIO.subscribe('receive_message', (jsonData) {
      Map<String, dynamic> data = json.decode(jsonData);
      print(data);
      // messages.add(Message(
      //     data['content'], data['senderChatID'], data['receiverChatID']));
      // notifyListeners();
    });

    socketIO.connect();

    setState(() {
      _isLoading = false;
      print("scrolling");
    });
  }

  void sendMessage(String text, String receiverChatID) async {
    // messages.add(Message(text, currentUser.chatID, receiverChatID));
    print(text);
    await socketIO.sendMessage(
      'send_message',
      json.encode({
        'receiverChatID': '605e18cf979825bdc9f6c165',
        'senderChatID': user['_id'],
        'content': text,
      }),
    );
    print("done");
    // notifyListeners();
  }

  @override
  void initState() {
    _getUser();


    

    messages = [];
    chats.add(ChatModel(
        to: "Rahil",
        from: 'Tarush',
        message: "Hey",
        seen: true,
        time: DateTime.now()));
    chats.add(ChatModel(
        to: "Rahil",
        from: 'Tarush',
        message: "This is a test",
        seen: true,
        time: DateTime.now()));
    chats.add(ChatModel(
        to: "Tarush",
        from: 'Rahil',
        message: "It works",
        seen: true,
        time: DateTime.now()));
    chats.add(ChatModel(
        to: "Rahil",
        from: 'Tarush',
        message: "Hey",
        seen: true,
        time: DateTime.now()));
    chats.add(ChatModel(
        to: "Rahil",
        from: 'Tarush',
        message: "This is a test",
        seen: true,
        time: DateTime.now()));
    chats.add(ChatModel(
        to: "Tarush",
        from: 'Rahil',
        message: "It works",
        seen: true,
        time: DateTime.now()));
    chats.add(ChatModel(
        to: "Rahil",
        from: 'Tarush',
        message: "Hey",
        seen: true,
        time: DateTime.now()));
    chats.add(ChatModel(
        to: "Rahil",
        from: 'Tarush',
        message: "This is a test",
        seen: true,
        time: DateTime.now()));
    chats.add(ChatModel(
        to: "Tarush",
        from: 'Rahil',
        message:
            "It works asdasdasd a sdasfda fasdfsds dgsdfsdfsdf sfdfsdfsefsda sdasdasdasdasda sdsdfszef",
        seen: true,
        time: DateTime.now()));
    chats.add(ChatModel(
        to: "Rahil",
        from: 'Tarush',
        message: "Hey",
        seen: false,
        time: DateTime.now()));
    //Initializing the TextEditingController and ScrollController
    // textController = TextEditingController();
    // scrollController = ScrollController();
    // socketIO = SocketIOManager().createSocketIO(
    //   Urls.baseUrl,
    //   '',
    // );
    // socketIO.init();
    // socketIO.subscribe('receive_message', (jsonData) {
    //   //Convert the JSON data received into a Map
    //   Map<String, dynamic> data = json.decode(jsonData);
    //   this.setState(() => messages.add(data['message']));
    //   scrollController.animateTo(
    //     scrollController.position.maxScrollExtent,
    //     duration: Duration(milliseconds: 600),
    //     curve: Curves.ease,
    //   );
    // });
    // // print(_scrollController.);
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   if (_scrollController.hasClients) {
    //     print("hello");
    //     _scrollController.jumpTo(0);
    //   }
    // });

    // //Connect to the socket
    // socketIO.connect();
    super.initState();

    // socketIO.sendMessage(
    //     'send_message', json.encode({'message': "connection made!!!"}));
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

  _getMinutes(minutes) {
    List min = ['00', '01', '02', '03', '04', '05', '06', '07', '08', '09'];
    if (minutes > 9) {
      return minutes.toString();
    } else {
      return min[minutes].toString();
    }
  }

  _chatBubble(chat, isMe) {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment:
              isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: [
            Container(
              // color: ColorThemes.primary,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: ColorThemes.primary,
              ),
              constraints: BoxConstraints(maxWidth: 250),
              // padding: EdgeInsets.all(8),
              child: Padding(
                padding: EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  // isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                  children: [
                    Container(
                      // padding: EdgeInsets.all(10),
                      // decoration: BoxDecoration(
                      //   borderRadius: BorderRadius.circular(10),
                      //   color: ColorThemes.primary,
                      // ),
                      // constraints: BoxConstraints(maxWidth: 250),
                      // padding: EdgeInsets.all(10),
                      // color: Colors.red,
                      // height: 30,
                      // width: 200,

                      child: Text(
                        chat.message,
                        style: TextStyle(color: Colors.white),
                        // overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: isMe
                          ? MainAxisAlignment.end
                          : MainAxisAlignment.start,
                      children: [
                        Container(
                          // color: Colors.blue,
                          child: Text(
                            chat.time.hour.toString() +
                                ":" +
                                _getMinutes(chat.time.minute),
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w300),
                          ),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Container(
                          child: Text(
                            chat.time.day.toString() +
                                "/" +
                                chat.time.month.toString() +
                                "/" +
                                chat.time.year.toString(),
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w300),
                          ),
                        ),
                        isMe
                            ? Container(
                                child: Icon(
                                  Icons.check,
                                  color: chat.seen ? Colors.blue : Colors.white,
                                ),
                              )
                            : Container(),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            // Container(
            //   child: Text(
            //     chat.time.hour.toString() +
            //         ":" +
            //         _getMinutes(chat.time.minute),
            //     style: TextStyle(color: Colors.white),
            //   ),
            // ),
            // // Row(children: [
            // Container(
            //   padding: EdgeInsets.all(10),
            //   decoration: BoxDecoration(
            //     borderRadius: BorderRadius.circular(10),
            //     color: ColorThemes.primary,
            //   ),
            //   constraints: BoxConstraints(maxWidth: 250),
            //   // padding: EdgeInsets.all(10),
            //   // color: Colors.red,
            //   // height: 30,
            //   // width: 200,

            //   child: Text(
            //     chat.message,
            //     style: TextStyle(color: Colors.white),
            //     // overflow: TextOverflow.ellipsis,
            //   ),
            // ),
            // Positioned.fill(
            //   child: Align(
            //     alignment: Alignment.bottomRight,
            //     child:

            //   ),
            // )
            // ]),
          ],
        )
        // : Row(
        //     mainAxisAlignment: MainAxisAlignment.end,
        //     children: [
        //       // Row(children: [
        //       Container(
        //         padding: EdgeInsets.all(10),
        //         decoration: BoxDecoration(
        //           borderRadius: BorderRadius.circular(10),
        //           color: ColorThemes.primary,
        //         ),
        //         constraints: BoxConstraints(maxWidth: 250),
        //         // padding: EdgeInsets.all(10),
        //         // color: Colors.red,
        //         // height: 30,
        //         // width: 200,

        //         child: Text(
        //           chat.message,
        //           style: TextStyle(color: Colors.white),
        //           // overflow: TextOverflow.ellipsis,
        //         ),
        //       ),
        //       // Positioned.fill(
        //       //   child: Align(
        //       //     alignment: Alignment.bottomRight,
        //       //     child:
        //       Container(
        //         child: Text(
        //           chat.time.hour.toString() +
        //               ":" +
        //               _getMinutes(chat.time.minute),
        //           style: TextStyle(color: Colors.white),
        //         ),
        //       ),
        //       //   ),
        //       // )
        //       // ]),
        //     ],
        //   ),
        );
  }

  _messagesContainer() {
    return GestureDetector(
      onTap: () {
        FocusHandler.unfocus(context);
      },
      child: Container(
          width: MediaQuery.of(context).size.width,
          // color: Colors.blue,
          child: ListView.builder(
            // reverse: true,
            shrinkWrap: true,
            controller: _scrollController,
            itemCount: chats.length,
            itemBuilder: (context, index) {
              return _chatBubble(
                  chats[index], chats[index].from == user['name']);
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

  _sendMessage(message) {
    socketIO.sendMessage(
        'single_chat_message',
        json.encode({
            "to": "Rahil",
            "from": "Tarush",
            "message": message,
            "seen": false,
            "time": DateTime.now().toString()}));
  }

  _inputMessage() {
    return Container(
      // color: Colors.red,
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Container(
              child: Icon(
                Icons.add,
                color: Colors.white,
              ),
            ),
          ),
          Expanded(
            flex: 10,
            child: TextFormField(
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Enter Message',
                hintStyle: TextStyle(color: Colors.white),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.0),
                  borderSide: BorderSide(
                    color: Colors.white,
                    width: 2.0,
                  ),
                ),
                border: new OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
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
              controller: messageController,
              // validator: (val) => val.isEmpty ? 'Enter a valid Email' : null,
              // controller: emailController,
            ),
          ),
          Expanded(
              flex: 2,
              child: Container(
                child: IconButton(
                  onPressed: () {
                    sendMessage(messageController.text, "randomId");
                  },
                  icon: Icon(Icons.send),
                  // icon: Icons.send,
                  color: Colors.white,
                ),
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
      // appBar: Container(),
      backgroundColor: Colors.black,
      appBar: ChatAppBar(
        height: MediaQuery.of(context).size.height * 0.7,

      ),
      // AppBar(
      //   title: Text("Chat Screen"),
      // ),
      body: SingleChildScrollView(
        // controller: _scrollController,
        child: _isLoading
            ? CircularProgressIndicator()
            : ConstrainedBox(
                constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height - 80),
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
                          child: Container(
                            // color: Colors.grey[800],
                            // padding: EdgeInsets.only(top:5),
                            child: _inputMessage(),
                          ),
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
