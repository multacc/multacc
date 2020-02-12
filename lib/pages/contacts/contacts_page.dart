import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:multacc/main.dart';
import 'contact_card.dart';
import 'contacts_data.dart';

class ContactsPage extends StatefulWidget {
  @override
  _ContactsPageState createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage> {
  ContactsData contactsData;

  @override
  void initState() {
    contactsData = services.get<ContactsData>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 12.0),
      child: Observer(
        builder: (_) => contactsData.loaded
            ? ListView(children: contactsData.displayedContacts.map((e) => ContactCard(e)).toList())
            : Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
