import 'package:chatapp_client/api/settings_api.dart';
import 'package:chatapp_client/helpers/database_helper.dart';
import 'package:chatapp_client/helpers/encryption_helper.dart';
import 'package:chatapp_client/helpers/logout_helper.dart';
import 'package:chatapp_client/helpers/sharedpreferences_helper.dart';
import 'package:chatapp_client/screens/login_screen.dart';
import 'package:chatapp_client/screens/support_screen.dart';
import 'package:flutter/material.dart';
import '../widgets/heading_widget.dart';
import './profile_screen.dart';

class SettingsScreen extends StatefulWidget {
  static final String routeName = '/settings';

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  var user;
  var token;
  DatabaseHelper databaseHelper = DatabaseHelper();

  void initState() {
    super.initState();
    _getUser();
  }

  void _getUser() async {
    user = await SharedPreferencesHelper.getUser();
    token = await SharedPreferencesHelper.getToken();
    // print(user);
  }

  TextEditingController oldPasswordController = new TextEditingController();
  TextEditingController newPasswordController = new TextEditingController();
  TextEditingController otpController = new TextEditingController();

  _resetPasswordSubmit() async {
    SettingsApi.resetPassword(
        EncryptionHelper.hashPassword(oldPasswordController.text.trim())[0],
        EncryptionHelper.hashPassword(newPasswordController.text.toString())[0],
        EncryptionHelper.hashPassword(newPasswordController.text.toString())[1],
        user['privateKey'],
        user['email'],
        "");
  }

  _deleteAccountSubmit() {
    SettingsApi.deleteAccount(user['email']);
  }

  _forgotPasswordSubmit() {
    SettingsApi.forgotPassword(
        EncryptionHelper.hashPassword(newPasswordController.text.toString())[0],
        int.parse(otpController.text),
        EncryptionHelper.hashPassword(newPasswordController.text.toString())[1],
        user['privateKey'],
        user['email']);
  }

  _showResetPasswordDialog() {
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              title: Text("Reset your password"),
              content: Container(
                height: 100,
                child: Column(
                  children: [
                    TextFormField(
                      controller: oldPasswordController,
                      decoration: InputDecoration(hintText: "Old Password"),
                    ),
                    TextFormField(
                      controller: newPasswordController,
                      decoration: InputDecoration(hintText: "New Password"),
                    ),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: Text('Close'),
                  onPressed: () {
                    newPasswordController.clear();
                    oldPasswordController.clear();
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: Text('Submit'),
                  onPressed: () {
                    _resetPasswordSubmit();
                    newPasswordController.clear();
                    oldPasswordController.clear();
                    Navigator.of(context).pop();
                  },
                )
              ],
            ));
  }

  _showDeleteAccountDialog() {
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              title: Text("Delete your account?"),
              content: Text("Are you sure?"),
              actions: <Widget>[
                TextButton(
                  child: Text('Close'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: Text('Yes'),
                  onPressed: () {
                    _deleteAccountSubmit();
                    LogoutHelper.Logout(context);
                    print("Loggwed out");
                    Navigator.of(context).pop();

                    Navigator.pushReplacementNamed(
                        context, LoginScreen.routeName);
                  },
                )
              ],
            ));
  }

  _showGetOtpDialog() {
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              title: Text("Request Otp"),
              content: TextButton(
                onPressed: () async {
                  SettingsApi.otpForgotPassword(user['email']);
                  _showForgotPasswordDialog();
                },
                child: Text('Get Otp'),
              ),
              actions: <Widget>[
                TextButton(
                  child: Text('Close'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ));
  }

  _showForgotPasswordDialog() {
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              title: Text("Fogot Password"),
              content: Container(
                height: 100,
                child: Column(
                  children: [
                    TextFormField(
                      controller: otpController,
                      decoration: InputDecoration(hintText: "OTP"),
                    ),
                    TextFormField(
                      controller: newPasswordController,
                      decoration: InputDecoration(hintText: "New Password"),
                    ),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: Text('Close'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: Text('Yes'),
                  onPressed: () {
                    _forgotPasswordSubmit();
                    LogoutHelper.Logout(context);
                    print("Loggwed out");
                    Navigator.of(context).pop();

                    Navigator.pushReplacementNamed(
                        context, LoginScreen.routeName);
                  },
                )
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Padding(
          padding: const EdgeInsets.all(10),
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                HeadingWidget("Settings"),
                SizedBox(
                  height: 15,
                ),
                Expanded(
                  flex: 1,
                  child: ListView(
                    children: [
                      RawMaterialButton(
                        onPressed: () {
                          Navigator.of(context)
                              .pushNamed(ProfileScreen.routeName);
                        },
                        child: Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.grey[200]),
                          child: Row(
                            children: [
                              Icon(Icons.face),
                              SizedBox(
                                width: 15,
                              ),
                              Text(
                                "Profile",
                                style: TextStyle(fontSize: 20),
                              )
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      RawMaterialButton(
                        onPressed: () {
                          // _showForgotPasswordDialog();
                          _showGetOtpDialog();
                        },
                        child: Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.grey[200]),
                          child: Row(
                            children: [
                              Icon(Icons.lock),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                "Forgot password",
                                style: TextStyle(fontSize: 20),
                              )
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      RawMaterialButton(
                        onPressed: () {
                          _showResetPasswordDialog();
                        },
                        child: Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.grey[200]),
                          child: Row(
                            children: [
                              Icon(Icons.lock_open),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                "Reset password",
                                style: TextStyle(fontSize: 20),
                              )
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      RawMaterialButton(
                        onPressed: () {
                          _showDeleteAccountDialog();
                        },
                        child: Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.grey[200]),
                          child: Row(
                            children: [
                              Icon(Icons.delete),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                "Delete account",
                                style: TextStyle(fontSize: 20),
                              )
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      RawMaterialButton(
                        onPressed: () {
                          Navigator.of(context).pushNamed(SupportScreen.routeName);
                        },
                        child: Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.grey[200]),
                          child: Row(
                            children: [
                              Icon(Icons.info),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                "Support",
                                style: TextStyle(fontSize: 20),
                              )
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      RawMaterialButton(
                        onPressed: () async {
                          var res = await SettingsApi.logout(token);
                          LogoutHelper.Logout(context);
                          Navigator.pushReplacementNamed(
                              context, LoginScreen.routeName);
                        },
                        child: Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.grey[200]),
                          child: Row(
                            children: [
                              Icon(Icons.logout),
                              SizedBox(
                                width: 15,
                              ),
                              Text(
                                "Logout",
                                style: TextStyle(fontSize: 20),
                              )
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      RawMaterialButton(
                        onPressed: () async {
                          var res = await SettingsApi.logoutAll(token);
                          LogoutHelper.Logout(context);
                          Navigator.pushReplacementNamed(
                              context, LoginScreen.routeName);
                        },
                        child: Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.grey[200]),
                          child: Row(
                            children: [
                              Icon(Icons.logout),
                              SizedBox(
                                width: 15,
                              ),
                              Text(
                                "Logout from all devices",
                                style: TextStyle(fontSize: 20),
                              )
                            ],
                          ),
                        ),
                      ),
                      //delete later
                      SizedBox(
                        height: 15,
                      ),
                      RawMaterialButton(
                        onPressed: () async {
                          databaseHelper.dropTable();
                        },
                        child: Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.grey[200]),
                          child: Row(
                            children: [
                              Icon(Icons.clear),
                              SizedBox(
                                width: 15,
                              ),
                              Text(
                                "Clear database",
                                style: TextStyle(fontSize: 20),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
