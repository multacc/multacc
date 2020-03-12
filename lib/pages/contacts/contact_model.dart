import 'package:contacts_service/contacts_service.dart';
import 'package:multacc/items/item.dart';
import 'package:multacc/items/phone.dart';
import 'package:multacc/items/email.dart';

class MultaccContact extends Contact {
  String serverKey, clientKey;
  List<MultaccItem> multaccItems;

  // Construct a Multacc contact from a Contact
  MultaccContact(Contact baseContact) {
    // Base contact model - stored in contacts app:
    this.androidAccountName = baseContact.androidAccountName;
    this.androidAccountType = baseContact.androidAccountType;
    this.androidAccountTypeRaw = baseContact.androidAccountTypeRaw;
    this.avatar = baseContact.avatar;
    this.birthday = baseContact.birthday;
    this.company = baseContact.company;
    this.displayName = baseContact.displayName;
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
      // @todo Pull multacc items from database when loading a contact
    ];
  }


}
