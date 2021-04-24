import 'package:flutter/material.dart';

class ShowMessage {
  static Future show(
      String title, String message, Function onClick, BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext ctx) {
          return AlertDialog(
            title: Text(title),
            content: Container(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(message),
                  SizedBox(height: 20,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(ctx).pop();
                        },
                        child: Text('Close'),
                      ),
                      TextButton(onPressed: () {
                        Navigator.of(ctx).pop();
                        onClick();
                        
                        print("helloooooo");
                      }, child: Text("Ok"))
                    ],
                  ),
                ],
              ),
            ),
          );
        });
  }
}
