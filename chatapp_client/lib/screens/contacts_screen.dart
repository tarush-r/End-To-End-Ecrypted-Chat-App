import 'dart:convert';

import 'package:chatapp_client/api/contacts_api.dart';
import 'package:chatapp_client/helpers/sharedpreferences_helper.dart';
import 'package:chatapp_client/models/contact_model.dart';
import 'package:chatapp_client/providers/user_provider.dart';
import 'package:chatapp_client/widgets/heading_widget.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../helpers/contacts_helper.dart';
import 'chat_screen.dart';

class ContactsScreen extends StatefulWidget {
  static String routeName = '/contacts';

  @override
  _ContactsScreenState createState() => _ContactsScreenState();
}

class _ContactsScreenState extends State<ContactsScreen> {
  String token;

  List<ContactModel> contacts = [];
  bool _isLoading = true;
  @override
  void initState() {
    _getContacts();
    // print();
    super.initState();
  }

  _getContacts() async {
    token = await SharedPreferencesHelper.getToken();
    var res = await ContactsHelper.getContacts(token);
    print(res);
    res.forEach((element) {
      // print(element is Map);
      contacts.add(ContactModel.fromJson(element));
    });
    //print(contacts[0].name);
    setState(() {
      _isLoading = false;
    });
  }

  _contactContainer(ContactModel contact) {
    return Padding(
      padding: const EdgeInsets.all(5),
      child: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: Colors.grey[200], borderRadius: BorderRadius.circular(10)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.green,
                  backgroundImage: NetworkImage(contact.profilePic),
                  radius: 20,
                ),
                SizedBox(
                  width: 10,
                ),
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        contact.name,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                      Text(contact.number)
                    ],
                  ),
                ),
              ],
            ),
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    print(contact.id);
                    Provider.of<UserProvider>(context, listen: false)
                        .initSelectedUser(contact);
                    Navigator.pushNamed(
                      context,
                      ChatScreen.routeName,
                      arguments: <String, String>{
                        'id': contact.id,
                      },
                    );
                  },
                  child: Icon(Icons.add),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: EdgeInsets.all(10),
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Container(
                        padding: EdgeInsets.only(right: 20),
                        child: Icon(Icons.arrow_back),
                      ),
                    ),
                    // Container(
                    //   decoration: BoxDecoration(
                    //     borderRadius: BorderRadius.circular(50),
                    //     // color: Colors.blue
                    //   ),
                    //   width: 40,
                    //   child: MaterialButton(
                    //       shape: CircleBorder(),
                    //       onPressed: () {
                    //         Navigator.of(context).pop();
                    //       },
                    //       child: Center(child: Icon(Icons.arrow_back))),
                    // ),
                    // SizedBox(
                    //   width: 10,
                    // ),
                    HeadingWidget("Contacts")
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                _isLoading
                    ? Center(child: CircularProgressIndicator())
                    : Container(
                        height: MediaQuery.of(context).size.height * 0.8,
                        child: ListView.builder(
                          itemCount: contacts.length,
                          itemBuilder: (BuildContext context, int index) {
                            return _contactContainer(contacts[index]);
                          },
                        )
                        // FutureBuilder(
                        //   future: ContactsHelper.getContacts(),
                        //   builder: (BuildContext context, AsyncSnapshot snapshot) {
                        //     if (!snapshot.hasData) {
                        //       return Text('Loading');
                        //     }
                        //     return ListView.builder(
                        //       itemCount: snapshot.data.length,
                        // itemBuilder: (BuildContext context, int index) {
                        //   return _contactContainer(snapshot.data[index]);
                        // },
                        //     );
                        //   },
                        // ),
                        )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
