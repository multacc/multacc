import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:multacc/common/avatars.dart';
import 'package:multacc/common/theme.dart';
import 'package:multacc/database/contact_model.dart';
import 'package:multacc/pages/contacts/contact_form_page.dart';
import 'contact_details_page.dart';
import 'contacts_data.dart';

class ContactsPage extends StatefulWidget {
  @override
  _ContactsPageState createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage> with WidgetsBindingObserver {
  ContactsData contactsData;
  List<int> selectedContacts;

  @override
  void initState() {
    super.initState();
    contactsData = GetIt.I.get<ContactsData>();
    selectedContacts = List<int>();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) {
        contactsData.allContacts.sort((a, b) => a.name.compareTo(b.name));
        return ListTileTheme(
          selectedColor: kPrimaryColor,
          child: LiquidPullToRefresh(
            springAnimationDurationInMilliseconds: 300,
            color: kBackgroundColorLight,
            backgroundColor: kPrimaryColor,
            onRefresh: contactsData.getAllContacts,
            showChildOpacityTransition: false,
            child: ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
              itemCount: contactsData.allContacts.length,
              itemBuilder: (context, index) => _buildContactListItem(index),
            ),
          ),
        );
      },
    );
  }

  ListTile _buildContactListItem(int index) {
    final contact = contactsData.allContacts[index];
    return ListTile(
      contentPadding: EdgeInsets.all(6.0),
      leading: Avatars.buildContactAvatar(memoryImage: contact.avatar),
      title: Padding(padding: EdgeInsets.only(left: 8.0), child: Text(contact.name, style: kBodyTextStyle)),
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
        MultaccContact contact = contactsData.allContacts[index];
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => Scaffold(
              appBar: AppBar(
                actions: <Widget>[
                  IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () => _deleteContact(contact),
                  ),
                ],
              ),
              body: ContactDetailsPage(contactsData.allContacts[index]),
              floatingActionButton: FloatingActionButton(
                child: Icon(Icons.edit),
                backgroundColor: kPrimaryColor,
                onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                  fullscreenDialog: true,
                  builder: (context) => ContactFormPage(contact: contact),
                )),
              ),
            ),
          ),
        );
      }
    });
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
              contactsData.deleteContact(contact);
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
          )
        ],
      ),
    );
    ;
  }

  // Quietly refresh contacts when returning to foreground
  // @todo Decide if we want to limit the frequency of auto-refreshing contacts
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) contactsData.getAllContacts();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
}
