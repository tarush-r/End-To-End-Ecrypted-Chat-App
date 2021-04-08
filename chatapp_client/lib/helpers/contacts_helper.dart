import 'package:contacts_service/contacts_service.dart';
import '../models/contact_model.dart';
import 'dart:convert';
import '../api/contacts_api.dart';

class ContactsHelper {

  static Future<List> getContacts(token) async {
    Iterable<Contact> contactsiter = await ContactsService.getContacts();
    // print(contactsiter.toList()[0].phones.toList()[0].value);
    List contactsiterlist=contactsiter.toList();
    print(contactsiterlist.length);
    List contactslist = [];

    for(int j=0; j<100;j++){
      print(j);
    }
    for(int i=0; i<contactsiterlist.length; i++) {
      // print("--------------------");
      // print(i);
        //  print(contactsiterlist[i].displayName);
        //  print(contactsiterlist[i].givenName);
        //   print(contactsiterlist[i].middleName);
        //    print(contactsiterlist[i].familyName);
        //  print(contactsiterlist[i].phones.toList());
        //  print("--------------------");
      if(contactsiterlist[i].phones.toList().length>0){
             ContactModel contact = new ContactModel(name:contactsiterlist[i].displayName, number:contactsiterlist[i].phones.toList()[0].value);
          contactslist.add(contact.toJson());
      }

    }
    List<dynamic> verifiedContacts = await ContactsApi.getVerifiedContacts({'contactlist':contactslist}, token);
    print(verifiedContacts);
    return verifiedContacts;
  }

}