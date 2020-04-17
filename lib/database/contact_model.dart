import 'dart:convert';
import 'dart:typed_data';

import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:multacc/database/type_ids.dart';

import 'package:multacc/items/item.dart';
import 'package:multacc/items/phone.dart';
import 'package:multacc/items/email.dart';

part 'contact_model.g.dart';

@HiveType(typeId: MULTACC_CONTACT_TYPE_ID)
class MultaccContact extends Contact {
  // Stored in the database even though it is the key because this allows the Hive adapter to create a MultaccContact
  // with the appropriate clientKey (database key is not exposed to adapter), thus preventing us from having to manually
  // add the key whenever loading a contact from the database.
  @HiveField(5)
  String clientKey;

  @HiveField(0)
  String serverKey;
  @HiveField(1)
  List<MultaccItem> multaccItems;

  // Contact fields overridden so we can apply hive annotation to them
  @HiveField(2)
  String displayName;
  @HiveField(3)
  Uint8List avatar;
  @HiveField(4)
  DateTime birthday;

  MultaccContact();

  // Construct a Multacc contact from a Contact
  MultaccContact.fromContact(Contact baseContact) {
    // Base contact model - stored in contacts app:
    this.androidAccountName = baseContact.androidAccountName;
    this.androidAccountType = baseContact.androidAccountType;
    this.androidAccountTypeRaw = baseContact.androidAccountTypeRaw;
    this.avatar = baseContact.avatar;
    this.birthday = baseContact.birthday;
    this.company = baseContact.company;
    this.displayName = baseContact.displayName ?? '';
    this.emails = baseContact.emails;
    this.familyName = baseContact.familyName;
    this.givenName = baseContact.givenName;
    this.identifier = baseContact.identifier;
    this.jobTitle = baseContact.jobTitle;
    this.middleName = baseContact.middleName;
    this.phones = baseContact.phones;
    this.postalAddresses = baseContact.postalAddresses;
    this.prefix = baseContact.prefix;
    this.suffix = baseContact.suffix;
    // @todo Get IM, notes, etc. from base contact

    // Multacc additional contact data
    // @todo Use a field other than identifier for clientKey (#26)
    clientKey = identifier; // Key in client-side database
    serverKey = null; // Key in server-side database
    multaccItems = [
      ...phones.toSet().map((item) => PhoneItem.fromItem(item)), // create PhoneItems from phone Items
      ...emails.map((item) => EmailItem.fromItem(item)), // create EmailItems from email Items
      // @todo Convert addresses to Multacc items
      // @todo Convert IM to Multacc items
      // @todo Convert SIP to Multacc items
    ];
  }

  // Get display name for contact
  String get name {
    if (displayName == null || displayName.trim() == '') {
      displayName = [prefix, givenName, middleName, familyName, suffix].where((x) => x != null).join(' ');
    }
    if (displayName != null && displayName.trim() != '') {
      return displayName;
    }
    for (MultaccItem item in multaccItems) {
      if (item.humanReadableValue != '') {
        return item.humanReadableValue;
      }
    }
    return 'Contact';
  }

  // Returns true if the base contact fields match
  bool equalsBaseContact(Contact baseContact) {
    return (listEquals(this.avatar, baseContact.avatar) &&
        this.birthday?.millisecondsSinceEpoch == baseContact.birthday?.millisecondsSinceEpoch &&
        this.company == baseContact.company &&
        this.displayName == baseContact.displayName &&
        listEquals(this.emails?.toList(), baseContact.emails?.toList()) &&
        this.familyName == baseContact.familyName &&
        this.givenName == baseContact.givenName &&
        this.identifier == baseContact.identifier &&
        this.jobTitle == baseContact.jobTitle &&
        this.middleName == baseContact.middleName &&
        listEquals(this.phones?.toList(), baseContact.phones?.toList()) &&
        listEquals(this.postalAddresses?.toList(), baseContact.postalAddresses?.toList()) &&
        this.prefix == baseContact.prefix &&
        this.suffix == baseContact.suffix);
  }

  MultaccContact.fromJson(Map<String, dynamic> json)
      : clientKey = json['clientKey'],
        serverKey = json['serverKey'],
        multaccItems = (json['multaccItems'] as List).map((jsonItem) => MultaccItem.fromDB(jsonItem)).toList(),
        displayName = json['displayName'],
        avatar = base64.decode(json['avatar']),
        birthday = DateTime.parse(json['birthday']);

  Map<String, dynamic> toJson() => {
        'clientKey': clientKey,
        'serverKey': serverKey,
        'multaccItems': multaccItems.map((item) => item.toJson()).toList(),
        'displayName': displayName,
        'avatar': base64.encode(avatar),
        'birthday': birthday.toIso8601String()
      };
}
