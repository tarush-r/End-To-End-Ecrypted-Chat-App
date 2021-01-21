import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  static final String routeName = '/register';
  final Function toggleView;
  RegisterScreen({this.toggleView});
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey();

  _submit() {
    _formKey.currentState.validate();
  }

  bool passwordHide = false;
  String password = '';

  @override
  void initState() {
    passwordHide = true;
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Register"),
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
                  validator: (value) {
                    if (value.isEmpty) {
                      return "Invalid No";
                    }
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: "Enter Email"),
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
                  validator: (val) => val.length < 6
                      ? 'Enter a password greater than 6 characters.'
                      : null,
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
