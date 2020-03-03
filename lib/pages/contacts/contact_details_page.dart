import 'package:flutter/material.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:multacc/common/constants.dart';
import '../../common/constants.dart';
import 'contact_model.dart';
import 'contact_info.dart';
import 'contact_shortcut.dart';

class ContactDetailsPage extends StatefulWidget {
  final ContactModel contact;

  ContactDetailsPage(this.contact);

  @override
  _ContactDetailsPageState createState() => _ContactDetailsPageState(contact);
}

class _ContactDetailsPageState extends State<ContactDetailsPage> {
  final ContactModel contact;

  final kDefaultContactBackground = Color(0xFFFFEC5C);

  final kDefaultContactStyle = TextStyle(fontSize: 48, fontWeight: FontWeight.w300, fontFamily: 'Product Sans', color: Color(0xFF707070));

  final kContactProfileTextStyle = TextStyle(fontSize: 26, fontWeight: FontWeight.w600, fontFamily: 'Product Sans', color: Color(0xFFFFFFFF));

  _ContactDetailsPageState(this.contact);

  @override
  Widget build(BuildContext context) {
    FlutterStatusbarcolor.setNavigationBarColor(kPrimaryColor);
    return Padding(
      padding: const EdgeInsets.only(top: 55),
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(180.0),
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 130.0,
                width: MediaQuery.of(context).size.width,
                child: Column(
                  children: <Widget>[
                    Container(
                      child: Container(
                        child: Center(
                            child: Text(contact.displayName[0],
                                style: kDefaultContactStyle)),
                        decoration: BoxDecoration(
                          color: kDefaultContactBackground,
                          borderRadius:
                              BorderRadius.all(const Radius.circular(100.0)),
                        ),
                        height: 80,
                        width: 80,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(5.0),
                    ),
                    Text(contact.displayName, style: kContactProfileTextStyle),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  ContactShortcut(icon: Icons.phone),
                  ContactShortcut(icon: Icons.message),
                  ContactShortcut(icon: Icons.videocam),
                  ContactShortcut(icon: Icons.email),
                  ContactShortcut(icon: Icons.dashboard),
                ],
              ),
            ],
          ),
        ),
        body: ListView(
          children: <Widget>[
            ContactInfo(onPressed: () {}),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    FlutterStatusbarcolor.setNavigationBarColor(kBackgroundColorLight);
    super.dispose();
  }
}
