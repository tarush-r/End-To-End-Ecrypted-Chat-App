import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class SharedPreferencesHelper
{
  static Future persistOnLogin(user, token) async
  {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('user', user);
    await prefs.setString('token', token);
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

  static Future getToken() async
  {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if(prefs.getString('token')!=null)
    {
      return json.decode(prefs.getString('token'));
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