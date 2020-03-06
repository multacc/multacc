import 'package:flutter/material.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../common/constants.dart';
import 'contact_model.dart';
import 'contact_shortcut.dart';

class ContactDetailsPage extends StatefulWidget {
  final MultaccContact contact;

  ContactDetailsPage(this.contact);

  @override
  _ContactDetailsPageState createState() => _ContactDetailsPageState(contact);
}

class _ContactDetailsPageState extends State<ContactDetailsPage> {
  final MultaccContact contact;

  _ContactDetailsPageState(this.contact);

  @override
  Widget build(BuildContext context) {
    FlutterStatusbarcolor.setNavigationBarColor(kBackgroundColor);

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.7,
      maxChildSize: 0.99,
      builder: (context, scrollController) => SingleChildScrollView(
        controller: scrollController,
        child: Container(
          color: kBackgroundColor,
          child: Column(
            children: <Widget>[
              _buildDragHandle(),
              _buildCircleAvatar(),
              _buildName(),
              _buildShortcutsRow(),
              _buildContactItemsList()
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContactItemsList() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: ListView.separated(
        shrinkWrap: true,
          itemCount: contact.phones.length,
          separatorBuilder: (BuildContext context, int index) => Divider(),
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
              title: Text(contact.phones.elementAt(index).value),
              trailing: Text(contact.phones.elementAt(index).label),
              leading: Icon(Icons.phone),
            );
          }),
    );
  }

  Padding _buildShortcutsRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          ContactShortcut(icon: Icons.phone),
          ContactShortcut(icon: Icons.message),
          ContactShortcut(icon: Icons.videocam),
          ContactShortcut(icon: Icons.email),
          ContactShortcut(icon: Icons.dashboard),
        ],
      ),
    );
  }

  Padding _buildDragHandle() => Padding(padding: const EdgeInsets.all(8.0), child: Icon(Icons.maximize));

  Padding _buildName() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Text(contact.displayName, style: GoogleFonts.lato(fontSize: 25)),
    );
  }

  CircleAvatar _buildCircleAvatar() {
    return CircleAvatar(
      radius: 40,
      backgroundColor: kPrimaryColor,
      child: Text(
        contact.displayName[0],
        style: GoogleFonts.lato(fontSize: 35),
      ),
    );
  }

  @override
  void dispose() {
    FlutterStatusbarcolor.setNavigationBarColor(kBackgroundColorLight);
    super.dispose();
  }
}
