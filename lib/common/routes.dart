import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:multacc/pages/chats_page.dart';
import 'package:multacc/pages/contacts/contacts_page.dart';
import 'package:multacc/pages/profile_page.dart';
import 'package:multacc/pages/settings_page.dart';

class Routes with ChangeNotifier {
  static final allRoutes = [
    RouteData(
      'Contacts',
      '/',
      (context) => ContactsPage(),
      [IconButton(icon: Icon(Icons.search), onPressed: () { /* TODO */ },)],
    ),
    RouteData(
      'Chats',
      '/chats',
      (context) => ChatsPage(),
      null,
    ),
    RouteData(
      'Profile',
      '/profile',
      (context) => ProfilePage(),
      null,
    ),
    RouteData(
      'Settings',
      '/settings',
      (context) => SettingsPage(),
      null,
    ),
  ];

  RouteData _currentRoute = allRoutes[0];
  RouteData get currentRoute => _currentRoute;
  set currentRoute(RouteData route) {
    _currentRoute = route;
    notifyListeners();
  }

  // index of the bottombar tab
  bool changeRoute(index) {
    if (allRoutes[index] != currentRoute) {
      currentRoute = allRoutes[index];
      return true;
    }
    return false;
  }
}

class RouteData {
  String title;
  String path;
  WidgetBuilder builder;
  List<Widget> actions;

  RouteData(this.title, this.path, this.builder, this.actions);
}
