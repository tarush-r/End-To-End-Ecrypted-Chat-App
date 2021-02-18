import 'package:chatapp_client/api/authentication_api.dart';
import 'package:chatapp_client/screens/home_screen.dart';
import 'package:flutter/material.dart';
import '../helpers/encryption_helper.dart';
import 'dart:convert';
import '../helpers/sharedpreferences_helper.dart';

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
    SharedPreferencesHelper.persistOnLogin(json.encode(json.decode(response.body)['user']));
    var user = await SharedPreferencesHelper.getUser();
    if(user!=null)
    {
      Navigator.pushReplacementNamed(context, HomeScreen.routeName);
    }
    //DONT UNCOMMENT API
    // AuthenticationApi.login(hashedPassword);
    // print("done");
  }

  bool passwordHide = false;
  // String email = '';
  // String password = '';
  void checkLogin() async
  {
    var user =  await SharedPreferencesHelper.getUser();
    if(user!=null)
    {
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
      appBar: AppBar(
        title: Text("Login"),
        actions: <Widget>[
          FlatButton.icon(
            icon: Icon(Icons.person_add, color: Colors.white),
            label: Text(
              'Register',
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
            onPressed: () {
              widget.toggleView();
            },
          ),
        ],
      ),
      body: Center(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                TextFormField(
                  decoration: InputDecoration(
                      hintText: 'Email',
                      enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.black, width: 2.0)),
                      focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.blue, width: 2.0))),
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
                        borderSide: BorderSide(color: Colors.blue, width: 2.0)),
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
                RaisedButton(
                  child: Text("Login"),
                  onPressed: _submit,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
