// import 'dart:async';
import 'dart:convert';

import 'package:multacc/items/phone.dart';
import 'package:hive/hive.dart';

import '../items/item.dart';
import '../items/email.dart';
import '../items/twitter.dart';


class DatabaseInterface {
  // final String dbName;

  final Box box;

  DatabaseInterface({this.box});

  void addDummyContacts(){
    PhoneItem micahPhone = MultaccItem.fromDB("1532", jsonDecode('{\"type\": 6, \"phone\": \"+16159454680\"}'));
    EmailItem micahEmail = MultaccItem.fromDB("asdf", jsonDecode('{\"type\": 7, \"email\": \"mcwhite9@crimson.ua.edu\"}'));
    List<MultaccItem> micahList = [micahPhone, micahEmail];
    box.add(['Micah_White_1684', micahList]);
    PhoneItem seanPhone = MultaccItem.fromDB("6436", jsonDecode('{\"type\": 6, \"phone\": \"+11234567890\"}'));
    TwitterItem seanTwitter = MultaccItem.fromDB("st", jsonDecode('{\"type\": 0, \"at\": \"seangillen69\", \"id\": \"Sean Gilligan\"}'));
    List<MultaccItem> seanList = [seanPhone, seanTwitter];
    box.add(['Sean_Gillen_7777', seanList]);
  }

  void addContact(String name, [List<MultaccItem> l]){
    List<MultaccItem> newList;

    if(l == null)
      newList = [];
    else
      newList = l;

    box.add([name, newList]);
  }

  void addItem(String id, MultaccItem i){
    (box.get(id))[1].add(i);
  }

  
  void print(String id){
    print(box.get(id));
  }
  


  
}

