import 'package:flutter/material.dart';
import 'package:chatapp_client/screens/register_screen.dart';
import 'package:chatapp_client/screens/login_screen.dart';
import './generate_otp_screen.dart';

class Authenticate extends StatefulWidget {
  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  bool showLogin = true;

  void toggleView() {
    setState(() => showLogin = !showLogin);
  }

  @override
  Widget build(BuildContext context) {
    if (showLogin == true) {
      return LoginScreen(toggleView: toggleView);
    } else {
      return GenerateOtpScreen(toggleView: toggleView);
    }
  }
}
