import 'package:flutter/material.dart';
import '../api/authentication_api.dart';
import "dart:convert";
import 'package:http/http.dart' as http;
import './register_screen.dart';

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
    if(isValid){
      print("calling api");
      http.Response response = await AuthenticationApi.getOtp(nameController.text.trim(), emailController.text.trim(), phone_numController.text.trim());
      var status = json.decode(response.body);
      if(status['type']=="success")
      {
        print("passwor"+passwordController.text);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RegisterScreen(nameController.text, emailController.text, passwordController.text, phone_numController.text),
          ),
        );
        // Navigator.pushReplacementNamed(context, RegisterScreen.routeName, arguments: passwordController.text);
      };
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
      appBar: AppBar(
        title: Text("Generate Otp"),
        actions: <Widget>[
          FlatButton.icon(
            icon: Icon(Icons.person, color: Colors.white),
            label: Text(
              'Login',
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
                  decoration: InputDecoration(labelText: "Enter Phone No"),
                  keyboardType: TextInputType.phone,
                  controller: phone_numController,
                  validator: (value) {
                    if (value.isEmpty) {
                      return "Invalid No";
                    }
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: "Enter Name"),
                  controller: nameController,
                  validator: (value) {
                    if (value.isEmpty) {
                      return "Invalid Name";
                    }
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: "Enter Email"),
                  controller: emailController,
                  validator: (value) {
                    if (value.isEmpty) {
                      return "Invalid Email";
                    }
                  },
                ),
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
                RaisedButton(
                  child: Text("Register"),
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