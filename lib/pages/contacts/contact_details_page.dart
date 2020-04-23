import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:get_it/get_it.dart';

import 'package:multacc/common/avatars.dart';
import 'package:multacc/common/theme.dart';
import 'package:multacc/items/email.dart';
import 'package:multacc/items/facebook.dart';
import 'package:multacc/items/item.dart';
import 'package:multacc/items/phone.dart';
import 'package:multacc/database/contact_model.dart';
import 'package:multacc/pages/contacts/contact_form_page.dart';
import 'package:multacc/pages/contacts/contacts_data.dart';

class ContactDetailsPage extends StatefulWidget {
  final MultaccContact contact;
  final bool withoutScaffold;
  final bool isProfile;

  ContactDetailsPage(this.contact, {this.withoutScaffold = false, this.isProfile = false});

  @override
  _ContactDetailsPageState createState() => _ContactDetailsPageState(contact);
}

class _ContactDetailsPageState extends State<ContactDetailsPage> {
  final MultaccContact contact;
  Widget phoneShortcut;
  Widget emailShortcut;

  _ContactDetailsPageState(this.contact);

  @override
  void initState() {
    super.initState();
    contact.multaccItems.forEach((item) {
      switch (item.type) {
        case MultaccItemType.Phone:
          phoneShortcut = _buildShortcutIcon(Icons.phone, "Call", () => (item as PhoneItem).launchApp());
          break;
        case MultaccItemType.Email:
          emailShortcut = _buildShortcutIcon(Icons.email, "Email", () => (item as EmailItem).launchApp());
          break;
        default:
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.withoutScaffold
        ? _showBody()
        : Scaffold(
            appBar: AppBar(
              actions: <Widget>[
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () => _deleteContact(contact),
                ),
              ],
            ),
            body: _showBody(),
            floatingActionButton: FloatingActionButton(
              child: Icon(Icons.edit),
              backgroundColor: kPrimaryColor,
              onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                fullscreenDialog: true,
                builder: (context) => ContactFormPage(contact: contact),
              )),
            ),
          );
  }

  Container _showBody() {
    return Container(
      child: Column(
        children: <Widget>[
          Avatars.buildContactAvatar(memoryImage: contact.avatar, radius: 40.0),
          _buildName(),
          if (!widget.isProfile) _buildShortcutsRow(),
          _buildContactItemsList(),
        ],
      ),
    );
  }

  void _deleteContact(MultaccContact contact) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        title: Text('Delete this contact?'),
        content: Text('${contact.displayName} will be permanently removed'),
        actions: <Widget>[
          FlatButton(child: Text('Cancel'), onPressed: () => Navigator.of(context).pop()),
          FlatButton(
            child: Text('Delete'),
            onPressed: () {
              GetIt.I.get<ContactsData>().deleteContact(contact);
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
          )
        ],
      ),
    );
  }

  Widget _buildContactItemsList() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
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

  Widget _buildShortcutsRow() {
    return Container(
      height: 70,
      decoration: BoxDecoration(
        border: Border.symmetric(vertical: BorderSide(width: 1, color: Colors.grey[800]))
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          phoneShortcut != null ? phoneShortcut : _buildShortcutIcon(Icons.phone, "Call", () {}, disabled: true),
          _buildShortcutIcon(Icons.message, "Text", () {}, disabled: true),
          emailShortcut != null ? emailShortcut : _buildShortcutIcon(Icons.email, "Email", () {}, disabled: true),
        ],
      ),
    );
  }

  Widget _buildShortcutIcon(IconData icon, String helperText, Function ontap, {bool disabled = false}) {
    return InkWell(
      borderRadius: BorderRadius.circular(50),
      onTap: ontap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(padding: EdgeInsets.only(bottom: 3), child: Icon(icon, color: disabled ? Colors.grey[600] : Colors.white),),
          Text(helperText, style: TextStyle(fontSize: 12, color: disabled ? Colors.grey[600] : Colors.white)),
          SizedBox(width: 50)
        ]
      )
    );
  }

  Widget _buildName() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Text(contact.name, style: kHeaderTextStyle),
    );
  }

  // @todo Refactor trailing button logic
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
