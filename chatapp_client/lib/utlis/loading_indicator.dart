import 'package:flutter/material.dart';

class LoadingProgressDialog {
  show(BuildContext context, {message}) {
    // showDialog(
    //   context: context,
    //   barrierDismissible: false,
    //   builder: (BuildContext context) {
    //     return LoadingIndicator();
    //   },
    // );
    showDialog(
        context: context,
        builder: (_) => new AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0))),
              content: Builder(
                builder: (context) {
                  // Get available height and width of the build area of this widget. Make a choice depending on the size.
                  var height = MediaQuery.of(context).size.height;
                  var width = MediaQuery.of(context).size.width;

                  return Container(
                    height: height - 500,
                    width: width - 400,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        CircularProgressIndicator(),
                        Text("Generating your key pair")
                      ],
                    ),
                  );
                },
              ),
            ));
  }

  hide(BuildContext context) {
    Navigator.pop(context);
  }
}
