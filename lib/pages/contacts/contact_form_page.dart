import 'dart:typed_data';

import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';

import 'package:multacc/common/theme.dart';
import 'package:multacc/database/database_interface.dart';
import 'package:multacc/items/email.dart';
import 'package:multacc/items/item.dart';
import 'package:multacc/items/phone.dart';
import 'package:multacc/database/contact_model.dart';
import 'package:multacc/pages/contacts/contacts_data.dart';
import 'package:multacc/common/avatars.dart';

class ContactFormPage extends StatefulWidget {
  final MultaccContact contact;

  ContactFormPage(this.contact);

  @override
  _ContactForm createState() => _ContactForm(contact);
}

class _ContactForm extends State<ContactFormPage> {
  ContactsData contactsData;
  MultaccContact contact;
  List<String> phoneLabels = [
    'home',
    'work',
    'school',
    'phone',
    'mobile',
    'main',
    'home fax',
    'work fax',
    'pager',
  ];
  List<String> emailLabels = [
    'home',
    'work',
    'school',
  ];
  final form = GlobalKey<FormState>();
  DatabaseInterface db;

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
    items = List.from(contact.multaccItems);
    avatar = contact.avatar;
    contactsData = GetIt.I.get<ContactsData>();
    db = GetIt.I.get<DatabaseInterface>();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: Navigator.of(context).pop,
            icon: Icon(Icons.close, color: Colors.grey, size: 30),
          ),
          centerTitle: false,
          title: Text('Edit contact', style: kHeaderTextStyle),
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
                ...MultaccItemType.values.map((type) => _buildAddItem(type))
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
                onPressed: () => deleteItem(item),
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
                    // SizedBox(width: 60, child: null),
                  ],
                ),
              )
            : SizedBox(height: 0, child: null),
      ],
    );
  }

  Widget _buildAddItem(MultaccItemType type) {
    List<Widget> rowWidgets = [
      SizedBox(height: 50, width: 60, child: null),
      Icon(Icons.add, color: kPrimaryColor),
      SizedBox(width: 20),
      Text('Add ', style: TextStyle(color: kPrimaryColor)),
    ];
    if (type.isInputtable) {
      rowWidgets.add(Text(type.name, style: TextStyle(color: kPrimaryColor)));
    }
    if (type.isConnectable) {
      Connector connector = type.connector;
      // @todo Allow connecting items when adding
    }
    return Column(
      children: <Widget>[
        SizedBox(height: 30, child: null),
        InkWell(
          onTap: () => items.add(type.createItem()),
          child: Row(children: rowWidgets),
        ),
      ],
    );
  }

  void deleteItem(MultaccItem item) {
    setState(() {
      items.remove(item);
    });
  }

  void saveChanges() {
    if (form.currentState.validate()) {
      contact.avatar = avatar;
      form.currentState.save();

      items.forEach((item) {
        if (item is PhoneItem) {
          phoneItems.add(item.toItem());
        } else if (item is EmailItem) {
          emailItems.add(item.toItem());
        }
      });

      contact.multaccItems = items;
      contact.phones = phoneItems;
      contact.emails = emailItems;

      // @todo Allow adding new contact

      // Update the base contact on device
      ContactsService.updateContact(contact);

      // Sync local db with device contacts
      contactsData.getAllContacts();

      Navigator.of(context).pop();
    }
  }
}
