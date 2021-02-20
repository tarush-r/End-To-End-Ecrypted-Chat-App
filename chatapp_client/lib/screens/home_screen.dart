import 'package:chatapp_client/screens/login_screen.dart';
import 'package:flutter/material.dart';
import '../helpers/sharedpreferences_helper.dart';
import '../helpers/contacts_helper.dart';
import './contacts_screen.dart';

class HomeScreen extends StatelessWidget {

  static String routeName = '/home';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [RaisedButton(onPressed: () {
          SharedPreferencesHelper.logout();
          
          Navigator.pushReplacementNamed(context, LoginScreen.routeName);
        })],
      ),
      body: Container(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.contacts),
        onPressed: () {
          Navigator.pushNamed(context, ContactsScreen.routeName);
          // ContactsHelper.getContacts();
        },
      ),
    );
  }
}