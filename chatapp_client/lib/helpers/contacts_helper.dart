import 'package:contacts_service/contacts_service.dart';
import '../models/contact_model.dart';
import 'dart:convert';
import '../api/contacts_api.dart';

class ContactsHelper {

  static Future<List> getContacts(token) async {
    Iterable<Contact> contactsiter = await ContactsService.getContacts();
    // print(contactsiter.toList()[0].phones.toList()[0].value);
    print(contactsiter.toList().length);
    List contactslist = [];
    for(int i=0; i<contactsiter.toList().length; i++) {
      ContactModel contact = new ContactModel(name:contactsiter.toList()[i].displayName, number:contactsiter.toList()[i].phones.toList()[0].value);
      contactslist.add(contact.toJson());
    }
    List<dynamic> verifiedContacts = await ContactsApi.getVerifiedContacts({'contactlist':contactslist}, token);
    print(verifiedContacts);
    return verifiedContacts;
  }

}