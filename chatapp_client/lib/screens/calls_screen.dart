import 'package:chatapp_client/models/contact_model.dart';
import 'package:chatapp_client/widgets/heading_widget.dart';
import 'package:flutter/material.dart';

class CallsScreen extends StatefulWidget {
  static String routeName = '/calls';

  @override
  _CallsScreenState createState() => _CallsScreenState();
}

class _CallsScreenState extends State<CallsScreen> {
  List<ContactModel> contactsList = [];

  void initState() {
    super.initState();
    contactsList.add(ContactModel(name: "Sakshi Pandey", number: "9349543489"));
    contactsList.add(ContactModel(name: "Rahil Parikh", number: "7838343489"));
    contactsList.add(ContactModel(name: "Anina Pillai", number: "9349543489"));
    contactsList.add(ContactModel(name: "Kunal Rane", number: "7838343489"));
    contactsList.add(ContactModel(name: "Jigyassa Lamba", number: "9349543489"));
    contactsList.add(ContactModel(name: "Aaditya Mahadevan", number: "7838343489"));
    contactsList.add(ContactModel(name: "Sakshi Pandey", number: "9349543489"));
    contactsList.add(ContactModel(name: "Rahil Parikh", number: "7838343489"));
    // contactsList.add(ContactModel(name: "Sakshi Pandey", number: "9349543489"));
    // contactsList.add(ContactModel(name: "Rahil Parikh", number: "7838343489"));
  }

  _callItemContainer(contact) {
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
                        contact.name,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                      Text(contact.number)
                    ],
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Icon(Icons.call)
              ],
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
          padding: const EdgeInsets.all(10),
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                HeadingWidget("Calls"),
                SizedBox(
                  height: 20,
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.66,
                  child: ListView.builder(
                      itemCount: contactsList.length,
                      itemBuilder: (context, index) {
                        return _callItemContainer(contactsList[index]);
                      }),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
