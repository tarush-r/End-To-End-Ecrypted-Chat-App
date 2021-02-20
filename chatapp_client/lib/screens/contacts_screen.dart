import 'package:flutter/material.dart';
import '../helpers/contacts_helper.dart';

class ContactsScreen extends StatefulWidget {
  static String routeName = '/contacts';

  @override
  _ContactsScreenState createState() => _ContactsScreenState();
}

class _ContactsScreenState extends State<ContactsScreen> {

  @override
  void initState() {
    // print();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Contacts'),
      ),
      body: Center(
        child: FutureBuilder(
          future: ContactsHelper.getContacts(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (!snapshot.hasData) {
              return Text('Loading');
            }
            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  onTap: () {},
                  title: Text(snapshot.data[index]['name']),
                  subtitle: Text(snapshot.data[index]['number']),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
