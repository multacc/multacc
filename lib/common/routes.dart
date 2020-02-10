import 'package:flutter/cupertino.dart';
import 'package:multacc/pages/chats_page.dart';
import 'package:multacc/pages/contacts_page.dart';
import 'package:multacc/pages/profile_page.dart';
import 'package:multacc/pages/settings_page.dart';

class Routes with ChangeNotifier {
  static final allRoutes = [
    RouteData('Contacts', '/', (context) => ContactsPage()),
    RouteData('Chats', '/chats', (context) => ChatsPage()),
    RouteData('Profile', '/profile', (context) => ProfilePage()),
    RouteData('Settings', '/settings', (context) => SettingsPage()),
  ];

  RouteData _currentRoute = allRoutes[0];
  get currentRoute => _currentRoute;
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

  RouteData(this.title, this.path, this.builder);
}
