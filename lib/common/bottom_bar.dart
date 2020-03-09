import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_brand_icons/flutter_brand_icons.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:multacc/common/constants.dart';
import 'package:multacc/pages/home_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

FirebaseAuth _auth = FirebaseAuth.instance;

/// MultaccBottomBar class containing the logic for FAB, account auth, etc
class MultaccBottomBar extends StatefulWidget {
  final FirebaseUser _user;

  MultaccBottomBar(this._user);

  @override
  MultaccBottomBarState createState() => MultaccBottomBarState();
}

class MultaccBottomBarState extends State<MultaccBottomBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: kBottomNavigationBarHeight,
      child: BottomAppBar(
        shape: CircularNotchedRectangle(),
        notchMargin: 8.0,
        elevation: 8.0,
        color: kBackgroundColorLight,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.menu, color: Colors.grey),
              onPressed: () async {
                FlutterStatusbarcolor.setNavigationBarColor(kBackgroundColor);
                await showNavigationSheet(context);
                FlutterStatusbarcolor.setNavigationBarColor(kBackgroundColorLight);
              },
            ),
            IconButton(
              icon: Icon(Icons.more_vert, color: Colors.grey),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }

  Future showNavigationSheet(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Theme(
                data: Theme.of(context).copyWith(accentColor: Colors.white),
                child: ExpansionTile(
                  leading: CircleAvatar(backgroundImage: NetworkImage(widget._user.photoUrl)),
                  title: Text(widget._user.displayName),
                  subtitle: Text(widget._user.email),
                  children: [
                    _buildGroupmeTile(context),
                    ListTile(
                      leading: Icon(BrandIcons.discord),
                      title: Text('Discord'), // @todo Add discord chats integration under accounts
                    ),
                    ListTile(
                      leading: Icon(Icons.power_settings_new),
                      title: Text('Sign out'),
                      onTap: () async {
                        await _auth.signOut();
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              ),
              Divider(),
              ListTile(
                leading: Icon(Icons.settings),
                title: Text('Settings'),
                onTap: () {},
              ),
              ListTile(
                leading: Icon(Icons.security),
                title: Text('Privacy policy'),
                onTap: () {},
              ),
            ],
          ),
        );
      },
    );
  }

  // @todo Refactor groupme auth
  Widget _buildGroupmeTile(BuildContext context) {
    return ListTile(
      leading: SvgPicture.asset('assets/groupme.svg', color: Colors.white, width: 25),
      title: Text('Groupme'),
      onTap: () async {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        if (!prefs.containsKey('GROUPME_TOKEN')) {
          // redirect url used to authenticate user and get access token
          await launch('https://oauth.groupme.com/oauth/authorize?client_id=qUSMuMym9ticy1pCtC0LqRXXgIzEHzAWuYfJq3DlaV7HaCKh');
        } else {
          globalScaffoldKey.currentState.showSnackBar(SnackBar(
            content: Text(
              'Groupme account already linked 🎉',
              textAlign: TextAlign.center,
              style: kBodyTextStyle.copyWith(color: Colors.white),
            ),
            backgroundColor: kBackgroundColorLight,
          ));
        }
        Navigator.pop(context);
      },
    );
  }
}
