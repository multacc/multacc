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
    EmailItem micahEmail = MultaccItem.fromDB("asdf", jsonDecode('{\"_t\": \"Email\", \"email\": \"mcwhite9@crimson.ua.edu\"}'));
    PhoneItem micahPhone = MultaccItem.fromDB("1532", jsonDecode('{\"_t\": \"Phone\", \"no\": \"+16159454680\"}'));
    List<MultaccItem> micahList = [micahEmail, micahPhone];
    box.put('0', ['Micah_White_1684', micahList]);
    PhoneItem seanPhone = MultaccItem.fromDB("6436", jsonDecode('{\"_t\": \"Phone\", \"no\": \"+11234567890\"}'));
    TwitterItem seanTwitter = MultaccItem.fromDB("st", jsonDecode('{\"_t\": \"Twitter\", \"at\": \"seangillen69\", \"id\": \"Sean Gilligan\"}'));
    List<MultaccItem> seanList = [seanPhone, seanTwitter];
    box.put('1', ['Sean_Gillen_7777', seanList]);
  }

  void addContact(String name, [List<MultaccItem> l]){
    List<MultaccItem> newList;

    if(l == null)
      newList = [];
    else
      newList = l;

    box.put(name, [name, newList]);
  }

  void addItem(String id, MultaccItem i){
    var tempArray = box.get(id);
    var tempList = tempArray[1];
    tempList.add(i);
  }

  
  void printContact(String id){
    // print(box.get(id).toString());
    // print('wtf is happening\n');
    var tempASDF = box.get(id);
    var eatItKid = tempASDF[1];
    // print('hey!\n');
    // print('$eatItKid\n');
    String str, str2;
    eatItKid.forEach( (i) => { str = i.getHumanReadableValue(), str2 = i.getHumanReadableType(), print('$str2 : $str\n') });
  
  }
  
}

