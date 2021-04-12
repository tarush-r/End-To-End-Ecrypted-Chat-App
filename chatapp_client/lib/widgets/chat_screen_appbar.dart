import 'package:chatapp_client/models/chat_contact_model.dart';
import 'package:chatapp_client/providers/user_provider.dart';
import 'package:chatapp_client/utils/context_util.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatAppBar extends StatefulWidget implements PreferredSizeWidget {
  final double height;
  @override
  Size get preferredSize => Size.fromHeight(height);
  ChatAppBar({this.height});
  @override
  _ChatAppBarState createState() => _ChatAppBarState();
}

class _ChatAppBarState extends State<ChatAppBar> {

  var selectedUser;

  // double hheight = 50;
  @override
  Widget build(BuildContext context) {
    selectedUser = Provider.of<UserProvider>(context).selectedUser;
    return SafeArea(
      child: GestureDetector(
        // onVerticalDragUpdate: (details) {
        //   print("pan up");
        //       hheight = 50;
        //       setState(() {});
        //     },
        // onVerticalDragDown: (details) {
        //   print("pan down");
        //       hheight = 1000;
        //       setState(() {});
        // },
        child: Container(
          // height: hheight,
          // duration: Duration.zero,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            // borderRadius: BorderRadius.only(
            //     bottomLeft: Radius.circular(10),
            //     bottomRight: Radius.circular(10)),
            color: Colors.white,
          ),
          width: MediaQuery.of(context).size.width,
          // color: Colors.white,
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.only(left: 10),
                  child: GestureDetector(
                    onTap: () {
                      ContextUtil.buildContext.add(null);
                      Navigator.of(context).pop();
                    },
                    child: Icon(
                      Icons.arrow_back,
                      size: 30,
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(20, 10, 10, 10),
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(selectedUser.profilePic),
                    backgroundColor: Colors.green,
                    radius: 20,
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(left: 10),
                  child: Text(
                    selectedUser.name,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Container(
                  padding: EdgeInsets.only(right: 20),
                  child: GestureDetector(
                    child: Icon(Icons.video_call),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(right: 20),
                  child: GestureDetector(
                    child: Icon(Icons.call),
                  ),
                ),
              ],
            )
          ]),
        ),
      ),
    );
    // Column(
    //   children: [
    //     Container(
    //       color: Colors.grey[300],
    //       child: Padding(
    //         padding: EdgeInsets.all(30),
    //         child: Container(
    //           color: Colors.red,
    //           padding: EdgeInsets.all(5),
    //           child: Row(children: [
    //             IconButton(
    //               icon: Icon(Icons.menu),
    //               onPressed: () {
    //                 Scaffold.of(context).openDrawer();
    //               },
    //             ),
    //             Expanded(
    //               child: Container(
    //                 color: Colors.white,
    //                 child: TextField(
    //                   decoration: InputDecoration(
    //                     hintText: "Search",
    //                     contentPadding: EdgeInsets.all(10),
    //                   ),
    //                 ),
    //               ),
    //             ),
    //             IconButton(
    //               icon: Icon(Icons.verified_user),
    //               onPressed: () => null,
    //             ),
    //           ]),
    //         ),
    //       ),
    //     ),
    //   ],
    // );
  }
}
