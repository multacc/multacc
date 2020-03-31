import 'package:flutter/material.dart';
import 'package:flutter_package_manager/flutter_package_manager.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:multacc/common/constants.dart';
import 'package:multacc/common/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatefulWidget {
  SettingsPage() {
    FlutterStatusbarcolor.setNavigationBarColor(kBackgroundColor);
  }

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  SharedPreferences prefs;

  @override
  void initState() {
    super.initState();
    prefs = GetIt.I.get<SharedPreferences>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Settings', style: GoogleFonts.lato(textStyle: kTabBarTextStyle)), centerTitle: true),
      backgroundColor: kBackgroundColor,
      body: Container(
        margin: EdgeInsets.all(8.0),
        width: double.infinity,
        child: Column(
          children: <Widget>[
            _buildPhoneAppTile(context),
            // @todo Add setting for redirecting calls to preferred dialer through multacc
          ],
        ),
      ),
    );
  }

  // @todo Implement iOS version of choosing preferred phone app
  Widget _buildPhoneAppTile(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(accentColor: Colors.white),
      child: FutureBuilder(
        future: Future.wait([
          FlutterPackageManager.getPackageInfo(ANDROID_DIALER_PACKAGE),
          FlutterPackageManager.getPackageInfo(GOOGLE_VOICE_PACKAGE),
          FlutterPackageManager.getPackageInfo(GOOGLE_DUO_PACKAGE)
        ]),
        builder: (context, AsyncSnapshot<List<PackageInfo>> snapshot) => ExpansionTile(
          title: Text('Phone app'),
          children: <Widget>[
            RadioListTile(
              secondary: snapshot.data?.first?.getAppIcon() ?? Icon(Icons.phone),
              title: Text('Default'),
              value: 'default',
              controlAffinity: ListTileControlAffinity.trailing,
              groupValue: prefs.getString('PHONE_APP') ?? 'default',
              onChanged: _changePhoneApp,
            ),
            // Google Voice tile
            if (snapshot.data?.elementAt(1) != null)
              RadioListTile(
                secondary: snapshot.data[1].getAppIcon(),
                title: Text('Google Voice'),
                value: 'voice',
                controlAffinity: ListTileControlAffinity.trailing,
                groupValue: prefs.getString('PHONE_APP'),
                onChanged: _changePhoneApp,
              ),
            // Google Duo tile
            if (snapshot.data?.last != null)
              RadioListTile(
                secondary: snapshot.data.last.getAppIcon(),
                title: Text('Google Duo'),
                value: 'duo',
                controlAffinity: ListTileControlAffinity.trailing,
                groupValue: prefs.getString('PHONE_APP'),
                onChanged: _changePhoneApp,
              ),
          ],
        ),
      ),
    );
  }

  void _changePhoneApp(String value) {
    setState(() {
      prefs.setString('PHONE_APP', value);
    });
  }
}
