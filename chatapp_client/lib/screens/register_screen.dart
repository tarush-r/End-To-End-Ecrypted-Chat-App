import 'package:flutter/material.dart';
import '../helpers/encryption_helper.dart';
import 'package:rsa_encrypt/rsa_encrypt.dart';
import 'package:pointycastle/api.dart' as encryption;
import '../api/authentication_api.dart';
import 'package:pointycastle/export.dart' as pointy;
import 'package:encrypt/encrypt.dart';

import '../api/authentication_api.dart';
import 'package:http/http.dart' as http;
import 'package:asn1lib/asn1lib.dart';

import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

// import 'package:crypto/crypto.dart';
// import 'dart:convert';

class RegisterScreen extends StatelessWidget {
  static final String routeName = '/register';

  // String name, email, phone_num, password;
  final GlobalKey<FormState> _formKey = GlobalKey();
  TextEditingController nameController = new TextEditingController();
  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  TextEditingController phone_numController = new TextEditingController();
  TextEditingController otpController = new TextEditingController();

  RegisterScreen(String name, String email, String password, String phone_num) {
    nameController.text = name;
    emailController.text = email;
    passwordController.text = password;
    phone_numController.text = phone_num;
  }

  _submit() async {
    // print(name);
    final isValid = _formKey.currentState.validate();
    if (!isValid) {
      return;
    }
    _formKey.currentState.save();

    List<String> divided_hashed_password =
        EncryptionHelper.hashPassword(passwordController.text);
    encryption.AsymmetricKeyPair keyPair =
        await EncryptionHelper.generateKeyPair();

    http.Response response = await AuthenticationApi.verifyOtp(
        nameController.text,
        emailController.text,
        EncryptionHelper.hashPassword(passwordController.text)[0],
        phone_numController.text,
        int.parse(otpController.text),
        EncryptionHelper.convertPublicKeyToString(keyPair.publicKey),
        EncryptionHelper.encryptPrivateKey(divided_hashed_password[1], EncryptionHelper.convertPrivateKeyToString(keyPair.privateKey)),
        divided_hashed_password[0]);

    var status = json.decode(response.body);
    // print(status['type']);
    //--------------------------------------------------
    //YEH API KO UNCOMMENT MAT KARNA NAHI TOH ERROR AEGA
    //--------------------------------------------------

    // AuthenticationApi.register(hashedPassword, keyPair.publicKey, keyPair.privateKey);
    print(EncryptionHelper.convertPublicKeyToString(keyPair.publicKey));
    print("DECODING");
    print(EncryptionHelper.convertStringToPublicKey(
        EncryptionHelper.convertPublicKeyToString(keyPair.publicKey)));
    print(EncryptionHelper.convertPublicKeyToString(keyPair.publicKey));
    var x = encrypt("HELLO", keyPair.publicKey);
    print(EncryptionHelper.convertPrivateKeyToString(keyPair.privateKey));
    print("DECODING");
    print(EncryptionHelper.convertStringToPrivateKey(
        EncryptionHelper.convertPrivateKeyToString(keyPair.privateKey)));
    print(EncryptionHelper.convertPrivateKeyToString(keyPair.privateKey));
    pointy.PrivateKey pk = EncryptionHelper.convertStringToPrivateKey(
        EncryptionHelper.convertPrivateKeyToString(keyPair.privateKey));
    print(decrypt(x, keyPair.privateKey));
    print("HASHED");
    print(divided_hashed_password);
    //encrypted_private_key below is stored in database
    String encrypted_private_key = EncryptionHelper.encryptPrivateKey(
        divided_hashed_password[1],
        EncryptionHelper.convertPrivateKeyToString(keyPair.privateKey));
    //decrypted_private_key below is to be stored in local storage. This key is decrpted upon logging in
    String decrypted_private_key = EncryptionHelper.decryptPrivateKey(
        divided_hashed_password[1], encrypted_private_key);
  }

  bool passwordHide = false;
  String passwordText = '';

  // @override
  // void initState() {
  //   passwordHide = true;
  //   passwordController.text = widget.password;
  //   print(passwordController.text);
  //   super.initState();
  // }

  // void initState() {
  //   passwordHide = true;
  //   passwordController.text = widget.password;
  //   print(passwordController.text);
  //   super.initState();
  // }

  @override
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
              // widget.toggleView();
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
                  controller: phone_numController,
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value.isEmpty) {
                      return "Invalid No";
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
                  // initialValue: passwordController.text,
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
                        // setState(() {
                        //   passwordHide = !passwordHide;
                        // });
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
                  // onChanged: (val) {
                  //   setState(() => passwordText = val);
                  // },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: "Enter The OTP"),
                  controller: otpController,
                  validator: (value) {
                    if (value.isEmpty) {
                      return "Invalid Email";
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
