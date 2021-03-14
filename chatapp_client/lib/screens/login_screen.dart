import 'package:chatapp_client/api/authentication_api.dart';
import 'package:chatapp_client/screens/generate_otp_screen.dart';
import 'package:chatapp_client/screens/home_screen.dart';
import 'package:chatapp_client/screens/register_screen.dart';
import 'package:flutter/material.dart';
import '../helpers/encryption_helper.dart';
import 'dart:convert';
import '../helpers/sharedpreferences_helper.dart';
import './register_screen.dart';
import 'package:flutter/cupertino.dart';

class LoginScreen extends StatefulWidget {
  static final String routeName = '/Login';
  final Function toggleView;
  LoginScreen({this.toggleView});
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  TextEditingController passwordController = new TextEditingController();
  TextEditingController emailController = new TextEditingController();

  _submit() async {
    List<String> hashedPassword;
    // print("HEllo");
    _formKey.currentState.validate();
    hashedPassword =
        EncryptionHelper.hashPassword(passwordController.text.trim());
    var response = await AuthenticationApi.login(
        hashedPassword[0], emailController.text.trim());
    print(response.body);
    SharedPreferencesHelper.persistOnLogin(
        json.encode(json.decode(response.body)['user']));
    var user = await SharedPreferencesHelper.getUser();
    if (user != null) {
      Navigator.pushReplacementNamed(context, HomeScreen.routeName);
    }
    //DONT UNCOMMENT API
    // AuthenticationApi.login(hashedPassword);
    // print("done");
  }

  bool passwordHide = false;
  // String email = '';
  // String password = '';
  void checkLogin() async {
    var user = await SharedPreferencesHelper.getUser();
    if (user != null) {
      print("hello");
      Navigator.pushReplacementNamed(context, HomeScreen.routeName);
    }
  }

  @override
  void initState() {
    passwordHide = true;
    checkLogin();
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                SizedBox(height: 20.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    FlatButton(
                      child: Row(children: <Widget>[
                        Icon(Icons.person_add, color: Colors.white),
                        SizedBox(width: 10.0),
                        Text('Register', style: TextStyle(color: Colors.white)),
                      ]),
                      color: Colors.red,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40)),
                      onPressed: () {
                        Navigator.pushReplacementNamed(
                            context, GenerateOtpScreen.routeName);
                        // widget.toggleView();
                      },
                    ),
                  ],
                ),
                SizedBox(height: 100.0),
                CircleAvatar(
                  radius: 48,
                  backgroundColor: Colors.black,
                  child: Icon(
                    CupertinoIcons.chat_bubble,
                    size: 48,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 10.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'Cypher',
                      style: TextStyle(
                        fontFamily: 'Poiret',
                        fontSize: 47,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        textBaseline: TextBaseline.alphabetic,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 60.0),
                TextFormField(
                  decoration: InputDecoration(
                      hintText: 'Email',
                      enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.black, width: 2.0)),
                      focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.red, width: 2.0))),
                  validator: (val) =>
                      val.isEmpty ? 'Enter a valid Email' : null,
                  controller: emailController,
                ),
                SizedBox(height: 20.0),
                TextFormField(
                  decoration: InputDecoration(
                    hintText: 'Password',
                    enabledBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.black, width: 2.0)),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red, width: 2.0)),
                    suffixIcon: IconButton(
                      icon: Icon(
                        passwordHide ? Icons.visibility_off : Icons.visibility,
                      ),
                      onPressed: () {
                        setState(() {
                          passwordHide = !passwordHide;
                        });
                      },
                    ),
                  ),
                  controller: passwordController,
                  validator: (val) => val.length < 6
                      ? 'Enter a password greater than 6 characters.'
                      : null,
                  obscureText: passwordHide,
                  // onChanged: (val) {
                  //   setState(() => password = val);
                  // },
                ),
                SizedBox(height: 20.0),
                SizedBox(
                  width: 250,
                  child: RaisedButton(
                      color: Colors.red,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: Text(
                          'LOG IN',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 3,
                          ),
                        ),
                      ),
                      shape: RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(30.0)),
                      onPressed: _submit),
                )
              ],
            ),
          ),
        ),
      ),

      //////
    );
  }
}
