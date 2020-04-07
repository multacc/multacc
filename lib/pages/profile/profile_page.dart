import 'package:flutter/material.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:multacc/common/avatars.dart';
import 'package:multacc/common/theme.dart';
import 'package:multacc/items/item.dart';
import 'package:multacc/items/phone.dart';
<<<<<<< HEAD
import 'package:multacc/pages/contacts/contact_form_page.dart';
import 'package:multacc/database/contact_model.dart';
=======
import 'package:multacc/pages/contacts/contact_form.dart';
import 'package:multacc/pages/contacts/contact_model.dart';
>>>>>>> 1937f90e6b5187690050e5dc45b7f3f9d74acfa4

class ProfilePage extends StatefulWidget {
  final MultaccContact contact;

  ProfilePage(this.contact);

  @override
  _ProfilePageState createState() => _ProfilePageState(contact);
}

class _ProfilePageState extends State<ProfilePage> {
  MultaccContact contact;

  _ProfilePageState(this.contact);

  @override
  Widget build(BuildContext context) {
    FlutterStatusbarcolor.setNavigationBarColor(kBackgroundColor);

    return Container(
      child: Column(
        children: <Widget>[
          _buildHeader(),
          _buildName(),
          _buildContactItemsList(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(width: MediaQuery.of(context).size.width / 3),
        Container(
          width: MediaQuery.of(context).size.width / 3,
          child: Avatars.buildContactAvatar(
              memoryImage: contact.avatar, radius: 40.0),
        ),
        Container(
          width: MediaQuery.of(context).size.width / 3,
          child: IconButton(
            icon: Icon(Icons.edit, color: Colors.grey),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute<Null>(
                builder: (BuildContext context) {
<<<<<<< HEAD
                  return ContactFormPage(contact);
=======
                  return ContactForm(contact);
>>>>>>> 1937f90e6b5187690050e5dc45b7f3f9d74acfa4
                },
                fullscreenDialog: true
              ));
            },
          ),
        ),
      ],
    );
  }

  Widget _buildName() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Text(contact.displayName, style: GoogleFonts.lato(fontSize: 25)),
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
            trailing: Text(item.type == MultaccItemType.Phone
                ? (item as PhoneItem).label
                : ''),
            leading: item.icon,
            onTap: item.isLaunchable ? item.launchApp : null,
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    FlutterStatusbarcolor.setNavigationBarColor(kBackgroundColorLight);
    super.dispose();
  }
}
