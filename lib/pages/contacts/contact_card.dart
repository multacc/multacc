import 'package:flutter/material.dart';
import 'package:multacc/common/constants.dart';
import 'package:multacc/main.dart';
import 'contact_details_page.dart';
import 'contact_model.dart';
import 'contacts_data.dart';

class ContactCard extends StatefulWidget {
  final ContactModel contact;

  ContactCard(this.contact);

  @override
  _ContactCardState createState() => _ContactCardState();
}

class _ContactCardState extends State<ContactCard> {
  ContactsData contactsData;

  @override
  void initState() {
    contactsData = services.get<ContactsData>();
    super.initState();
  }

  onContactPressed() {
    setState(() {
      if (widget.contact.isSelected) {
        widget.contact.isSelected = false;
      } else if (contactsData.displayedContacts.any((e) => e.isSelected)) {
        widget.contact.isSelected = true;
      } else {
        showModalBottomSheet(
          context: context,
          builder: (_) => ContactDetailsPage(),
          useRootNavigator: true,
          isScrollControlled:true,
          // backgroundColor: kPrimaryColor
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(left: 8.0),
      child: FlatButton(
        onPressed: onContactPressed,
        onLongPress: () => setState(() {
          widget.contact.isSelected = !widget.contact.isSelected;
        }),
        color: widget.contact.isSelected ? Colors.white12 : Theme.of(context).scaffoldBackgroundColor,
        child: Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 9.0),
              child: CircleAvatar(
                child: Icon(
                  Icons.person,
                  color: Colors.white,
                ),
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: Text(widget.contact.displayName, style: kContactListTextStyle),
            ),
          ],
        ),
      ),
    );
  }
}
