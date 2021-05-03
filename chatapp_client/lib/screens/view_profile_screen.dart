import 'dart:io';

import 'package:chatapp_client/api/chat_api.dart';
import 'package:chatapp_client/api/settings_api.dart';
import 'package:chatapp_client/providers/user_provider.dart';
import 'package:chatapp_client/widgets/heading_widget.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import '../helpers/sharedpreferences_helper.dart';
import 'dart:convert';

class ViewProfileScreen extends StatefulWidget {
  static final String routeName = '/view_profile';
  @override
  _ViewProfileScreenState createState() => _ViewProfileScreenState();
}

class _ViewProfileScreenState extends State<ViewProfileScreen> {
  String name;
  String pic;
  String number;
  var res;
  bool _isLoading = true;
  var selectedUser;
  var token;

  void _getUser() async {
    _isLoading = true;
    token = await SharedPreferencesHelper.getToken();
    selectedUser =
        Provider.of<UserProvider>(context, listen: false).selectedUser;
    print("Selecteddddddddddddd");
    print(selectedUser.id);
    print(token);
    var response = await ChatApi.getSelectedUserProfile(
      token,
      selectedUser.id,
    );
    print("CCCCCCCCCCCCCC");
    res = response['user'];
    print(res['profile_pic']);
    pic = res['profile_pic'];
    name = res['name'];
    number = res['number'];

    setState(() {
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _getUser();
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading == true
        ? Center(child: CircularProgressIndicator())
        : SafeArea(
            child: Scaffold(
              body: Padding(
                padding: EdgeInsets.all(10),
                child: Container(
                  width: double.infinity,
                  // color: Colors.blue,
                  child: Column(
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
                          // HeadingWidget("Profile"),
                          Text(
                            name,
                            style: TextStyle(
                              fontSize: 30,
                              fontFamily: 'Poiret',
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Stack(
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 400.0,
                                color: Colors.grey[200],
                                child: pic != null
                                    ? Container(
                                        height: 200.0,
                                        width: 200.0,
                                        child: Image.network(pic),
                                      )
                                    : Container(
                                        child: Column(children: <Widget>[
                                          Text(
                                            name,
                                            style: TextStyle(
                                              fontSize: 40,
                                              fontFamily: 'Poiret',
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ]),
                                        color: Colors.grey,
                                      ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Expanded(
                          flex: 1,
                          child: ListView(
                            children: [
                              Column(
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      // color: Colors.grey[200]
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              "About and phone number",
                                              style: TextStyle(
                                                fontSize: 15,
                                                color: Colors.red[900],
                                              ),
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Column(
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Colors.grey[200]),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              res['status'],
                                              style: TextStyle(fontSize: 20),
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Column(
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Colors.grey[200]),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Icon(Icons.phone),
                                            SizedBox(
                                              width: 15,
                                            ),
                                            Text(
                                              "9382934057",
                                              style: TextStyle(fontSize: 20),
                                            )
                                          ],
                                        ),
                                        // InkWell(child: Icon(Icons.edit))
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Column(
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Colors.grey[200]),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Icon(Icons.mail),
                                            SizedBox(
                                              width: 15,
                                            ),
                                            Text(
                                              // user['email'],
                                              "test@email.com",
                                              style: TextStyle(fontSize: 20),
                                            )
                                          ],
                                        ),
                                        // InkWell(child: Icon(Icons.edit))
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ))
                    ],
                  ),

                  // child: Column(
                  //   // mainAxisAlignment: MainAxisAlignment.center,
                  //   crossAxisAlignment: CrossAxisAlignment.start,
                  //   children: [
                  //     HeadingWidget("Profile"),
                  //     Column(
                  //       crossAxisAlignment: CrossAxisAlignment.center,
                  //       children: [
                  //         CircleAvatar(
                  //           radius: 30.0,
                  //           backgroundImage: NetworkImage(user['profile_pic']),
                  //           backgroundColor: Colors.transparent,
                  //         )
                  //       ],
                  //     ),
                  //   ],
                  // ),
                ),
              ),
            ),
          );
  }
}
