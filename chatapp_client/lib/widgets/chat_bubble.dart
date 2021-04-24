import 'package:chatapp_client/models/chat_model.dart';
import 'package:chatapp_client/utils/color_themes.dart';
import 'package:flutter/material.dart';

class ChatBubble extends StatelessWidget {
  final bool isMe;
  final ChatModel chat;
  ChatBubble({this.isMe, this.chat});

  _getMinutes(minutes) {
    List min = ['00', '01', '02', '03', '04', '05', '06', '07', '08', '09'];
    if (minutes > 9) {
      return minutes.toString();
    } else {
      return min[minutes].toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment:
            isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          Stack(children: [
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
                    chat.message.contains('firebasestorage.googleapis.com')
                        ? GestureDetector(
                          onTap: () {
                            showDialog(context: context, builder: (BuildContext context) {
                              return AlertDialog(
                                content: Image.network(chat.message, fit: BoxFit.cover,)
                              );
                            }
                            );
                          },
                            child: Container(
                              child: Image.network(chat.message),
                            ),
                          )
                        : Container(
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
                        SizedBox(
                          width: 30,
                        )
                        // isMe
                        //     ? Container(
                        //         child: Icon(
                        //           Icons.check,
                        //           color: chat.seen ? Colors.blue : Colors.white,
                        //         ),
                        //       )
                        //     : Container(),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 3,
              right: 5,
              child: isMe
                  ? Container(
                      child: Icon(
                        Icons.check,
                        color: chat.seen ? Colors.blue : Colors.white,
                      ),
                    )
                  : Container(),
            )
          ]),
        ],
      ),
    );
  }
}
