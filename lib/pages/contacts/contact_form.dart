import 'dart:typed_data';

import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multacc/common/theme.dart';
import 'package:multacc/database/database_interface.dart';
import 'package:multacc/items/email.dart';
import 'package:multacc/items/item.dart';
import 'package:multacc/items/phone.dart';
import 'package:multacc/items/twitter.dart';
import 'package:multacc/pages/contacts/contact_model.dart';
import 'package:multacc/pages/contacts/contacts_data.dart';

class ContactForm extends StatefulWidget {
  final MultaccContact contact;

  ContactForm(this.contact);

  @override
  _ContactForm createState() => _ContactForm(contact);
}

class _ContactForm extends State<ContactForm> {
  List<MultaccItemType> multaccItemTypes = [
    MultaccItemType.Phone,
    MultaccItemType.Email,
    MultaccItemType.Twitter,
  ];
  ContactsData contactsData;
  MultaccContact contact;
  List<String> phoneLabels =  [
    "home",
    "work",
    "school",
    "phone",
    "mobile",
    "main",
    "home fax",
    "work fax",
    "pager",
  ];
  List<String> emailLabels =  [
    "home",
    "work",
    "school",
  ];
  final form = GlobalKey<FormState>();
  DatabaseInterface db;
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
    items = List.from(contact.multaccItems);
    avatar = contact.avatar;
    contactsData = GetIt.I.get<ContactsData>();

    db = GetIt.I.get<DatabaseInterface>();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: Icon(Icons.close, color: Colors.grey, size: 30),
            ),
            centerTitle: false,
            title: Row(
              children: <Widget>[
                Text("Edit contact", style: kHeaderTextStyle),
                Spacer(),
                GestureDetector(
                  onTap: saveChanges,
                  child: Text("Save",
                      style: TextStyle(color: kPrimaryColor, fontSize: 15)),
                ),
              ],
            ),
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
                  for (MultaccItem item in items) _buildItems(item),
                  _buildAddItem(MultaccItemType.Phone),
                  _buildAddItem(MultaccItemType.Email),
                  _buildAddItem(MultaccItemType.Twitter),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAvatar() {
    return CircleAvatar(
      radius: 35,
      backgroundImage: avatar != null ? MemoryImage(avatar) : null,
      child: Opacity(
        opacity: avatar != null ? 0.5 : 1,
        child: Container(
          height: 100,
          width: 100,
          child: Material(
            color: avatar != null ? Colors.black : kPrimaryColor,
            borderRadius: BorderRadius.all(Radius.circular(35)),
            child: InkWell(
              borderRadius: BorderRadius.all(Radius.circular(35)),
              onTap: getImage,
              child: Padding(
                padding: EdgeInsets.only(right: 2),
                child: Icon(
                  Icons.add_a_photo,
                  size: 26,
                  color: avatar != null ? Colors.white : Colors.black,
                ),
              ),
            ),
          ),
        ),
      ),
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
                  border: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.white70)),
                  enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.white70)),
                  focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.white70)),
                  labelStyle: TextStyle(color: Colors.grey),
                  fillColor: Colors.white,
                  labelText: "First name",
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
                  border: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.white70)),
                  enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.white70)),
                  focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.white70)),
                  labelStyle: TextStyle(color: Colors.grey),
                  fillColor: Colors.white,
                  labelText: "Last name",
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
        SizedBox(height: 30,child: null),
        Row(
          children: <Widget>[
            SizedBox(width: 60,child: item.icon),
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
            SizedBox(width: 60,child: IconButton(onPressed: () {deleteItem(item);}, icon: Icon(Icons.close, color: Colors.grey))),
          ],
        ),
        item.type == MultaccItemType.Phone ||
        item.type == MultaccItemType.Email
        ? Column(
          children: <Widget>[
            SizedBox(height: 10),
            Row(
              children: <Widget>[
                SizedBox(width: 60,child: null),
                Flexible(
                  child: DropdownButtonFormField(
                    key: ObjectKey(item),
                    value: item.type == MultaccItemType.Phone ? (item as PhoneItem).label : (item as EmailItem).label,
                    items: (item.type == MultaccItemType.Phone ? phoneLabels : emailLabels).map<DropdownMenuItem<String>>((String label) => DropdownMenuItem<String>(value: label, child: Text(label))).toList(),
                    onChanged: (val) => val,
                    onSaved: (val) => item.type == MultaccItemType.Phone ? (item as PhoneItem).label = val : (item as EmailItem).label = val,
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
                Spacer(),
                SizedBox(width: 60,child: null),
              ],
            ),
            SizedBox(height: 0, child: null,),
          ],
        )
        : SizedBox(height: 0, child: null),
      ],
    );
  }

  Widget _buildAddItem(MultaccItemType type) {
    return Column(
      children: <Widget>[
        SizedBox(height: 30,child: null),
        InkWell(
          onTap: () {
            switch(type) {
              case MultaccItemType.Twitter:
                setState(() {items.add(TwitterItem());});
                break;
              case MultaccItemType.Phone:
                setState(() {items.add(PhoneItem());});
                break;
              case MultaccItemType.Email:
                setState(() {items.add(EmailItem());});
                break;
              default:
                throw new FormatException('Type is not recognized');
            }
          },
          child: Row(
            children: <Widget>[
              SizedBox(height: 50, width: 60, child: null),
              Icon(Icons.add, color: kPrimaryColor),
              SizedBox(width: 20),
              Text("Add ", style: TextStyle(color: kPrimaryColor)),
              Text(type.name, style: TextStyle(color: kPrimaryColor)),
            ],
          ),
        ),
      ],
    );
  }

  void deleteItem(MultaccItem item) {
    setState(() {items.remove(item);});
  }

  void saveChanges() {
    if (form.currentState.validate()) {
      contact.avatar = avatar;
      // Saves the forms data to the contact
      form.currentState.save();

      contact.multaccItems = items;

      items.forEach((item) {
        if (item.type == MultaccItemType.Phone)
          phoneItems.add(Item(value: item.humanReadableValue, label: (item as PhoneItem).label));
        else if(item.type == MultaccItemType.Email)
          emailItems.add(Item(value: item.humanReadableValue, label: (item as EmailItem).label));
      });

      contact.phones = phoneItems;
      contact.emails = emailItems;

      // Updates the base contact
      ContactsService.updateContact(contact);

      // Updates contact information throughout app
      contactsData.getAllContacts();

      //Navigates off of the edit page
      Navigator.of(context).pop();
    }
  }
}
