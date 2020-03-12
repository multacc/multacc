import 'dart:convert';

import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

import 'package:multacc/items/item.dart';
import 'package:multacc/pages/contacts/contact_model.dart';

class DatabaseInterface {
  Box contactsBox;

  void init() async {
    Hive.init((await path_provider.getApplicationDocumentsDirectory()).path);
    Hive.registerAdapter(MultaccContactAdapter());
    Hive.registerAdapter(MultaccItemAdapter());
    contactsBox = await Hive.openBox<MultaccContact>('contacts');
  }

  void addDummyContacts() {
    addContact(MultaccContact()
      ..clientKey = '0'
      ..displayName = 'Micah'
      ..multaccItems = [
        MultaccItem.fromDB(jsonDecode('{"_id": "asdf", "_t": "Email", "email": "mcwhite9@crimson.ua.edu"}')),
        MultaccItem.fromDB(jsonDecode('{"_id": "1532", "_t": "Phone", "no": "+16159454680"}'))
      ]);
    addContact(MultaccContact()
      ..clientKey = '1'
      ..displayName = 'Sean'
      ..birthday = DateTime(1999, 03, 29)
      ..multaccItems = [
        MultaccItem.fromDB(jsonDecode('{"_id": "6436", "_t": "Phone", "no": "509-555-7890"}')),
        MultaccItem.fromDB(jsonDecode('{"_id": "st", "_t": "Twitter", "at": "wendys", "id": "59553554"}'))
      ]);
  }

  void addContact(MultaccContact contact) {
    contactsBox.put(contact.clientKey, contact);
  }

  MultaccContact getContact(String key) {
    return contactsBox.get(key);
  }

  Iterable<MultaccContact> getAllContacts() {
    return contactsBox.values;
  }
}
