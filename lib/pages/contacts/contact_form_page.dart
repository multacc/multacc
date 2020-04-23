import 'dart:typed_data';

import 'package:contacts_service/contacts_service.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_pickers/flutter_material_pickers.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

import 'package:multacc/common/theme.dart';
import 'package:multacc/items/email.dart';
import 'package:multacc/items/item.dart';
import 'package:multacc/items/phone.dart';
import 'package:multacc/database/contact_model.dart';
import 'package:multacc/pages/contacts/contacts_data.dart';
import 'package:multacc/common/avatars.dart';
import 'package:multacc/pages/contacts/contact_details_page.dart';

class ContactFormPage extends StatefulWidget {
  final MultaccContact contact;
  final bool isNewContact;
  final bool isProfile;

  ContactFormPage({this.contact, this.isNewContact = false, this.isProfile = false});

  @override
  _ContactForm createState() => _ContactForm(contact);
}

class _ContactForm extends State<ContactFormPage> {
  ContactsData contactsData;
  MultaccContact contact;

  List<String> phoneLabels = [
    'phone',
    'home',
    'work',
    'school',
    'mobile',
    'main',
    'fax home',
    'fax work',
    'pager',
    'other'
  ];
  List<String> emailLabels = [
    'home',
    'work',
    'school',
  ];
  final form = GlobalKey<FormState>();

  // @todo Refactor MultaccItem so base items are handled more cleanly
  // @body Becomes important if we end up using other base contact fields (see #15)
  List<Item> phoneItems = [];
  List<Item> emailItems = [];
  List<MultaccItem> items = [];

  _ContactForm(this.contact);

  Uint8List avatar;

  Future getImage() async {
    var newImage = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (newImage != null) avatar = newImage.readAsBytesSync();
    });
  }

  @override
  void initState() {
    super.initState();
    if ((!widget.isProfile && widget.isNewContact) || contact == null) {
      contact = MultaccContact(clientKey: Uuid().v4());
      items.add(MultaccItemType.Phone.createItem());
      items.add(MultaccItemType.Email.createItem());
    } else {
      items = List.from(contact.multaccItems);
      avatar = contact.avatar;
    }
    contactsData = GetIt.I.get<ContactsData>();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: Navigator.of(context).pop,
            icon: Icon(Icons.close, color: Colors.grey, size: 30),
          ),
          centerTitle: false,
          title: Text(widget.isProfile ? 'Profile' : widget.isNewContact ? 'Create contact' : 'Edit contact', style: kHeaderTextStyle),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: saveChanges,
          backgroundColor: kPrimaryColor,
          child: Icon(Icons.save),
        ),
        body: Form(
          key: form,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                SizedBox(height: 15),
                _buildAvatar(),
                SizedBox(height: 40),
                _buildName(),
                ...items.map((item) => _buildItems(item)),
                // @todo Refactor messy input field logic
                _buildAddItem(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAvatar() {
    return GestureDetector(
      child: Avatars.buildContactAvatar(
        memoryImage: avatar,
        defaultIcon: Icons.add_a_photo,
        radius: 40.0,
      ),
      onTap: getImage,
    );
  }

  Widget _buildName() {
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            SizedBox(
              width: 60,
              child: Icon(Icons.person),
            ),
            Flexible(
              child: TextFormField(
                initialValue: contact.givenName,
                onSaved: (val) => contact.givenName = val,
                decoration: InputDecoration(
                  border: OutlineInputBorder(borderSide: const BorderSide(color: Colors.white70)),
                  enabledBorder: OutlineInputBorder(borderSide: const BorderSide(color: Colors.white70)),
                  focusedBorder: OutlineInputBorder(borderSide: const BorderSide(color: Colors.white70)),
                  labelStyle: TextStyle(color: Colors.grey),
                  fillColor: Colors.white,
                  labelText: 'First name',
                ),
              ),
            ),
            SizedBox(
              width: 60,
              child: null,
            ),
          ],
        ),
        SizedBox(height: 10),
        Row(
          children: <Widget>[
            SizedBox(
              width: 60,
              child: null,
            ),
            Flexible(
              child: TextFormField(
                initialValue: contact.familyName,
                onSaved: (val) => contact.familyName = val,
                decoration: InputDecoration(
                  border: OutlineInputBorder(borderSide: const BorderSide(color: Colors.white70)),
                  enabledBorder: OutlineInputBorder(borderSide: const BorderSide(color: Colors.white70)),
                  focusedBorder: OutlineInputBorder(borderSide: const BorderSide(color: Colors.white70)),
                  labelStyle: TextStyle(color: Colors.grey),
                  fillColor: Colors.white,
                  labelText: 'Last name',
                ),
              ),
            ),
            SizedBox(
              width: 60,
              child: null,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildItems(MultaccItem item) {
    return Column(
      children: <Widget>[
        SizedBox(height: 30, child: null),
        Row(
          children: <Widget>[
            SizedBox(width: 60, child: item.icon),
            Flexible(
              child: TextFormField(
                key: ObjectKey(item),
                initialValue: item.humanReadableValue,
                onSaved: (val) => item.value = val,
                decoration: InputDecoration(
                  border: OutlineInputBorder(borderSide: const BorderSide(color: Colors.white70)),
                  enabledBorder: OutlineInputBorder(borderSide: const BorderSide(color: Colors.white70)),
                  focusedBorder: OutlineInputBorder(borderSide: const BorderSide(color: Colors.white70)),
                  labelStyle: TextStyle(color: Colors.grey),
                  fillColor: Colors.white,
                  labelText: item.type.name,
                ),
              ),
            ),
            SizedBox(
              width: 60,
              child: IconButton(
                onPressed: () => setState(() => items.remove(item)),
                icon: Icon(Icons.close, color: Colors.grey),
              ),
            ),
          ],
        ),
        item.type == MultaccItemType.Phone || item.type == MultaccItemType.Email
            ? Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Row(
                  children: <Widget>[
                    SizedBox(width: 60, child: null),
                    Flexible(
                      child: DropdownButtonFormField(
                        key: ObjectKey(item),
                        value: item.type == MultaccItemType.Phone
                            ? (item as PhoneItem).label ?? phoneLabels.first
                            : (item as EmailItem).label ?? emailLabels.first,
                        items: (item.type == MultaccItemType.Phone ? phoneLabels : emailLabels)
                            .map<DropdownMenuItem<String>>(
                                (String label) => DropdownMenuItem<String>(value: label, child: Text(label)))
                            .toList(),
                        onChanged: (val) => val,
                        onSaved: (val) => item.type == MultaccItemType.Phone
                            ? (item as PhoneItem).label = val
                            : (item as EmailItem).label = val,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(borderSide: const BorderSide(color: Colors.white70)),
                          enabledBorder: OutlineInputBorder(borderSide: const BorderSide(color: Colors.white70)),
                          focusedBorder: OutlineInputBorder(borderSide: const BorderSide(color: Colors.white70)),
                          labelStyle: TextStyle(color: Colors.grey),
                          fillColor: Colors.white,
                          labelText: 'Label',
                        ),
                      ),
                    ),
                    Spacer(),
                  ],
                ),
              )
            : SizedBox(height: 0, child: null),
      ],
    );
  }

  Widget _buildAddItem() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 24.0),
      child: FlatButton(
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 48.0),
        onPressed: showItemTypes,
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(Icons.add, color: kPrimaryColor),
            ),
            Text('Add Contact Info', style: TextStyle(color: kPrimaryColor)),
          ],
        ),
      ),
    );
  }

  void showItemTypes() {
    MultaccItemType selectedItem = MultaccItemType.values.first;
    showMaterialSelectionPicker(
      context: context,
      title: 'Contact Info Type',
      items: MultaccItemType.values.map((e) => e.name).toList(),
      icons: MultaccItemType.values.map((e) => e.icon).toList(),
      headerColor: kBackgroundColorLight,
      selectedItem: selectedItem.name,
      onChanged: (e) {
        selectedItem = EnumToString.fromString(MultaccItemType.values, e);
        setState(() => items.add(selectedItem.createItem()));
      },
    );
  }

  void saveChanges() async {
    if (form.currentState.validate()) {
      contact.avatar = avatar;
      form.currentState.save();

      items.forEach((item) {
        if (item is PhoneItem && item.humanReadableValue != '') {
          phoneItems.add(item.toItem());
        } else if (item is EmailItem && item.humanReadableValue != '') {
          emailItems.add(item.toItem());
        }
      });

      contact.multaccItems = items;
      contact.phones = phoneItems;
      contact.emails = emailItems;
      contact.displayName = '${contact.givenName} ${contact.familyName}';

      if (widget.isProfile) {
        contactsData.updateProfile(contact);
      } else if (widget.isNewContact) {
        contactsData.addContact(contact);
      } else {
        contactsData.updateContact(contact);
        Navigator.of(context).pop();
      }

      // hacky way to refresh contact details page
      Navigator.of(context).pop();
      if (!widget.isProfile) Navigator.of(context).push(MaterialPageRoute(builder: (_) => ContactDetailsPage(contact)));
    }
  }
}
