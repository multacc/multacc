import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:multacc/items/item.dart';
import 'package:multacc/database/contact_model.dart';

class DatabaseInterface {
  Box<MultaccContact> get contactsBox => Hive.box<MultaccContact>('contacts');

  Future<void> init() async {
    await Hive.initFlutter();

    Hive.registerAdapter(MultaccContactAdapter(), 0);
    Hive.registerAdapter(MultaccItemAdapter(), 1);

    await Hive.openBox<MultaccContact>('contacts');
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
