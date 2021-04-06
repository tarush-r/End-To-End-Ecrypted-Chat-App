import 'package:chatapp_client/providers/chats_provider.dart';
import 'package:chatapp_client/providers/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

class LogoutHelper {

  static void Logout(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Provider.of<UserProvider>(context, listen: false).logout();
    Provider.of<ChatsProvider>(context, listen: false).logout();
    prefs.setString("user", null);
    prefs.setString("token", null);

  }
}