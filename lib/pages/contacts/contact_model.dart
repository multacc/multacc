import 'package:contacts_service/contacts_service.dart';

class ContactModel extends Contact {
  bool isSelected;

  // copy constructor
  ContactModel(Contact baseContact) {
    this.isSelected = false;
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
  }
}