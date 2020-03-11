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
import 'package:path_provider/path_provider.dart' as path_provider;
import 'items/email.dart';
import 'items/phone.dart';
import 'items/twitter.dart';


import 'package:hive/hive.dart';

GetIt services = GetIt.I;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // request contacts permission
  PermissionStatus permission = await PermissionHandler().checkPermissionStatus(PermissionGroup.contacts);
  if (permission != PermissionStatus.granted) await PermissionHandler().requestPermissions([PermissionGroup.contacts]);

  final appDocumentDir = await path_provider.getApplicationDocumentsDirectory();
  Hive.init(appDocumentDir.path);
  Hive.registerAdapter(PhoneItemAdapter());
  Hive.registerAdapter(EmailItemAdapter());
  Hive.registerAdapter(TwitterItemAdapter());

  print('\n\n\nTHIS IS WHERE THINGS SHOULD PRINT\n\n\n');

  runApp(MyApp());

  // fetch and save contacts list
  final contactsData = ContactsData();
  services.registerSingleton(contactsData);
  await contactsData.getAllContacts();

  // initialize local database

  final contactsBox = await Hive.openBox('contacts');
  // Hive.registerAdapter(ContactsAdapter());

  DatabaseInterface dbi = DatabaseInterface(box: contactsBox);
  // dbi.initializeDatabase();
  dbi.addDummyContacts();

  dbi.printContact('Sean_Gillen_7777');

  dbi.addContact('David_Hall_8631');
  MultaccItem it = new MultaccItem.fromDB("asda", jsonDecode('{\"_t\": \"Email\", \"email\": \"dwhall1@crimson.ua.edu\"}'));
  dbi.addItem('David_Hall_8631', it);

  dbi.printContact('David_Hall_8631');
  
  

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
