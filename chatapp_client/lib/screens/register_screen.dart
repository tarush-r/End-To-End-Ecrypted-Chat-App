import 'package:flutter/material.dart';
import '../helpers/encryption_helper.dart';
import 'package:rsa_encrypt/rsa_encrypt.dart';
import 'package:pointycastle/api.dart' as encryption;
import '../api/authentication_api.dart';
import 'package:pointycastle/export.dart' as pointy;

import 'package:asn1lib/asn1lib.dart';

import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';


// import 'package:crypto/crypto.dart';
// import 'dart:convert';

class RegisterScreen extends StatefulWidget {
  static final String routeName = '/register';
  final Function toggleView;
  RegisterScreen({this.toggleView});
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  TextEditingController passwordController = new TextEditingController();
  
  _submit() async {
    final isValid = _formKey.currentState.validate();
    if (!isValid) {
      return;
    }
    _formKey.currentState.save();
    String hashedPassword = EncryptionHelper.hashPassword(passwordController.text);
    encryption.AsymmetricKeyPair keyPair = await EncryptionHelper.generateKeyPair();
    
    //--------------------------------------------------
    //YEH API KO UNCOMMENT MAT KARNA NAHI TOH ERROR AEGA
    //--------------------------------------------------
    
    // AuthenticationApi.register(hashedPassword, keyPair.publicKey, keyPair.privateKey);
    print(EncryptionHelper.convertPublicKeyToString(keyPair.publicKey));
    print("DECODING");
    print(EncryptionHelper.convertStringToPublicKey(EncryptionHelper.convertPublicKeyToString(keyPair.publicKey)));
    print(EncryptionHelper.convertPublicKeyToString(keyPair.publicKey));
    var x = encrypt("HELLO", keyPair.publicKey);
    print(EncryptionHelper.convertPrivateKeyToString(keyPair.privateKey));
    print("DECODING");
    print(EncryptionHelper.convertStringToPrivateKey(EncryptionHelper.convertPrivateKeyToString(keyPair.privateKey)));
    print(EncryptionHelper.convertPrivateKeyToString(keyPair.privateKey));
    pointy.PrivateKey pk = EncryptionHelper.convertStringToPrivateKey(EncryptionHelper.convertPrivateKeyToString(keyPair.privateKey));
    print(decrypt(x, keyPair.privateKey));
    // _hashPassword(passwordController.text);
    // print(passwordController.text);
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
