import 'dart:io';

import 'package:chatapp_client/api/settings_api.dart';
import 'package:chatapp_client/widgets/heading_widget.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import '../helpers/sharedpreferences_helper.dart';
import 'dart:convert';

class ProfileScreen extends StatefulWidget {
  static final String routeName = '/profile';

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  var user;
  String token;
  bool _isLoading = true;
  TextEditingController statusController = new TextEditingController();

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

    setState(() {
      _isLoading = false;
    });
    print(user['profile_pic']);
  }

  @override
  void initState() {
    super.initState();
    Firebase.initializeApp();
    _getUser();
  }

  _showUpdateStatusDialog() {
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              title: Text("Edit Status"),
              content: Container(
                height: 100,
                child: Column(
                  children: [
                    TextFormField(
                      decoration: InputDecoration(hintText: "Status"),
                      controller: statusController,
                    ),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: Text('Close'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: Text('Yes'),
                  onPressed: () async {
                    var res = await SettingsApi.updateStatus(
                        statusController.text, token);
                    print("!!!!!!!!!!!!!!");
                    // print(json.decode(res)["user"]);
                    setState(() {
                      SharedPreferencesHelper.persistOnLogin(
                          json.encode(json.decode(res.body)['user']),
                          json.encode(token));
                      _getUser();
                      Navigator.of(context).pop();
                    });
                  },
                )
              ],
            ));
  }

  _pickImage() async {
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
          .child('profilePhotos/${imageName}')
          .putFile(file)
          .whenComplete(() {
        // print(snapshot);
      });
      String url = await snapshot.ref.getDownloadURL();
      var res = await SettingsApi.updateProfilePhoto(url, token);
      print("!!!!!!!!!!!!!!");
      // print(json.decode(res)["user"]);
      setState(() {
        SharedPreferencesHelper.persistOnLogin(
            json.encode(json.decode(res.body)['user']), json.encode(token));
        _getUser();
        // Navigator.of(context).pop();
      });
      print(url);
    } else {
      print("no image selected");
    }
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading == true
        ? CircularProgressIndicator()
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
                          HeadingWidget("Profile"),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Stack(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              user["profile_pic"] != null
                                  ? CircleAvatar(
                                      radius: 50.0,
                                      // child: Text(
                                      //   user['name'][0],
                                      //   style: TextStyle(
                                      //     fontSize: 40,
                                      //     fontFamily: 'Poiret',
                                      //     fontWeight: FontWeight.bold,
                                      //     color: Colors.white,
                                      //   ),
                                      // ),
                                      backgroundImage:
                                          NetworkImage(user['profile_pic']),
                                      backgroundColor: Colors.grey,
                                    )
                                  : CircleAvatar(
                                      radius: 50.0,
                                      child: Text(
                                        user['name'][0],
                                        style: TextStyle(
                                          fontSize: 40,
                                          fontFamily: 'Poiret',
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                      // backgroundImage: NetworkImage(user['profile_pic']),
                                      backgroundColor: Colors.grey,
                                    ),
                            ],
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                top: MediaQuery.of(context).size.height * 0.11,
                                left: MediaQuery.of(context).size.width * 0.57),
                            child: InkWell(
                              onTap: () {
                                _pickImage();
                              },
                              child: Icon(Icons.edit),
                            ),
                          )
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
                                            Icon(Icons.face),
                                            SizedBox(
                                              width: 15,
                                            ),
                                            Text(
                                              user['name'],
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
                                            Icon(Icons.info_rounded),
                                            SizedBox(
                                              width: 15,
                                            ),
                                            Text(
                                              user['status'],
                                              style: TextStyle(fontSize: 20),
                                            )
                                          ],
                                        ),
                                        InkWell(
                                            onTap: () {
                                              _showUpdateStatusDialog();
                                            },
                                            child: Icon(Icons.edit))
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
                                              user['number'],
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
                                              user['email'],
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
