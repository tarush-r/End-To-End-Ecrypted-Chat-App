import 'package:flutter/material.dart';

Widget HeadingWidget(String title) {
  return Container(
    child: Text(
      title,
      style: TextStyle(
        fontSize: 50,
        fontWeight: FontWeight.bold,
      ),
    ),
  );
}
