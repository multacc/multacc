import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:multacc/common/auth.dart';
import 'package:multacc/common/theme.dart';
import 'package:multacc/common/constants.dart';
import 'package:multacc/common/search_delegate.dart';
import 'package:multacc/pages/home_page.dart';
import 'package:multacc/pages/settings/settings_page.dart';

Auth _auth = Auth.instance;

/// MultaccBottomBar class containing the logic for FAB, account auth, etc
class MultaccBottomBar extends StatefulWidget {
  final User _user;

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
            Spacer(),
            IconButton(
              icon: Icon(Icons.search, color: Colors.grey),
              onPressed: () {
                showSearch(context: context, delegate: BottomBarSearchDelegate());
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
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(16.0), topRight: Radius.circular(16.0)),
      ),
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
                  leading: widget._user?.photoURL != null
                      ? CircleAvatar(backgroundImage: CachedNetworkImageProvider(widget._user.photoURL))
                      : CircleAvatar(child: Icon(Icons.person), foregroundColor: kBackgroundColorLight),
                  title: Text(widget._user?.displayName ?? 'Anonymous'),
                  subtitle: Text(widget._user?.email ?? 'You are not signed in',
                      style: kTinyTextStyle.copyWith(fontStyle: FontStyle.italic)),
                  children: [
                    _buildGroupmeTile(context),
                    ListTile(
                      leading: Icon(MaterialCommunityIcons.discord),
                      title: Text('Discord'), // @todo Add discord chats integration under accounts
                    ),
                    ListTile(
                      leading: Icon(widget._user.isAnonymous ? MaterialCommunityIcons.login : MaterialCommunityIcons.logout),
                      title: Text(widget._user.isAnonymous ? 'Sign in' : 'Sign out'),
                      onTap: () async {
                        widget._user.isAnonymous ? await _auth.linkWithGoogleSignIn() : await _auth.signOut();
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
                onTap: () async {
                  Navigator.of(context).pop();
                  await Navigator.of(context).push(MaterialPageRoute(builder: (_) => SettingsPage()));
                  await FlutterStatusbarcolor.setNavigationBarColor(kBackgroundColorLight);
                },
              ),
              ListTile(
                leading: Icon(Icons.security),
                title: Text('Privacy policy'),
                onTap: () => launch('https://multacc.com/privacy-policy'),
              ),
            ],
          ),
        );
      },
    );
  }

  // @todo Refactor groupme auth
  Widget _buildGroupmeTile(BuildContext context) {
    SharedPreferences prefs = GetIt.I.get<SharedPreferences>();
    final isGroupmeConnected = prefs.containsKey('GROUPME_TOKEN');

    return ListTile(
      leading: SvgPicture.asset('assets/groupme.svg', color: Colors.white, width: 25),
      title: Text('Groupme'),
      trailing: isGroupmeConnected ? Text('Connected ✔') : Text(''),
      onTap: () async {
        if (!isGroupmeConnected) {
          // redirect url used to authenticate user and get access token
          await launch(GROUPME_REDIRECT_URL);
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
