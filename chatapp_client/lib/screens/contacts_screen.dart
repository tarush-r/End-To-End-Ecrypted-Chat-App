import 'package:chatapp_client/widgets/heading_widget.dart';
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

  _contactContainer(contact) {
    return Padding(
      padding: const EdgeInsets.all(5),
      child: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: Colors.grey[200], borderRadius: BorderRadius.circular(10)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.green,
                  radius: 20,
                ),
                SizedBox(
                  width: 10,
                ),
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        contact['name'],
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                      Text(contact['number'])
                    ],
                  ),
                ),
              ],
            ),
            Row(
              children: [Icon(Icons.add)],
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: EdgeInsets.all(10),
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        // color: Colors.blue
                      ),
                      width: 40,
                      child: MaterialButton(
                          shape: CircleBorder(),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Center(child: Icon(Icons.arrow_back))),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    HeadingWidget("Contacts")
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.8,
                  child: FutureBuilder(
                    future: ContactsHelper.getContacts(),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (!snapshot.hasData) {
                        return Text('Loading');
                      }
                      return ListView.builder(
                        itemCount: snapshot.data.length,
                        itemBuilder: (BuildContext context, int index) {
                          return _contactContainer(snapshot.data[index]);
                        },
                      );
                    },
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
