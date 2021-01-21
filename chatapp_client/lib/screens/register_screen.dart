import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  static final String routeName = '/register';

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {

  final GlobalKey<FormState> _formKey = GlobalKey();

  _submit(){
    _formKey.currentState.validate();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Register"),
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
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value.isEmpty) {
                      return "Invalid Email";
                    }
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: "Enter Email"),
                  keyboardType: TextInputType.phone,
                  obscureText: true,
                  validator: (value) {
                    if (value.isEmpty || value.length<5) {
                      return "Invalid Password";
                    }
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
