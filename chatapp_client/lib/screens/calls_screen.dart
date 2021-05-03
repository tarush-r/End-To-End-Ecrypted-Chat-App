import 'dart:convert';

import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:chatapp_client/api/chat_api.dart';
import 'package:chatapp_client/helpers/sharedpreferences_helper.dart';
import 'package:chatapp_client/models/contact_model.dart';
import 'package:chatapp_client/screens/call_screen.dart';
import 'package:chatapp_client/widgets/heading_widget.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CallsScreen extends StatefulWidget {
  static String routeName = '/calls';

  @override
  _CallsScreenState createState() => _CallsScreenState();
}

class _CallsScreenState extends State<CallsScreen> {
  List<ContactModel> contactsList = [];
  String token;
  bool loading = true;
  Map user;
  List callLogs;

  Future<void> _handleCameraAndMic(Permission permission) async {
    final status = await permission.request();
    print(status);
  }

  Future<void> onJoin(String email) async {
    print("-----------------");
    print(email);
    await _handleCameraAndMic(Permission.camera);
    await _handleCameraAndMic(Permission.microphone);
    // push video page with given channel name
    await Navigator.push(
      context,
      //  await Navigator.pushNamed(
      //   context,
      MaterialPageRoute(
        builder: (context) => CallPage(
          channelName: email,
          role: ClientRole.Broadcaster,
        ),
      ),
      // CallPage.routeName,
      // arguments: <String, String>{
      //   'email': selectedUser.email,
      //   'role': ClientRole.Broadcaster,
      // },
    );
    // );
    // }
  }

  void initState() {
    super.initState();

    _getCallLogs();

    contactsList.add(ContactModel(name: "Sakshi Pandey", number: "9349543489"));
    contactsList.add(ContactModel(name: "Rahil Parikh", number: "7838343489"));
    contactsList.add(ContactModel(name: "Anina Pillai", number: "9349543489"));
    contactsList.add(ContactModel(name: "Kunal Rane", number: "7838343489"));
    contactsList
        .add(ContactModel(name: "Jigyassa Lamba", number: "9349543489"));
    contactsList
        .add(ContactModel(name: "Aaditya Mahadevan", number: "7838343489"));
    contactsList.add(ContactModel(name: "Sakshi Pandey", number: "9349543489"));
    contactsList.add(ContactModel(name: "Rahil Parikh", number: "7838343489"));
    // contactsList.add(ContactModel(name: "Sakshi Pandey", number: "9349543489"));
    // contactsList.add(ContactModel(name: "Rahil Parikh", number: "7838343489"));
  }

  _getCallLogs() async {
    token = await SharedPreferencesHelper.getToken();
    user = await SharedPreferencesHelper.getUser();
    print(user['_id']);
    var res = await ChatApi.getAllCalls(token);
    print(res.body);
    callLogs = json.decode(res.body)['calls'];
    print(callLogs);
    setState(() {
      loading = false;
    });
  }

  _callItemContainer(call) {
    return Padding(
      padding: const EdgeInsets.all(5),
      child: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: Colors.grey[200], borderRadius: BorderRadius.circular(10)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            user['_id'] == call['sender']['_id']
                ? Row(
                    children: [
                      CircleAvatar(
                        backgroundImage:
                            NetworkImage(call['receiver']['profile_pic']),
                        backgroundColor: Colors.green,
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
                              call['receiver']['name'],
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 15),
                            ),
                            Text(call['receiver']['number'])
                          ],
                        ),
                      ),
                    ],
                  )
                : Row(
                    children: [
                      CircleAvatar(
                        backgroundImage:
                            NetworkImage(call['sender']['profile_pic']),
                        backgroundColor: Colors.green,
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
                              call['sender']['name'],
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 15),
                            ),
                            Text(call['sender']['number'])
                          ],
                        ),
                      ),
                    ],
                  ),
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    // sendMessage();
                    //   onJoin();
                  },
                  child: Icon(Icons.video_call),
                ),
                SizedBox(
                  width: 15,
                ),
                // Icon(Icons.call)
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
        body: loading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Padding(
                padding: const EdgeInsets.all(10),
                child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      HeadingWidget("Calls"),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        height: MediaQuery.of(context).size.height * 0.66,
                        child: ListView.builder(
                            itemCount: callLogs.length,
                            itemBuilder: (context, index) {
                              return _callItemContainer(callLogs[index]);
                            }),
                      )
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
