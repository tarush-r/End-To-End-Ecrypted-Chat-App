import 'package:chatapp_client/screens/login_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../api/authentication_api.dart';
import "dart:convert";
import 'package:http/http.dart' as http;
import './register_screen.dart';
import '../utils/color_themes.dart';

class GenerateOtpScreen extends StatefulWidget {
  static final String routeName = '/generateOtp';
  final Function toggleView;
  GenerateOtpScreen({this.toggleView});
  @override
  _GenerateOtpScreenState createState() => _GenerateOtpScreenState();
}

class _GenerateOtpScreenState extends State<GenerateOtpScreen> {
  bool passwordHide = false;
  String password = '';
  TextEditingController passwordController = new TextEditingController();
  TextEditingController nameController = new TextEditingController();
  TextEditingController emailController = new TextEditingController();
  TextEditingController phone_numController = new TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey();

  _submit() async {
    final isValid = _formKey.currentState.validate();
    if (isValid) {
      print("calling api");
      http.Response response = await AuthenticationApi.getOtp(
          nameController.text.trim(),
          emailController.text.trim(),
          phone_numController.text.trim());
      var status = json.decode(response.body);
      if (status['type'] == "success") {
        print("passwor" + passwordController.text);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RegisterScreen(
                nameController.text,
                emailController.text,
                passwordController.text,
                phone_numController.text),
          ),
        );
        // Navigator.pushReplacementNamed(context, RegisterScreen.routeName, arguments: passwordController.text);
      }
      ;
      // print("response here"+response);
    }
  }

  @override
  void initState() {
    passwordHide = true;
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   backgroundColor: Colors.black,
      //   title: Text("Register"),
      //   actions: <Widget>[
      //     FlatButton.icon(
      //       icon: Icon(Icons.person, color: Colors.white),
      //       label: Text(
      //         'Login',
      //         style: TextStyle(fontSize: 18, color: Colors.white),
      //       ),
      //       onPressed: () {
      //         // widget.toggleView();
      //         Navigator.pushReplacementNamed(context, LoginScreen.routeName);
      //       },
      //     ),
      //   ],
      // ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 30.0),
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
                        Icon(Icons.person, color: Colors.white),
                        SizedBox(width: 10.0),
                        Text('Login', style: TextStyle(color: Colors.white)),
                      ]),
                      color: ColorThemes.primary,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40)),
                      onPressed: () {
                        // widget.toggleView();
                        Navigator.pushReplacementNamed(
                            context, LoginScreen.routeName);
                      },
                    ),
                  ],
                ),
                SizedBox(height: 40.0),
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
                    hintText: 'Phone Number',
                    border: new OutlineInputBorder(
                      borderRadius: const BorderRadius.all(
                        const Radius.circular(20.0),
                      ),
                    ),
                    // enabledBorder: OutlineInputBorder(
                    //     borderSide:
                    //         BorderSide(color: Colors.black, width: 2.0)),
                    // focusedBorder: OutlineInputBorder(
                    //   borderSide: BorderSide(color: Colors.red, width: 2.0),
                    // ),
                  ),
                  keyboardType: TextInputType.phone,
                  controller: phone_numController,
                  validator: (value) {
                    if (value.isEmpty) {
                      return "Invalid No";
                    }
                  },
                ),
                SizedBox(height: 10.0),
                TextFormField(
                  decoration: InputDecoration(
                    hintText: 'Name',
                    border: new OutlineInputBorder(
                      borderRadius: const BorderRadius.all(
                        const Radius.circular(20.0),
                      ),
                    ),
                    // enabledBorder: OutlineInputBorder(
                    //     borderSide:
                    //         BorderSide(color: Colors.black, width: 2.0)),
                    // focusedBorder: OutlineInputBorder(
                    //   borderSide: BorderSide(color: Colors.red, width: 2.0),
                    // ),
                  ),
                  controller: nameController,
                  validator: (value) {
                    if (value.isEmpty) {
                      return "Invalid Name";
                    }
                  },
                ),
                SizedBox(height: 10.0),
                TextFormField(
                  decoration: InputDecoration(
                    hintText: 'Email',
                    border: new OutlineInputBorder(
                      borderRadius: const BorderRadius.all(
                        const Radius.circular(20.0),
                      ),
                    ),
                    // enabledBorder: OutlineInputBorder(
                    //     borderSide:
                    //         BorderSide(color: Colors.black, width: 2.0)),
                    // focusedBorder: OutlineInputBorder(
                    //   borderSide: BorderSide(color: Colors.red, width: 2.0),
                    // ),
                  ),
                  validator: (val) =>
                      val.isEmpty ? 'Enter a valid Email' : null,
                  controller: emailController,
                ),
                SizedBox(height: 10.0),
                TextFormField(
                  decoration: InputDecoration(
                    hintText: 'Password',
                    border: new OutlineInputBorder(
                      borderRadius: const BorderRadius.all(
                        const Radius.circular(20.0),
                      ),
                    ),
                    // enabledBorder: OutlineInputBorder(
                    //     borderSide:
                    //         BorderSide(color: Colors.black, width: 2.0)),
                    // focusedBorder: OutlineInputBorder(
                    //   borderSide: BorderSide(color: Colors.red, width: 2.0),
                    // ),
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
                  validator: (val) {
                    if (val.length < 6) {
                      return 'Enter a password greater than 6 characters.';
                    } else {
                      return null;
                    }
                  },
                  controller: passwordController,
                  obscureText: passwordHide,
                  onChanged: (val) {
                    setState(() => password = val);
                  },
                ),
                SizedBox(height: 20.0),
                SizedBox(
                  width: 250,
                  child: RaisedButton(
                      color: ColorThemes.primary,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: Text(
                          'REGISTER',
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
    );
  }
}
