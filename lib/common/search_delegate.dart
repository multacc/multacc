import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:multacc/common/avatars.dart';
import 'package:multacc/common/theme.dart';
import 'package:multacc/main.dart';
import 'package:multacc/pages/contacts/contact_details_page.dart';
import 'package:multacc/pages/contacts/contact_model.dart';
import 'package:multacc/pages/contacts/contacts_data.dart';

/// Helper class for searching contacts
/// @todo Add support for searching chats too
class BottomBarSearchDelegate extends SearchDelegate<String> {
  final ContactsData contactsData = services.get<ContactsData>();

  @override
  ThemeData appBarTheme(BuildContext context) {
    return Theme.of(context).copyWith(primaryColor: kBackgroundColorLight);
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          // clear search field and show keyboard
          query = '';
          FocusScope.of(context).requestFocus(FocusNode());
          SystemChannels.textInput.invokeMethod('TextInput.show');
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(icon: Icon(Icons.arrow_back), onPressed: () => close(context, ''));
  }

  @override
  Widget buildResults(BuildContext context) {
    final results = query != ''
        ? contactsData.allContacts.where((e) => e.displayName.toLowerCase().contains(query.toLowerCase())).toList()
        : []; // don't show the whole damn list if search query is empty

    return ListView.builder(
      padding: EdgeInsets.all(8.0),
      itemCount: results.length,
      itemBuilder: (context, index) {
        final MultaccContact contact = results[index];
        return ListTile(
          contentPadding: EdgeInsets.all(8.0),
          leading: Avatars.buildContactAvatar(memoryImage: contact.avatar),
          title: Text(results[index].displayName),
          onTap: () => Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => Scaffold(
              appBar: AppBar(), // for back button
              body: ContactDetailsPage(contact),
            ),
          )),
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return buildResults(context); // suggestions don't apply when searching contacts
  }
}
