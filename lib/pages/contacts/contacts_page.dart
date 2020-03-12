import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:multacc/common/avatars.dart';
import 'package:multacc/common/theme.dart';
import 'package:multacc/main.dart';
import 'package:sliding_sheet/sliding_sheet.dart';
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
    final contact = contactsData.displayedContacts[index];
    return ListTile(
      contentPadding: EdgeInsets.all(6.0),
      leading: Avatars.buildContactAvatar(memoryImage: contact.avatar),
      title: Padding(padding: EdgeInsets.only(left: 8.0), child: Text(contact.displayName, style: kBodyTextStyle)),
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
        showSlidingBottomSheet(
          context,
          builder: (context) => SlidingSheetDialog(
            elevation: 8.0,
            cornerRadius: 16.0,
            color: kBackgroundColor,
            snapSpec: const SnapSpec(
              snap: true,
              snappings: [0.6, 1.0],
              positioning: SnapPositioning.relativeToAvailableSpace,
            ),
            builder: (context, state) => ContactDetailsPage(contactsData.displayedContacts[index]),
            headerBuilder: (_, __) => // drag handle
                Padding(padding: EdgeInsets.all(16.0), child: Icon(Icons.maximize, color: Colors.grey)),
          ),
        );
      }
    });
  }
}
