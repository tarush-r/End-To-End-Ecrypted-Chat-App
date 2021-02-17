import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class SharedPreferencesHelper
{
  static Future persistOnLogin(user) async
  {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('user', user);
  }

  static Future getUser() async
  {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return json.decode(prefs.getString('user'));
  }
}