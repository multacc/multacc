import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:provider/provider.dart';

import 'common/constants.dart';
import 'common/routes.dart';

void main() async {
  runApp(MyApp());

  await FlutterStatusbarcolor.setStatusBarColor(kPrimaryColor);
  await FlutterStatusbarcolor.setNavigationBarColor(kPrimaryColorLight);
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
          color: kPrimaryColor,
        ),
        primaryColor: kPrimaryColor,
        primaryColorLight: kPrimaryColorLight,
        accentColor: kSecondaryColor,
        scaffoldBackgroundColor: kPrimaryColor,
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
    return Consumer<Routes>(
      builder: (BuildContext context, routes, Widget child) {
        return Scaffold(
          appBar: AppBar(
            title: Center(
                child:
                    Text(routes.currentRoute.title, style: kHeaderTextStyle)),
          ),
          body: WillPopScope(
            onWillPop: () async {
              if (_navigatorKey.currentState.canPop()) {
                _navigatorKey.currentState.pop();
                return false;
              }
              return true;
            },
            child: Navigator(
                key: _navigatorKey,
                initialRoute: '/',
                onGenerateRoute: (RouteSettings settings) {
                  return MaterialPageRoute(
                    builder: routes.currentRoute.builder,
                    settings: settings,
                  );
                }),
          ),
          bottomNavigationBar: CurvedNavigationBar(
            height: 60,
            animationCurve: Curves.easeInCirc,
            animationDuration: Duration(milliseconds: 300),
            backgroundColor: kPrimaryColor,
            buttonBackgroundColor: kPrimaryColorLight,
            color: kPrimaryColorLight,
            items: <Widget>[
              Icon(Icons.people, size: 30),
              Icon(Icons.message, size: 30),
              Icon(Icons.person, size: 30),
              Icon(Icons.settings, size: 30),
            ],
            onTap: (index) {
              if (routes.changeRoute(index))
                _navigatorKey.currentState.pushNamed(routes.currentRoute.title);
            },
          ),
        );
      },
    );
  }
}
