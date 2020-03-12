import 'package:flutter/material.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:multacc/pages/chats/chats_data.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:multacc/common/theme.dart';
import 'package:multacc/pages/home_page.dart';
import 'package:multacc/pages/contacts/contacts_data.dart';

import 'database/database_interface.dart';

import 'pages/home_page.dart';
import 'pages/contacts/contacts_data.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

import 'package:hive/hive.dart';

GetIt services = GetIt.I;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // request contacts permission
  PermissionStatus permission = await PermissionHandler().checkPermissionStatus(PermissionGroup.contacts);
  if (permission != PermissionStatus.granted) await PermissionHandler().requestPermissions([PermissionGroup.contacts]);

  final appDocumentDir = await path_provider.getApplicationDocumentsDirectory();
  Hive.init(appDocumentDir.path);


  runApp(MyApp());

  // save shared prefs as a singleton for non-async access (might replace with a hive box)
  SharedPreferences prefs = await SharedPreferences.getInstance();
  services.registerSingleton(prefs);

  // fetch and save contacts list
  final contactsData = ContactsData();
  services.registerSingleton(contactsData);
  await contactsData.getAllContacts();

  // initialize local database
  final contactsBox = await Hive.openBox('contacts');
  DatabaseInterface dbi = DatabaseInterface(box: contactsBox);
  dbi.addDummyContacts(); // @todo Remove dummy contacts when database is known to work

  // fetch groupme messages in background if authorized
  final chatsData = ChatsData();
  services.registerSingleton(chatsData);
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
