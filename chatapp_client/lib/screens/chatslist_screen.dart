import 'package:chatapp_client/api/chat_api.dart';
import 'package:chatapp_client/api/settings_api.dart';
import 'package:chatapp_client/helpers/database_helper.dart';
import 'package:chatapp_client/models/chat_contact_model.dart';
import 'package:chatapp_client/models/chat_model.dart';
import 'package:chatapp_client/providers/chats_provider.dart';
import 'package:chatapp_client/providers/user_provider.dart';
import 'package:chatapp_client/screens/chat_screen.dart';
import 'package:chatapp_client/screens/login_screen.dart';
import 'package:chatapp_client/screens/schedule_screen.dart';
import 'package:chatapp_client/utils/color_themes.dart';
import 'package:chatapp_client/utils/context_util.dart';
import 'package:chatapp_client/utils/focus_handler.dart';
import 'package:chatapp_client/utils/show_message.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../helpers/sharedpreferences_helper.dart';
import '../helpers/contacts_helper.dart';
import 'contacts_screen.dart';
import 'package:socket_io_client/socket_io_client.dart' as client;
import '../utils/loading_indicator.dart';

class ChatsListScreen extends StatefulWidget {
  static String routeName = '/chatslist';

  @override
  _ChatsListScreenState createState() => _ChatsListScreenState();
}

class _ChatsListScreenState extends State<ChatsListScreen> {
  // List done = [];
  // Map unread = {};
  TextEditingController searchController = new TextEditingController();
  String searchContact = "";
  List<ChatContactModel> chatContacts = [];
  // final List<Widget> selectedScreen = []
  String token;
  bool _isInit = true;
  var databaseHelper;

  _getChats() async {
    Future.delayed(Duration.zero)
        .then((value) => {Provider.of<ChatsProvider>(context).getAllChats()});
    // chatContacts = await  Provider.of<ChatsProvider>(context).allChats;
    print(chatContacts);
    //   token = await SharedPreferencesHelper.getToken();
    //   print("TOKEN@@@@@@@@@@@@@@@@@@@@@@@@@@@: "+token);
    //   var response = await ChatApi.getAllChats(token);
    //  // print(response['chats'].length);
    //   var user = await SharedPreferencesHelper.getUser();
    //   for(int i =0; i<response['chats'].length ;i++){
    //     // print(user);
    //     if(response['chats'][i]['from']['name']==user['name']){
    //       if(done.contains(response['chats'][i]['to']['_id'])){
    //         print('if if');
    //         // if(response['chats'][i]['seen']==false){
    //         //   unread[response['chats'][i]['to']['_id']] = unread[response['chats'][i]['to']['_id']] +1;
    //         // }
    //         continue;
    //       }
    //       else{
    //         print('if else');
    //         done.add(response['chats'][i]['to']['_id']);
    //         print(response['chats'][i]['sentAt']);
    //         chatContacts.add(ChatContactModel(name: response['chats'][i]['to']['name'], recentMessage: response['chats'][i]['message'], notificationCount: 0, recentMessageTime: response['chats'][i]['sentAt'], publicKey: response['chats'][i]['to']['publicKey'], seen: response['chats'][i]['seen'], email: response['chats'][i]['to']['email'], profilePic: response['chats'][i]['to']['profile_pic']));
    //         // if(response['chats'][i]['seen']==false){
    //         //   unread[response['chats'][i]['to']['_id']] = 1;
    //         // }
    //         // response['chats'][i].firstWhere((chat)=>chat['to']['id']==);
    //       }
    //     }
    //     else{
    //       if(done.contains(response['chats'][i]['from']['_id'])){
    //         print('else if '+i.toString());
    //         if(response['chats'][i]['seen']==false){
    //           unread[response['chats'][i]['from']['_id']] = unread[response['chats'][i]['from']['_id']] +1;
    //         }
    //         continue;
    //       }
    //       else{
    //         // print(response['chats'][i]['from']['_id']);
    //         done.add(response['chats'][i]['from']['_id']);
    //         print(response['chats'][i]['sentAt']);
    //         if(response['chats'][i]['seen']==false){
    //           unread[response['chats'][i]['from']['_id']] = 1;
    //         }
    //         chatContacts.add(ChatContactModel(name: response['chats'][i]['from']['name'], recentMessage: response['chats'][i]['message'], notificationCount: 0, recentMessageTime: response['chats'][i]['sentAt'], publicKey: response['chats'][i]['from']['publicKey'], seen: response['chats'][i]['seen'], email: response['chats'][i]['from']['email'], profilePic: response['chats'][i]['from']['profile_pic']));
    //         // response['chats'][i].firstWhere((chat)=>chat['to']['id']==);
    //       }
    //     }

    //   }
    //   print(done);
    //   print(unread);
    //   for(int i =0;i<chatContacts.length;i++){
    //     print(i);
    //     print(chatContacts[i].profilePic);
    //   }
    //   for(int i =0;i<done.length;i++){
    //     if(unread[done[i]]==null){
    //       print('returned');
    //       continue;
    //     }
    //     chatContacts[i].notificationCount=unread[done[i]];
    //   }
    setState(() {});
    // chatContacts.add(ChatContactModel());
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    if (_isInit) {
      // _getChats();
      Provider.of<ChatsProvider>(context).getAllChats();
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  void initState() {
    ContextUtil.buildContext.add(null);
    databaseHelper = DatabaseHelper();
    super.initState();
  }

  _getMinutes(minutes) {
    List min = ['00', '01', '02', '03', '04', '05', '06', '07', '08', '09'];
    if (minutes > 9) {
      return minutes.toString();
    } else {
      return min[minutes].toString();
    }
  }

  _chatContactContainer(ChatContactModel chatContact) {
    if (!chatContact.name
        .toLowerCase()
        .startsWith(searchContact.toLowerCase())) {
      return Container();
    }
    return RawMaterialButton(
      onPressed: () async {
        print(chatContact.id);
        Provider.of<UserProvider>(context, listen: false)
            .initSelectedUser(chatContact);
        Navigator.pushNamed(
          context,
          ChatScreen.routeName,
          arguments: <String, String>{
            'id': chatContact.id,
          },
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Dismissible(
          key: UniqueKey(),
          // direction: DismissDirection.endToStart,
          confirmDismiss: (direction) {

            if (DismissDirection.startToEnd == direction) {
              ShowMessage.show("Schedule a message",
                  "Schedule a message for ${chatContact.name}", () {
                Provider.of<UserProvider>(context, listen: false)
                    .initSelectedUser(chatContact);

                Navigator.pushNamed(
                  context,
                  ScheduleScreen.routeName,
                  arguments: <String, String>{
                    'id': chatContact.id,
                  },
                );
              }, context);
              return Future.delayed(Duration.zero, () {
                return false;
              });
            } else {
              ShowMessage.show(
                  "Delete chats", "Delete chhats with ${chatContact.name}", () async{
                Provider.of<UserProvider>(context, listen: false)
                    .initSelectedUser(chatContact);
                token = await SharedPreferencesHelper.getToken();
                ChatApi.deleteSelectedUserChat(
                    chatContact.id,
                    token
                    );
              }, context);
              return Future.delayed(Duration.zero, () {
                return false;
              });
            }
          },
          secondaryBackground: Container(
            padding: EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Icon(
                  Icons.delete,
                  color: Colors.white,
                ),
              ],
            ),
            decoration: BoxDecoration(
                color: Colors.red, borderRadius: BorderRadius.circular(20)),
          ),
          background: Container(
            padding: EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(
                  Icons.alarm,
                  color: Colors.white,
                ),
              ],
            ),
            decoration: BoxDecoration(
                color: Colors.blue, borderRadius: BorderRadius.circular(20)),
          ),
          child: Container(
            // decoration: ShapeDecoration(
            //   color: Colors.grey,
            //   shape: RoundedRectangleBorder(
            //     borderRadius: BorderRadius.only(
            //         topLeft: Radius.circular(20),
            //         topRight: Radius.circular(20.0)),
            //   ),
            // ),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(20),
            ),
            padding: EdgeInsets.all(10),
            height: 80,
            width: double.infinity,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      backgroundImage: NetworkImage(chatContact.profilePic),
                      backgroundColor: Colors.green,
                      radius: 30,
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.5,
                      height: 100,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            chatContact.name,
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                          chatContact.recentMessage
                                  .contains('firebasestorage.googleapis.com')
                              ? Text(
                                  "Photo",
                                  overflow: TextOverflow.ellipsis,
                                )
                              : chatContact.recentMessage
                                      .contains('maps.google.com')
                                  ? Row(
                                      children: [
                                        Icon(
                                          Icons.location_on,
                                        ),
                                        Text(
                                          'Location shared',
                                          style: TextStyle(
                                              // color: Colors.white
                                              ),
                                        )
                                      ],
                                    )
                                  : Text(
                                      chatContact.recentMessage,
                                      overflow: TextOverflow.ellipsis,
                                    )
                        ],
                      ),
                    )
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      child: Center(
                        child: Text(
                          DateTime.parse(chatContact.recentMessageTime)
                                  .hour
                                  .toString() +
                              ":" +
                              _getMinutes(
                                  DateTime.parse(chatContact.recentMessageTime)
                                      .minute),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: ColorThemes.secondary, fontSize: 12),
                        ),
                      ),
                    ),
                    chatContact.notificationCount != 0
                        ? Container(
                            height: 30,
                            width: 30,
                            // color: Colors.red,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: ColorThemes.primary),
                            child: Center(
                              child: Text(
                                chatContact.notificationCount.toString(),
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          )
                        : Container(),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  _searchBar() {
    return Padding(
      padding: const EdgeInsets.only(left: 10),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.7,
        height: 50,
        // color: Colors.red,
        // width: double.infinity,
        child: TextField(
          controller: searchController,
          onChanged: (value) {
            searchContact = value;
            setState(() {});
            // print(searchController.text);
          },
          textInputAction: TextInputAction.search,
          decoration: new InputDecoration(
              border: new OutlineInputBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(30.0),
                ),
              ),
              filled: true,
              hintStyle: new TextStyle(color: Colors.grey[800]),
              hintText: "Search",
              fillColor: Colors.white70,
              prefixIcon: Icon(Icons.search)),
        ),
      ),
    );
  }

  _topBar() {
    return Container(
      height: 60,
      width: double.infinity,
      // color: Colors.red,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _searchBar(),
          GestureDetector(
            onTap: () {
              FocusHandler.unfocus(context);
            },
            child: RawMaterialButton(
              shape: CircleBorder(),
              child: Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle, color: Colors.grey[200]),
                  child: Icon(Icons.contacts)),
              onPressed: () {
                Navigator.pushNamed(context, ContactsScreen.routeName);
              },
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // chatContacts = Provider.of<ChatsProvider>(context).allChats;
    // print("PRINTING CHAT CONTSACTS");
    // print(chatContacts);
    return Scaffold(
      // appBar: AppBar(
      //   actions: [
      //     RaisedButton(onPressed: () {
      //       SharedPreferencesHelper.logout();

      //       Navigator.pushReplacementNamed(context, LoginScreen.routeName);
      //     })
      //   ],
      // ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(10),
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: [
                // GestureDetector(
                //   onTap: () {
                //     print("DaTABASE CLEARED");
                //     databaseHelper.dropTable();
                //     // DatabaseHelper.instance.dropTable();
                //   },
                //   child: Container(
                //     color: Colors.blue,
                //     width: 500,
                //     height: 50,
                //     child: Text("Clear Database"),
                //   ),
                // ),
                // GestureDetector(
                //   onTap: () {
                //     print("PRINTING DATABASE");
                //     databaseHelper.getChats();
                //     // DatabaseHelper.instance.dropTable();
                //   },
                //   child: Container(
                //     color: Colors.blue,
                //     width: 500,
                //     height: 50,
                //     child: Text("PRINT DATABASE"),
                //   ),
                // ),
                _topBar(),
                GestureDetector(
                  onTap: () {
                    FocusHandler.unfocus(context);
                  },
                  child: Consumer<ChatsProvider>(
                    builder: (ctx, chatsProvider, child) => Container(
                      height: MediaQuery.of(context).size.height * 0.7,
                      child: ListView.builder(
                        itemCount: chatsProvider.allChatContacts.length,
                        itemBuilder: (context, index) {
                          return _chatContactContainer(
                              chatsProvider.allChatContacts[index]);
                        },
                      ),
                    ),
                    // child:
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      // Container(
      //   child: RaisedButton(onPressed: () {
      //     Navigator.pushNamed(context, ChatScreen.routeName);
      //   })
      // ),

      // floatingActionButton: FloatingActionButton(
      //   child: Icon(Icons.contacts),
      //   onPressed: () {
      //     Navigator.pushNamed(context, ContactsScreen.routeName);
      //     // ContactsHelper.getContacts();
      //   },
      // ),
    );
  }
}
