import 'package:chatapp_client/api/chat_api.dart';
import 'package:chatapp_client/api/settings_api.dart';
import 'package:chatapp_client/helpers/sharedpreferences_helper.dart';
import 'package:chatapp_client/models/chat_contact_model.dart';
import 'package:chatapp_client/models/chat_model.dart';
import 'package:chatapp_client/providers/chats_provider.dart';
import 'package:chatapp_client/providers/user_provider.dart';
import 'package:chatapp_client/utils/color_themes.dart';
import 'package:chatapp_client/utils/context_util.dart';
import 'package:chatapp_client/utils/focus_handler.dart';
import 'package:chatapp_client/utils/urls.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import "package:flutter/material.dart";
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import '../widgets/chat_screen_appbar.dart';
import 'dart:convert';
import 'package:emoji_picker/emoji_picker.dart';
import 'package:flutter_socket_io/flutter_socket_io.dart';
import 'package:flutter_socket_io/socket_io_manager.dart';
import '../widgets/chat_bubble.dart';
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

  String selectedUserId;
  var selectedUser;
  SocketIO socketIO;
  bool _isLoading;
  TextEditingController messageController = new TextEditingController();
  final _scrollController = ScrollController();
  bool _isInit = true;
  List<String> messages;
  double height, width;
  TextEditingController textController;
  ScrollController scrollController;
  List<ChatModel> chats = [];
  String token;

  var user;
  void _getUser() async {
    _isLoading = true;
    user = await SharedPreferencesHelper.getUser();
    print('&&&&&&&&&');
    print(user);
    print('&&&&&&&&&');
    token = await SharedPreferencesHelper.getToken();

    print('&&&&&&&&&');
    print(token);
    print('&&&&&&&&&');
    ChatApi.setSeenTrue(token, selectedUserId);
    ContextUtil.selectedUserIds.add(selectedUserId);
    _isLoading = false;
    Provider.of<ChatsProvider>(context, listen: false)
        .readMessage(user['_id'], selectedUserId);
    Provider.of<ChatsProvider>(context, listen: false)
        .setSeenTrue(selectedUserId, user['_id']);
    // setState(() {
    //   _isLoading = false;
    // });
    print(user['profile_pic']);
  }

  void sendMessage(String message, String receiverId, String senderId) async {
    // messages.add(Message(text, currentUser.chatID, receiverChatID));
    print(message);
    await socketIO.sendMessage(
      'send_message',
      json.encode({
        'receiverId': receiverId,
        'senderId': senderId,
        'message': message,
      }),
    );
    print("done");
    // notifyListeners();
  }

  _pickImage() async {
    print("HEY");
    final _storage = FirebaseStorage.instance;

    final _picker = ImagePicker();
    PickedFile image;

    var permissionStatus;
    await Permission.photos.request();
    permissionStatus = await Permission.photos.status;
    // if(permissionStatus.isGranted) {
    //   print("permission granted");
    // }
    image = await _picker.getImage(source: ImageSource.gallery);
    var file = File(image.path);
    String imageName = image.path.split('/')[image.path.split('/').length - 1];

    if (image != null) {
      var snapshot = await _storage
          .ref()
          .child('chatPhotos/$imageName')
          .putFile(file)
          .whenComplete(() {
        // print(snapshot);
      });
      String url = await snapshot.ref.getDownloadURL();
      // var res = await SettingsApi.updateProfilePhoto(url, token);
      print("!!!!!!!!!!!!!!");
      // print(json.decode(res)["user"]);
      // setState(() {
      //   SharedPreferencesHelper.persistOnLogin(
      //       json.encode(json.decode(res.body)['user']), json.encode(token));
      //   _getUser();
      //   // Navigator.of(context).pop();
      // });
      print(url);
      showDialog(
          context: context,
          builder: (BuildContext ctx) {
            return AlertDialog(
              // height: MediaQuery.of(context).size.width*0.8,
              title: Text(imageName),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    Image.network(url),
                    SizedBox(
                      height: 10,
                    ),
                    GestureDetector(
                      onTap: () {
                        print(url);
                        sendMessage(url, selectedUserId,
                            user['_id']);
                        Provider.of<ChatsProvider>(context, listen: false)
                            .addChat(url, user, selectedUser,
                                false);
                        messageController.clear();
                        _scrollToBottom();
                        Navigator.of(ctx).pop();
                      },
                      child: Container(
                        height: 40,
                        width: 40,
                        // decoration: BoxDecoration(
                        //   color: ColorThemes.primary,
                        //   shape: BoxShape.circle,
                        // ),
                        child: Icon(Icons.send),
                      ),
                    ),
                  ],
                ),
              ),
            );
          });
    } else {
      print("no image selected");
    }
  }

  _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        print("hello");
        _scrollController.jumpTo(
          _scrollController.position.maxScrollExtent,
          // duration: Duration(milliseconds: 600),
          // curve: Curves.ease,
        );
        // _scrollController.jumpTo(2000);
      }
    });
  }

  @override
  void initState() {
    _getUser();
    Firebase.initializeApp();
    messages = [];
    // chats.add(ChatModel(
    //     to: "Rahil",
    //     from: 'Tarush',
    //     message: "Hey",
    //     seen: true,
    //     time: DateTime.now()));
    // chats.add(ChatModel(
    //     to: "Rahil",
    //     from: 'Tarush',
    //     message: "This is a test",
    //     seen: true,
    //     time: DateTime.now()));
    // chats.add(ChatModel(
    //     to: "Tarush",
    //     from: 'Rahil',
    //     message: "It works",
    //     seen: true,
    //     time: DateTime.now()));
    // chats.add(ChatModel(
    //     to: "Rahil",
    //     from: 'Tarush',
    //     message: "Hey",
    //     seen: true,
    //     time: DateTime.now()));
    // chats.add(ChatModel(
    //     to: "Rahil",
    //     from: 'Tarush',
    //     message: "This is a test",
    //     seen: true,
    //     time: DateTime.now()));
    // chats.add(ChatModel(
    //     to: "Tarush",
    //     from: 'Rahil',
    //     message: "It works",
    //     seen: true,
    //     time: DateTime.now()));
    // chats.add(ChatModel(
    //     to: "Rahil",
    //     from: 'Tarush',
    //     message: "Hey",
    //     seen: true,
    //     time: DateTime.now()));
    // chats.add(ChatModel(
    //     to: "Rahil",
    //     from: 'Tarush',
    //     message: "This is a test",
    //     seen: true,
    //     time: DateTime.now()));
    // chats.add(ChatModel(
    //     to: "Tarush",
    //     from: 'Rahil',
    //     message:
    //         "It works asdasdasd a sdasfda fasdfsds dgsdfsdfsdf sfdfsdfsefsda sdasdasdasdasda sdsdfszef",
    //     seen: true,
    //     time: DateTime.now()));
    // chats.add(ChatModel(
    //     to: "Rahil",
    //     from: 'Tarush',
    //     message: "Hey",
    //     seen: false,
    //     time: DateTime.now()));
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
    _scrollToBottom();
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   if (_scrollController.hasClients) {
    //     print("hello");
    //     _scrollToBottom();
    //     // _scrollController.jumpTo(
    //     //   _scrollController.position.maxScrollExtent,
    //     //   // duration: Duration(milliseconds: 600),
    //     //   // curve: Curves.ease,
    //     // );
    //     // _scrollController.jumpTo(2000);
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

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    if (_isInit) {
      // _getChats();
      print("ARGUMENTS HERE");
      Map arguments = ModalRoute.of(context).settings.arguments as Map;
      selectedUserId = arguments['id'];
      print(selectedUserId);

      socketIO = Provider.of<ChatsProvider>(context, listen: false).socketIO;
      Provider.of<ChatsProvider>(context).initSelectedUserChats(selectedUserId);
      // Provider.of<UserProvider>(context).initSelectedUser(selectedUserId);
      user = Provider.of<UserProvider>(context).user;
      print("PRINTING USER");
      print(user['_id']);
      // socketIO = SocketIOManager()
      //     .createSocketIO(Urls.baseUrl, '/', query: 'senderId=${user['_id']}');
      // socketIO.init();

      // socketIO.subscribe('receive_message', (jsonData) {
      //   Map<String, dynamic> data = json.decode(jsonData);
      //   print("RECEIVERRRRRRRRRRRRRRRRRRRRRRRRR");
      //   print(data);
      //   // messages.add(Message(
      //   //     data['content'], data['senderChatID'], data['receiverChatID']));
      //   // notifyListeners();
      // });
      // print("SOCKET CONNECTED@@@@");
      // socketIO.connect();
    }
    _isInit = false;
    super.didChangeDependencies();
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
              return ChatBubble(
                isMe: chats[index].from == user['_id'],
                chat: chats[index],
              );
              // _chatBubble(
              //     chats[index], chats[index].from == user['_id']);
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
                child: Row(children: <Widget>[
                  IconButton(
                    // iconSize: 18.0,
                    icon: Icon(Icons.add),
                    onPressed: () {
                      _pickImage();
                    },
                    color: Colors.white,
                  ),
                  // new IconButton(
                  //   iconSize: 18.0,
                  //   icon: new Icon(Icons.attach_file),
                  //   onPressed: () {
                  //     _pickImage();
                  //   },
                  //   color: Colors.blueGrey,
                  // ),
                ]),
              )),
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
                    if (messageController.text.isEmpty) {
                      return;
                    }
                    print(selectedUserId);
                    sendMessage(
                        messageController.text, selectedUserId, user['_id']);
                    Provider.of<ChatsProvider>(context, listen: false).addChat(
                        messageController.text, user, selectedUser, false);
                    messageController.clear();
                    _scrollToBottom();
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
    ContextUtil.buildContext.add(context);
    chats = Provider.of<ChatsProvider>(context).getSelectedChats;
    selectedUser = Provider.of<UserProvider>(context).selectedUser;
    // final store = Provider.of<MessageStore>(context, listen: false);
    return WillPopScope(
      onWillPop: () async {
        ContextUtil.buildContext.add(null);
        ContextUtil.selectedUserIds.add(null);
        print(ContextUtil.buildContext.last);
        return true;
      },
      child: Scaffold(
        // appBar: Container(),
        backgroundColor: Colors.black,
        appBar: ChatAppBar(
          height: MediaQuery.of(context).size.height * 0.7,
        ),
        body: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height - 80),
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Container(
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
