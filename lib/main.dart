import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:multacc/common/constants.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:multacc/common/theme.dart';
import 'package:multacc/pages/home_page.dart';
import 'package:multacc/pages/contacts/contacts_data.dart';
import 'package:multacc/pages/chats/chats_data.dart';
import 'package:multacc/database/database_interface.dart';
import 'package:workmanager/workmanager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Workmanager.initialize(callbackDispatcher, isInDebugMode: true);

  // @todo Also set up iOS notifications
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  final initializationSettingsAndroid = AndroidInitializationSettings('launcher_icon');
  // final initializationSettingsIOS = IOSInitializationSettings( onDidReceiveLocalNotification: onDidReceiveLocalNotification);
  final initializationSettings = InitializationSettings(initializationSettingsAndroid, null);
  GetIt.I.registerSingleton(flutterLocalNotificationsPlugin);

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
    Workmanager.registerPeriodicTask(GROUPME_BACKGROUND_TASK, GROUPME_BACKGROUND_TASK);
  }
}

void callbackDispatcher() {
  Workmanager.executeTask((task, input) async {
    switch (task) {
      case Workmanager.iOSBackgroundTask:
      case GROUPME_BACKGROUND_TASK:
        final chatsData = GetIt.I.get<ChatsData>();
        final localNotificationsPlugin = GetIt.I.get<FlutterLocalNotificationsPlugin>();

        // compare against existing chats and send local push notifications for new messages
        final oldChats = chatsData.allChats;
        final updatedChats = await chatsData.getAllChats();
        updatedChats
            .sublist(0, updatedChats.indexWhere((chat) => chat.timestamp <= oldChats.first.timestamp))
            .forEach((chat) {
          localNotificationsPlugin.show(
            DateTime.now().millisecondsSinceEpoch,
            chat.name,
            chat.lastMessage,
            NotificationDetails(GROUPME_ANDROID_NOTIFICATION_DETAILS, null),
          );
        });
        break;
    }
    return true;
  });
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
