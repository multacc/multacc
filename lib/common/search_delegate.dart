import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:multacc/common/avatars.dart';
import 'package:multacc/common/theme.dart';
import 'package:multacc/pages/contacts/contact_details_page.dart';
import 'package:multacc/database/contact_model.dart';
import 'package:multacc/pages/contacts/contacts_data.dart';

/// Helper class for searching contacts
/// @todo Add support for searching chats too
class BottomBarSearchDelegate extends SearchDelegate<String> {
  final ContactsData contactsData = GetIt.I.get<ContactsData>();

  @override
  ThemeData appBarTheme(BuildContext context) {
    final theme = Theme.of(context);
    return theme.copyWith(
      primaryColor: kBackgroundColorLight,
      textTheme: theme.textTheme.copyWith(headline6: theme.textTheme.headline6.copyWith(fontSize: 18)),
    );
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
        ? contactsData.allContacts.where((e) => e.name.toLowerCase().contains(query.toLowerCase())).toList()
        : []; // don't show the whole damn list if search query is empty
    // @todo use a better search algorithm

    return ListView.builder(
      padding: EdgeInsets.all(8.0),
      itemCount: results.length,
      itemBuilder: (context, index) {
        final MultaccContact contact = results[index];
        return ListTile(
          contentPadding: EdgeInsets.all(8.0),
          leading: Avatars.buildContactAvatar(memoryImage: contact.avatar),
          title: Text(contact.name),
          onTap: () => Navigator.of(context).push(MaterialPageRoute(
            builder: (_) => ContactDetailsPage(contact),
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
