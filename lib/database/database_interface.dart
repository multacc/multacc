import 'dart:async';
import 'dart:convert';

import 'package:contacts_service/contacts_service.dart';
import 'package:multacc/items/phone.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:hive/hive.dart';

import '../items/item.dart';
import '../items/email.dart';
import '../items/twitter.dart';


class DatabaseInterface {
  // final String dbName;

  final box;

  DatabaseInterface({this.box});

  void addDummyContacts(){
    PhoneItem micahPhone = new MultaccItem.fromDB("1532", jsonDecode("{'type': 6, 'phone': '+16159454680'}"));
    EmailItem micahEmail = new MultaccItem.fromDB("asdf", jsonDecode("{'type': 7, 'email': 'mcwhite9@crimson.ua.edu}"));
    List<MultaccItem> micahList = [micahPhone, micahEmail];
    box.add(['Micah White', micahList]);
    PhoneItem seanPhone = new MultaccItem.fromDB("6436", jsonDecode("{'type': 6, 'phone': '+11234567890'}"));
    TwitterItem seanTwitter = new MultaccItem.fromDB("st", jsonDecode("{'type': 0, 'at': 'seangillen69', 'id': 'Sean Gilligan'}"));
    List<MultaccItem> seanList = [seanPhone, seanTwitter];
    box.add(['Sean Gillen', seanList]);
    
  }

  // void initializeDatabase() async {

  //   final databaseContacts = openDatabase(
  //     join(await getDatabasesPath(), 'contacts_database.db'),
  //     // When the database is first created, create a table to store dogs.
  //     onCreate: (db, version) {
  //       return db.execute(
  //         "CREATE TABLE contacts(user_id TEXT PRIMARY KEY, name TEXT, multacc_id TEXT)",
  //       );
  //     },
      
  //     // version: 1,
  //   );

  //   final databaseItems = openDatabase(
  //     join(await getDatabasesPath(), 'items_database.db'),
      
  //     onCreate: (db, version) {
  //       return db.execute(
  //         "CREATE TABLE items(item_id TEXT PRIMARY KEY, type TEXT, data TEXT, user_id TEXT)",
  //       );
  //     },
      
  //     // version: 1,
  //   );
    
  // }


  
}

