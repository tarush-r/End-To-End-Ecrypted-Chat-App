import 'package:chatapp_client/api/settings_api.dart';
import 'package:chatapp_client/widgets/heading_widget.dart';
import 'package:flutter/material.dart';
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
                          HeadingWidget("Profile"),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircleAvatar(
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
                          )
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Column(
                        children: [
                          Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.grey[200]),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
