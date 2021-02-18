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
    if(prefs.getString('user')!=null)
    {
      return json.decode(prefs.getString('user'));
    }
    else
    {
      return null;
    }
  }

  static Future logout() async
  {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove("user");
  }
}