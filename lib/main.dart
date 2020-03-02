import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:get_it/get_it.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import 'common/constants.dart';
import 'common/routes.dart';
import 'pages/contacts/contacts_data.dart';

GetIt services = GetIt.I;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // request contacts permission
  PermissionStatus permission = await PermissionHandler().checkPermissionStatus(PermissionGroup.contacts);
  if (permission != PermissionStatus.granted) await PermissionHandler().requestPermissions([PermissionGroup.contacts]);

  runApp(MyApp());
  
  // fetch and save contacts list
  final contactsData = ContactsData();
  services.registerSingleton(contactsData);
  await contactsData.getAllContacts();

  await FlutterStatusbarcolor.setStatusBarColor(kBackgroundColor);
  await FlutterStatusbarcolor.setNavigationBarColor(kBackgroundColor);
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Multacc',
      theme: ThemeData.dark().copyWith(
        appBarTheme: AppBarTheme.of(context).copyWith(
          elevation: 0,
          color: kBackgroundColor,
        ),
        primaryColor: kPrimaryColor,
        accentColor: kPrimaryColorDark,
      ),
      home: ChangeNotifierProvider(
        create: (context) => Routes(),
        child: HomePage(),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  final _navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Consumer<Routes>(
        builder: (BuildContext context, routes, Widget child) {
          return Scaffold(
            appBar: AppBar(
              actions: routes.currentRoute.actions,
              centerTitle: true,
              title: Text(
                routes.currentRoute.title,
                style: kHeaderTextStyle,
              ),
            ),
            body: Navigator(
              key: _navigatorKey,
              initialRoute: '/',
              onGenerateRoute: (RouteSettings settings) {
                return MaterialPageRoute(
                  builder: routes.currentRoute.builder,
                  settings: settings,
                );
              },
            ),
            bottomNavigationBar: CurvedNavigationBar(
              height: 60,
              animationCurve: Curves.decelerate,
              animationDuration: Duration(milliseconds: 350),
              backgroundColor: kBackgroundColor,
              // buttonBackgroundColor: kPrimaryColorDark,
              color: kPrimaryColor,
              items: <Widget>[
                Icon(Icons.people, size: 30),
                Icon(Icons.message, size: 30),
                Icon(Icons.person, size: 30),
                Icon(Icons.settings, size: 30),
              ],
              onTap: (index) {
                if (routes.changeRoute(index)) _navigatorKey.currentState.pushNamed(routes.currentRoute.title);
              },
            ),
          );
        },
      ),
    );
  }
}
