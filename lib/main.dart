import 'package:flutter/material.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:multacc/common/theme.dart';
import 'package:multacc/pages/home_page.dart';
import 'package:multacc/pages/contacts/contacts_data.dart';
import 'package:multacc/pages/chats/chats_data.dart';
import 'package:multacc/database/database_interface.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // request contacts permission
  while (!await Permission.contacts.request().isGranted) {}

  // set status/nav bar colors before starting app
  await FlutterStatusbarcolor.setStatusBarColor(kBackgroundColor);
  await FlutterStatusbarcolor.setNavigationBarColor(kBackgroundColorLight);

  // save shared prefs as a singleton for non-async access (might replace with a hive box)
  SharedPreferences prefs = await SharedPreferences.getInstance();
  GetIt.I.registerSingleton(prefs);

  // initialize local database
  DatabaseInterface db = DatabaseInterface();
  GetIt.I.registerSingleton(db);
  await db.init();

  runApp(MyApp());

  // fetch and save contacts list
  final contactsData = ContactsData();
  GetIt.I.registerSingleton(contactsData);
  contactsData.getAllContacts();

  // fetch groupme messages in background if authorized
  final chatsData = ChatsData();
  GetIt.I.registerSingleton(chatsData);
  if (prefs.containsKey('GROUPME_TOKEN')) {
    chatsData.getAllChats(groupmeToken: prefs.getString('GROUPME_TOKEN'));
  }
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
