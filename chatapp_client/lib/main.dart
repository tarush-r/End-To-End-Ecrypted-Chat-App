import 'package:flutter/material.dart';
import './screens/register_screen.dart';
import './screens/generate_otp_screen.dart';
import './screens/login_screen.dart';
import './screens/authenticate.dart';
import 'screens/home_screen.dart';
import './helpers/sharedpreferences_helper.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Authenticate(),
      routes: {
        GenerateOtpScreen.routeName: (ctx) => GenerateOtpScreen(),
        LoginScreen.routeName: (ctx) => LoginScreen(),
        HomeScreen.routeName: (ctx) => HomeScreen(),
        // RegisterScreen.routeName: (ctx) => RegisterScreen()
      },
    );
  }
}
