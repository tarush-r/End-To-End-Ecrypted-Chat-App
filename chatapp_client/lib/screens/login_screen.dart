import 'package:chatapp_client/api/authentication_api.dart';
import 'package:flutter/material.dart';
import '../helpers/encryption_helper.dart';

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


  _submit() {
    String hashedPassword;
    // print("HEllo");
    _formKey.currentState.validate();
    hashedPassword = EncryptionHelper.hashPassword(passwordController.text);
    //DONT UNCOMMENT API
    // AuthenticationApi.login(hashedPassword);
    // print("done");
  }

  bool passwordHide = false;
  String email = '';
  String password = '';


  @override
  void initState() {
    passwordHide = true;
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
                  onChanged: (val) {
                    setState(() => email = val);
                  },
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
                  onChanged: (val) {
                    setState(() => password = val);
                  },
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
