import 'package:flutter/material.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:permission_handler/permission_handler.dart';

import 'common/constants.dart';

import 'database/database_interface.dart';

import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

import 'pages/home_page.dart';
import 'pages/contacts/contacts_data.dart';

GetIt services = GetIt.I;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // final dbName = "Multacc_Database.db";

  // request contacts permission
  PermissionStatus permission = await PermissionHandler().checkPermissionStatus(PermissionGroup.contacts);
  if (permission != PermissionStatus.granted) await PermissionHandler().requestPermissions([PermissionGroup.contacts]);

  final appDocumentDirectory = await path_provider.getApplicationDocumentsDirectory();
  Hive.init(appDocumentDirectory.path);
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
