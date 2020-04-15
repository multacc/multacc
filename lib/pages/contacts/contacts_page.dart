import 'package:draggable_floating_button/draggable_floating_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:multacc/common/avatars.dart';
import 'package:multacc/common/theme.dart';
import 'package:multacc/pages/contacts/contact_form_page.dart';
import 'package:sliding_sheet/sliding_sheet.dart';
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
            builder: (context, state) => ContactDetailsPage(contactsData.allContacts[index]),
            headerBuilder: (_, __) => // drag handle
                Padding(padding: EdgeInsets.all(16.0), child: Icon(Icons.maximize, color: Colors.grey)),
            footerBuilder: (context, state) => Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: DraggableFloatingActionButton(
                    offset: Offset(200, 200),
                    backgroundColor: kPrimaryColor,
                    child: Icon(Icons.edit),
                    appContext: context,
                    onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                      fullscreenDialog: true,
                      builder: (context) => ContactFormPage(contact: contactsData.allContacts[index]),
                    )),
                  ),
                )
              ],
            ),
          ),
        );
      }
    });
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
