import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:multacc/common/constants.dart';

import 'package:multacc/items/item.dart';
import 'package:multacc/database/contact_model.dart';

class DatabaseInterface {
  Box<MultaccContact> get contactsBox => Hive.box<MultaccContact>('contacts');

  Future<void> init() async {
    await Hive.initFlutter();

    Hive.registerAdapter(MultaccContactAdapter());
    Hive.registerAdapter(MultaccItemAdapter());

    await Hive.openBox<MultaccContact>('contacts');
  }

  void addContact(MultaccContact contact) {
    contactsBox.put(contact.clientKey, contact);
  }
  
  Future<void> deleteContact(MultaccContact contact) {
    return contactsBox.delete(contact.clientKey);
  }

  MultaccContact getContact(String key) {
    return contactsBox.get(key);
  }

  Iterable<MultaccContact> getCachedContacts() {
    return contactsBox.values.where((contact) => contact.clientKey != PROFILE_CONTACT_KEY);
  }
}
