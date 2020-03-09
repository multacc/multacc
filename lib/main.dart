import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:multacc/pages/chats/chats_data.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'common/constants.dart';

import 'pages/home_page.dart';
import 'pages/contacts/contacts_data.dart';

GetIt services = GetIt.I;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // request contacts permission
  PermissionStatus permission = await PermissionHandler().checkPermissionStatus(PermissionGroup.contacts);
  if (permission != PermissionStatus.granted) await PermissionHandler().requestPermissions([PermissionGroup.contacts, PermissionGroup.sms]);

  runApp(MyApp());

  // fetch and save contacts list
  final contactsData = ContactsData();
  services.registerSingleton(contactsData);
  await contactsData.getAllContacts();

  // fetch groupme messages in background
  final chatsData = ChatsData();
  services.registerSingleton(chatsData);
  String groupmeToken = (await SharedPreferences.getInstance()).getString('GROUPME_TOKEN');
  chatsData.getAllChats(groupmeToken); // run in background

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
