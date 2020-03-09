import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:multacc/common/constants.dart';
import 'package:multacc/main.dart';
import 'contact_details_page.dart';
import 'contacts_data.dart';

class ContactsPage extends StatefulWidget {
  @override
  _ContactsPageState createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage> {
  ContactsData contactsData;
  List<int> selectedContacts;

  @override
  void initState() {
    super.initState();
    contactsData = services.get<ContactsData>();
    selectedContacts = List<int>();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 12.0),
      child: Observer(
        builder: (_) => !contactsData.loaded ? Center(child: CircularProgressIndicator()) : _buildContactsList(),
      ),
    );
  }

  Widget _buildContactsList() {
    return Observer(
      builder: (_) => ListTileTheme(
        selectedColor: kPrimaryColor,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView.builder(
            itemCount: contactsData.displayedContacts.length,
            itemBuilder: (context, index) => _buildContactListItem(index),
          ),
        ),
      ),
    );
  }

  ListTile _buildContactListItem(int index) {
    return ListTile(
      contentPadding: EdgeInsets.all(6.0),
      leading: CircleAvatar(child: Icon(Icons.person)),
      title: Text(contactsData.displayedContacts[index].displayName),
      onTap: () => _onContactPressed(index),
      onLongPress: () => _onLongPress(index),
      selected: _isSelected(index),
    );
  }

  bool _isSelected(int index) => selectedContacts.any((e) => e == index);

  void _onLongPress(int index) {
    if (!_isSelected(index)) {
      setState(() {
        selectedContacts.add(index);
      });
    }
  }

  void _onContactPressed(int index) {
    setState(() {
      if (_isSelected(index)) {
        selectedContacts.remove(index);
      } else if (selectedContacts.length > 0) {
        selectedContacts.add(index);
      } else {
        showModalBottomSheet(
          context: context,
          builder: (_) => ContactDetailsPage(contactsData.displayedContacts[index]),
          useRootNavigator: true,
          isScrollControlled: true,
          isDismissible: true,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        );
      }
    });
  }
}
