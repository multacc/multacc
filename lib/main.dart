import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:multacc/items/item.dart';
import 'package:multacc/pages/chats/chats_data.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'common/constants.dart';

import 'database/database_interface.dart';

import 'pages/home_page.dart';
import 'pages/contacts/contacts_data.dart';

import 'package:hive/hive.dart';

GetIt services = GetIt.I;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // final dbName = "Multacc_Database.db";

  // request contacts permission
  PermissionStatus permission = await PermissionHandler().checkPermissionStatus(PermissionGroup.contacts);
  if (permission != PermissionStatus.granted) await PermissionHandler().requestPermissions([PermissionGroup.contacts]);

  runApp(MyApp());

  // fetch and save contacts list
  final contactsData = ContactsData();
  services.registerSingleton(contactsData);
  await contactsData.getAllContacts();

  // initialize local database

  final contactsBox = await Hive.openBox('contacts');

  DatabaseInterface db = DatabaseInterface(box: contactsBox);
  // db.initializeDatabase();
  db.addDummyContacts();

  db.print('Sean_Gillen_7777');

  db.addContact('David_Hall_8631');
  MultaccItem it = new MultaccItem.fromDB("asda", jsonDecode('{\"type\": 7, \"email\": \"dwhall1@crimson.ua.edu\"}'));
  db.addItem('David_Hall_8631', it);

  db.print('David_Hall_8631');
  

  // fetch groupme messages in background if authorized
  final chatsData = ChatsData();
  services.registerSingleton(chatsData);
  SharedPreferences prefs = await SharedPreferences.getInstance();
  if (prefs.containsKey('GROUPME_TOKEN')) {
    chatsData.getAllChats(prefs.getString('GROUPME_TOKEN')); // run in background
  }

  await FlutterStatusbarcolor.setStatusBarColor(kBackgroundColor);
  await FlutterStatusbarcolor.setNavigationBarColor(kBackgroundColorLight);
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Multacc',
      theme: ThemeData.dark().copyWith(
        primaryColor: kPrimaryColor,
        accentColor: kPrimaryColorDark,
        appBarTheme: AppBarTheme.of(context).copyWith(elevation: 0, color: kBackgroundColor),
        textTheme: GoogleFonts.openSansTextTheme(ThemeData.dark().textTheme),
      ),
      home: HomePage(),
    );
  }
}
