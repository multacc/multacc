import 'dart:convert';

import 'package:hive/hive.dart';

import 'package:multacc/items/item.dart';
import 'package:multacc/pages/contacts/contact_model.dart';


class DatabaseInterface {
  final Box box;

  DatabaseInterface({this.box});

  void addDummyContacts() {
    MultaccItem micahEmail = MultaccItem.fromDB("asdf", jsonDecode('{\"_t\": \"Email\", \"email\": \"mcwhite9@crimson.ua.edu\"}'));
    MultaccItem micahPhone = MultaccItem.fromDB("1532", jsonDecode('{\"_t\": \"Phone\", \"no\": \"+16159454680\"}'));
    List<MultaccItem> micahList = [micahEmail, micahPhone];
    addContact('0', micahList);
    MultaccItem seanPhone = MultaccItem.fromDB("6436", jsonDecode('{\"_t\": \"Phone\", \"no\": \"509-555-7890\"}'));
    MultaccItem seanTwitter = MultaccItem.fromDB("st", jsonDecode('{\"_t\": \"Twitter\", \"at\": \"wendys\", \"id\": \"59553554\"}'));
    List<MultaccItem> seanList = [seanPhone, seanTwitter];
    addContact('1', seanList);
  }

  void addContact(String key, List<MultaccItem> items) {
    box.put(key, items.map(jsonEncode));
  }
  void addMultaccContact(MultaccContact contact) {
    addContact(contact.clientKey, contact.multaccItems);
  }
  
  List<MultaccItem> getContact(String key) {
    List<dynamic> serializedItems = box.get(key, defaultValue: []);
    // @todo Store the item id in the database
    return serializedItems.cast<String>().map((json) => MultaccItem.fromDB(null /* id */, jsonDecode(json))); 
  }
  
  
}
