import 'package:contacts_service/contacts_service.dart';

class MultaccContact extends Contact {
  bool isSelected;
  String serverKey, clientKey;
  List<MultaccItem> multaccItems;

  // Construct a Multacc contact from a Contact
  MultaccContact(Contact baseContact) {
    // Will not be persisted
    this.isSelected = false;

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
    // @todo Figure out how to store Multacc key in Contact
    // @todo Figure out how IM, notes, etc. are stored in Contact

    // Multacc additional contact data
    this.clientKey = null; // Key in client-side database
    this.serverKey = null; // Key in server-side database
    // @todo Pull multacc items from database when loading a contact
    this.multaccItems = []; // Multacc extension items
  }
}

class MultaccItem {
  // @todo Design MultaccItem class
}