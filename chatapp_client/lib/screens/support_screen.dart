import 'package:chatapp_client/widgets/heading_widget.dart';
import 'package:flutter/material.dart';

class SupportScreen extends StatefulWidget {
  static String routeName = "/support";

  @override
  _SupportScreenState createState() => _SupportScreenState();
}

class _SupportScreenState extends State<SupportScreen> {
  List questions;
  List isVisible = [];
  @override
  void initState() {
    super.initState();
    questions = [
      {
        "id": "1",
        "question": "Supported operating systems",
        "answer":
            "We provide support for and recommend using the following devices:\nAndroid running OS 4.0.3 and newer\nOnce you have one of these devices, install Cypher and register your phone number and email id.\nCypher can only be activated with one devices on one device at a time but can be used from multiple devices."
      },
      {
        "id": "2",
        "question": "How to register",
        "answer":
            "Enter your number, email id and other details.\nEnter the otp sent to given email id.\nONCE otp is verified, you are registered and you can login to you account."
      },
      {
        "id": "3",
        "question": "How to logout",
        "answer":
            "As Cypher allows users to login on multiple devices at a time, one can logout from a particular device or all thhe devices in which they have logged in."
      },
      {
        "id": "4",
        "question": "Verified Contacts",
        "answer":
            "Cypher provides the list of contacts from the user's phone book who have registered to Cypher. The user can directly initiate chat with them."
      },
      {
        "id": "5",
        "question": "How to schedule message",
        "answer":
            "Slide the chat from list of contacts of the contact you wish to schedule message for from left to right.\nYou can then enter the date and time at which you want the message to be delivered. On confirmation, the message is scheduled to be delivered at give timestamp.\nNote: The date can be set minimum to the next day of the date on which the user is scheduling the message."
      },
      {
        "id": "6",
        "question": "Security and privacy policy",
        "answer":
            "All the messages and media are end to end encrypted and stored in the server. Cypher cannot access the actual message.\nThe keys used for decrypted only on client side and Cypher doesn't have access information to decrypt the messages and files and hence the messages of users are safe."
      },
      {
        "id": "7",
        "question": "Chats",
        "answer":
            "The message read receipt status is given to the receiver. Blue tick indicates that message is read by the receiver else it has not been read yet.The messages are stored in local storage in plain text format.\nHence, user won't get access to older messages if he/she uninstalls the application as local storage is cleared once the app is uninstalled."
      },
      {
        "id": "8",
        "question": "Message storage and access",
        "answer":
            "The messages are stored in local storage of user's device in plain text format and in encrypted format in the server.\nHence, user won't get access to older messages if he/she uninstalls the application as local storage is cleared once the app is uninstalled and backup is not integrated yet."
      },
      {
        "id": "9",
        "question": "Contact us",
        "answer": "If you have any query, mail us at support.cypher@gmail.com"
      }
    ];
  }

  _questionContainer(question) {
    return Container(
      // width: 100,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            // onPressed: () {},
            child: Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.grey[200]),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Icon(Icons.face),
                      // SizedBox(
                      //   width: 15,
                      // ),
                      Text(
                        question['question'],
                        style: TextStyle(fontSize: 20),
                      ),
                      GestureDetector(
                        onTap: () {
                          if (isVisible.contains(question['id'])) {
                            isVisible.removeWhere(
                                (element) => element == question['id']);
                          } else {
                            isVisible.add(question['id']);
                          }
                          setState(() {});
                        },
                        child: Icon(
                          isVisible.contains(question['id'])
                              ? Icons.keyboard_arrow_up
                              : Icons.keyboard_arrow_down,
                        ),
                      )
                    ],
                  ),
                  isVisible.contains(question['id'])
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Icon(Icons.face),
                            // SizedBox(
                            //   width: 15,
                            // ),
                            Container(
                              width: MediaQuery.of(context).size.width * 0.9,
                              child: Text(
                                question['answer'],
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                          ],
                        )
                      : Container(),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 15,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Padding(
          padding: const EdgeInsets.all(10),
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
                    HeadingWidget("Support"),
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
                Expanded(
                  flex: 1,
                  child: ListView.builder(
                    itemCount: questions.length,
                    itemBuilder: (context, index) {
                      return _questionContainer(questions[index]);
                    },
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
