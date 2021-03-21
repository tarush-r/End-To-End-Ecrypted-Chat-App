import 'package:chatapp_client/models/chat_contact_model.dart';
import 'package:chatapp_client/screens/chat_screen.dart';
import 'package:chatapp_client/screens/login_screen.dart';
import 'package:chatapp_client/utlis/color_themes.dart';
import 'package:flutter/material.dart';
import '../helpers/sharedpreferences_helper.dart';
import '../helpers/contacts_helper.dart';
import 'contacts_screen.dart';
import 'package:socket_io_client/socket_io_client.dart' as client;
import '../utlis/loading_indicator.dart';

class ChatsListScreen extends StatefulWidget {
  static String routeName = '/chatslist';

  @override
  _ChatsListScreenState createState() => _ChatsListScreenState();
}

class _ChatsListScreenState extends State<ChatsListScreen> {
  List<ChatContactModel> chatContacts = [];
  // final List<Widget> selectedScreen = []

  @override
  void initState() {
    super.initState();
    //api call
    chatContacts.add(ChatContactModel(
        name: "Rahil",
        number: "8293627343",
        recentMessage: "Hey this works!!",
        notificationCount: 5,
        recentMessageTime: '11:00 pm'));
    chatContacts.add(ChatContactModel(
        name: "Sakshi",
        number: "2343534343",
        recentMessage:
            "Did you work on sockets?. We have to show our work on Monday. Please start working on it fast",
        notificationCount: 0,
        recentMessageTime: '9:30 am'));
    chatContacts.add(ChatContactModel(
        name: "Kunal",
        number: "2313627343",
        recentMessage: "Valorant khlega?",
        notificationCount: 1,
        recentMessageTime: '11:00 pm'));
    chatContacts.add(ChatContactModel(
        name: "Jigyassa",
        number: "5433454343",
        recentMessage: "Whats the syllabus for tomorrow?",
        notificationCount: 0,
        recentMessageTime: '9:30 am'));
    chatContacts.add(ChatContactModel(
        name: "Aaditya",
        number: "8293627343",
        recentMessage: "Naruto dekh!!!!",
        notificationCount: 1,
        recentMessageTime: '11:00 pm'));
    chatContacts.add(ChatContactModel(
        name: "Anina",
        number: "9143534343",
        recentMessage: "Kitna padha?",
        notificationCount: 1,
        recentMessageTime: '9:30 am'));
  }

  _chatContactContainer(chatContact) {
    return RawMaterialButton(
      onPressed: () {
        Navigator.pushNamed(context, ChatScreen.routeName);
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Dismissible(
          key: UniqueKey(),
          direction: DismissDirection.endToStart,
          background: Container(
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
                          Text(
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
                          chatContact.recentMessageTime.toString(),
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
          RawMaterialButton(
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
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
                _topBar(),
                Container(
                  height: MediaQuery.of(context).size.height * 0.7,
                  child: ListView.builder(
                    itemCount: chatContacts.length,
                    itemBuilder: (context, index) {
                      return _chatContactContainer(chatContacts[index]);
                    },
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
