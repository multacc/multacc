import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';

import 'package:multacc/common/avatars.dart';
import 'package:multacc/common/theme.dart';
import 'package:multacc/items/email.dart';
import 'package:multacc/items/facebook.dart';
import 'package:multacc/items/instagram.dart';
import 'package:multacc/items/item.dart';
import 'package:multacc/items/phone.dart';
import 'package:multacc/database/contact_model.dart';

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

    return Material(
      child: Container(
        height: MediaQuery.of(context).size.height / 1.2, // @todo Fix ContactDetails height for scrolling
        child: Column(
          children: <Widget>[
            Avatars.buildContactAvatar(memoryImage: contact.avatar, radius: 40.0),
            _buildName(),
            // _buildShortcutsRow(),
            _buildContactItemsList(),
          ],
        ),
      ),
    );
  }

  Widget _buildContactItemsList() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: ListView.separated(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: contact.multaccItems.length,
        separatorBuilder: (BuildContext context, int index) => Divider(),
        itemBuilder: (BuildContext context, int index) {
          final item = contact.multaccItems.elementAt(index);
          return ListTile(
            title: Text(item.humanReadableValue ?? ''),
            trailing: _buildTrailing(item),
            leading: item.icon,
            onTap: item.isLaunchable ? item.launchApp : null,
          );
        },
      ),
    );
  }

  // @todo Fix the terrible contact shortcuts row
  Widget _buildShortcutsRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          _buildContactShortCut(icon: Icons.phone),
          _buildContactShortCut(icon: Icons.message),
          _buildContactShortCut(icon: Icons.videocam),
          _buildContactShortCut(icon: Icons.email),
          _buildContactShortCut(icon: Icons.dashboard),
        ],
      ),
    );
  }

  Widget _buildContactShortCut({IconData icon}) {
    return SizedBox.fromSize(
      size: Size(40, 40),
      child: ClipOval(
        child: Material(
          color: kBackgroundColorLight,
          child: InkWell(
            onTap: () {},
            child: Icon(icon, size: 25),
          ),
        ),
      ),
    );
  }

  Widget _buildName() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Text(contact.name, style: kHeaderTextStyle),
    );
  }

  Widget _buildTrailing(MultaccItem item) {
    switch (item.type) {
      case MultaccItemType.Phone:
        return Text((item as PhoneItem).label);
      case MultaccItemType.Email:
        return Text((item as EmailItem).label);
      case MultaccItemType.Facebook:
        return IconButton(
          icon: Icon(MaterialCommunityIcons.facebook_messenger),
          onPressed: () => (item as FacebookItem).launchMessenger(),
        );
      case MultaccItemType.Instagram:
        return IconButton(
          icon: Icon(SimpleLineIcons.paper_plane),
          onPressed: () => (item as InstagramItem).launchDirectMessage(),
        );
      default:
        return Text('');
    }
  }

  @override
  void dispose() {
    FlutterStatusbarcolor.setNavigationBarColor(kBackgroundColorLight);
    super.dispose();
  }
}
