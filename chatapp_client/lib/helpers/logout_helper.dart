import 'package:shared_preferences/shared_preferences.dart';

class LogoutHelper {

  static void Logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("user", null);

  }
}